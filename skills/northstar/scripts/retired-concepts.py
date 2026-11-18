#!/usr/bin/env python3
"""Retired-concepts check: fails when a concept listed in
docs/knowledge/retired.toml still appears in the working tree (tracked or new
files; ignored files and unstaged deletions don't count).

Usage: retired-concepts.py [--repo <path>] [--retired <file>] [--json]
--retired audits against a list outside the repository, for example while
preparing a migration before docs/knowledge/retired.toml exists.
Exit: 0 clean, 1 findings, 2 usage or configuration error.
Needs Python 3.8+ and Git; nothing else.
"""
import json, os, posixpath, re, subprocess, sys, tempfile

RETIRED_FILE = "docs/knowledge/retired.toml"


def fail(message):
    print(f"retired-concepts: {message}", file=sys.stderr)
    sys.exit(2)


def parse_args(argv):
    repo, as_json, retired = os.getcwd(), False, None
    it = iter(argv)
    for arg in it:
        if arg == "--repo":
            repo = next(it, None) or fail("--repo needs a path")
        elif arg == "--retired":
            retired = next(it, None) or fail("--retired needs a file")
        elif arg == "--json":
            as_json = True
        else:
            fail(f"unknown argument {arg}")
    return os.path.abspath(repo), as_json, os.path.abspath(retired) if retired else None


# --- TOML -------------------------------------------------------------------
# tomllib arrived in Python 3.11. Older interpreters get a small parser for the
# subset retired.toml uses: comments, top-level keys, [[array-of-tables]],
# strings, string arrays (multi-line, trailing commas, inline comments).

class TomlError(Exception):
    pass


def parse_toml(text):
    try:
        import tomllib
    except ImportError:
        return _parse_toml_subset(text)
    try:
        return tomllib.loads(text)
    except tomllib.TOMLDecodeError as error:
        raise TomlError(str(error))


_TOKEN = re.compile(r'''
    (?P<ws>[ \t\r]+) | (?P<comment>\#[^\n]*) | (?P<nl>\n)
  | (?P<aot>^\[\[[ \t]*(?P<aotname>[A-Za-z0-9_-]+)[ \t]*\]\])
  | (?P<key>^[A-Za-z0-9_-]+(?=[ \t]*=))
  | (?P<basic>"(?:[^"\\\n]|\\.)*") | (?P<literal>'[^'\n]*')
  | (?P<punct>[=\[\],])
''', re.X | re.M)


def _parse_toml_subset(text):
    tokens, pos = [], 0
    while pos < len(text):
        m = _TOKEN.match(text, pos)
        if not m:
            line = text.count("\n", 0, pos) + 1
            raise TomlError(f"unsupported syntax at line {line}")
        pos = m.end()
        kind = m.lastgroup if m.lastgroup != "aotname" else "aot"
        if kind in ("ws", "comment"):
            continue
        if kind == "aot":
            tokens.append(("aot", m.group("aotname")))
        elif kind == "basic":
            try:
                tokens.append(("str", json.loads(m.group())))
            except ValueError:
                raise TomlError(f"bad string {m.group()}")
        elif kind == "literal":
            tokens.append(("str", m.group()[1:-1]))
        else:
            tokens.append((kind, m.group()))
    doc, table, i = {}, None, 0

    def skip_nl(i):
        while i < len(tokens) and tokens[i][0] == "nl":
            i += 1
        return i

    while True:
        i = skip_nl(i)
        if i >= len(tokens):
            return doc
        kind, value = tokens[i]
        if kind == "aot":
            table = {}
            doc.setdefault(value, []).append(table)
            i += 1
            continue
        if kind != "key" or i + 2 >= len(tokens) or tokens[i + 1][1] != "=":
            raise TomlError(f"expected key = value near {value!r}")
        target = table if table is not None else doc
        i += 2
        kind2, value2 = tokens[i]
        if kind2 == "str":
            target[value] = value2
            i += 1
        elif value2 == "[":
            items, i = [], i + 1
            while True:
                i = skip_nl(i)
                if i >= len(tokens):
                    raise TomlError(f"unterminated array for {value}")
                k, v = tokens[i]
                if v == "]":
                    i += 1
                    break
                if k != "str":
                    raise TomlError(f"only string arrays are supported ({value})")
                items.append(v)
                i = skip_nl(i + 1)
                if i < len(tokens) and tokens[i][1] == ",":
                    i += 1
            target[value] = items
        else:
            raise TomlError(f"unsupported value for {value}")
        if i < len(tokens) and tokens[i][0] != "nl":
            raise TomlError(f"trailing content after {value}")


# --- search -----------------------------------------------------------------

def git(repo, args):
    return subprocess.run(["git", *args], cwd=repo, capture_output=True, text=True,
                          encoding="utf-8", errors="replace")


def glob_regex(pattern):
    """An allow entry matches an exact file or, with a trailing slash, a
    directory. `*` matches within one path segment, `**` across segments."""
    body = ".*".join("[^/]*".join(re.escape(p) for p in part.split("*")) for part in pattern.split("**"))
    return re.compile("^" + body + ("" if pattern.endswith("/") else "(/|$)"))


def allowed(file, allow):
    return any(glob_regex(p).search(file) for p in allow)


def is_path_like(needle):
    """No whitespace and contains "/" or "." names a path: matched
    case-sensitively and only at a path boundary."""
    return not re.search(r"\s", needle) and re.search(r"[/.]", needle) is not None


def at_path_boundary(text, needle):
    i = text.find(needle)
    while i != -1:
        if i == 0 or not re.match(r"[A-Za-z0-9_.-]", text[i - 1]):
            return True
        i = text.find(needle, i + 1)
    return False


def split_row(row):
    file, line, text = row.split(":", 2)
    return file, int(line), text


def grep_rows(repo, patterns, pathspec, ignore_case=False):
    """One `git grep -f` pass for every pattern. --untracked also searches new
    files; unstaged deletions are absent from the working tree."""
    with tempfile.NamedTemporaryFile("w", suffix=".txt", delete=False, encoding="utf-8") as f:
        f.write("\n".join(patterns) + "\n")
        name = f.name
    try:
        args = ["grep", "--untracked", "-n", "-I", "-F", "--no-color", "-f", name, "--", pathspec]
        if ignore_case:
            args.insert(4, "-i")
        result = git(repo, args)
    finally:
        os.unlink(name)
    if result.returncode == 1:
        return []
    if result.returncode != 0:
        fail(f"git grep failed: {result.stderr.strip()}")
    return [split_row(r) for r in result.stdout.split("\n") if r]


def grep_all(repo, needles):
    """Ordinary terms ignore case; path needles match case-sensitively at a
    path boundary. Each matching line is read once; the needles it contains
    are worked out in memory."""
    index = {n: [] for n in needles}
    for ignore_case, group in ((True, [n for n in needles if not is_path_like(n)]),
                               (False, [n for n in needles if is_path_like(n)])):
        if not group:
            continue
        lowered = [n.lower() for n in group] if ignore_case else group
        for file, line, full in grep_rows(repo, group, ".", ignore_case):
            hay = full.lower() if ignore_case else full
            for needle, low in zip(group, lowered):
                if low in hay and (ignore_case or at_path_boundary(full, needle)):
                    index[needle].append({"file": file, "line": line, "text": full.strip()[:200]})
    return index


def relative_pointer(file, text, tail, target):
    """Does `text`, in `file`, name the retired `target` relatively via `tail`?"""
    at = text.find(tail)
    while at != -1:
        start = at
        while text[max(start - 3, 0):start] == "../" and start >= 3:
            start -= 3
        if start >= 2 and text[start - 2:start] == "./":
            start -= 2
        nxt = text.find(tail, at + 1)
        # Preceded by a path segment means another path (or the root form,
        # which the ordinary search already reports).
        if start > 0 and re.match(r"[A-Za-z0-9_./-]", text[start - 1]):
            at = nxt
            continue
        # The pointer marker follows the whole path, which for a directory
        # retirement runs past the tail (`roadmaps/g02/x.md` (Git history)).
        rest = re.match(r"[^\s`)\]]*", text[at + len(tail):]).group()
        after = text[at + len(tail) + len(rest):]
        if re.match(r"`? \((in )?Git history\)", after):
            at = nxt
            continue
        resolved = posixpath.normpath(posixpath.join(posixpath.dirname(file), text[start:at + len(tail)])).rstrip("/")
        if resolved == target:
            return True
        at = nxt
    return False


def relative_all(repo, retired_paths):
    """A Markdown file inside a retired path's parent directory can name it
    relatively: `plan.md` in docs/AGENTS.md, or `../plan.md` in
    docs/knowledge/x.md, both mean docs/plan.md. Config files resolve paths
    from wherever their command runs, so only Markdown counts."""
    combos = []
    for path in dict.fromkeys(retired_paths):
        is_dir = path.endswith("/")
        target = path.rstrip("/")
        parts = target.split("/")
        for level in range(1, len(parts)):
            combos.append((path, "/".join(parts[:level]), "/".join(parts[level:]) + ("/" if is_dir else ""), target))
    by_path = {}
    if not combos:
        return by_path
    found = {c: [] for c in combos}
    rows = grep_rows(repo, list(dict.fromkeys(c[2] for c in combos)), ":(glob)**/*.md")
    for file, line, text in rows:
        for combo in combos:
            _, directory, tail, target = combo
            if file.startswith(directory + "/") and tail in text and relative_pointer(file, text, tail, target):
                found[combo].append({"file": file, "line": line, "text": text.strip()[:200]})
    for combo in combos:
        by_path.setdefault(combo[0], []).extend(found[combo])
    return by_path


def main():
    repo, as_json, retired = parse_args(sys.argv[1:])
    if git(repo, ["rev-parse", "--is-inside-work-tree"]).returncode != 0:
        fail(f"{repo} is not a Git checkout")
    path = retired or os.path.join(repo, RETIRED_FILE)
    if not os.path.exists(path):
        if as_json:
            print(json.dumps({"status": "ok", "entries": 0, "findings": []}))
        else:
            print(f"retired-concepts: no {RETIRED_FILE}; nothing to check")
        return 0
    try:
        with open(path, encoding="utf-8") as f:
            parsed = parse_toml(f.read())
    except TomlError as error:
        fail(f"{path} is not valid TOML: {error}")
    entries = parsed.get("retired", [])
    frozen = parsed.get("frozen", [])
    # The working tree as it is: tracked and new files that exist on disk, so
    # the check gives the same answer before and after a migration is staged.
    listed = git(repo, ["ls-files", "-z", "--cached", "--others", "--exclude-standard"]).stdout.split("\0")
    tracked = [f for f in listed if f and os.path.exists(os.path.join(repo, f))]
    needles, retired_paths = [], []
    for entry in entries:
        for needle in entry.get("terms", []) + entry.get("config_keys", []) + entry.get("paths", []):
            needles.append(needle)
        retired_paths += entry.get("paths", [])
    hits = grep_all(repo, list(dict.fromkeys(needles)))
    relative = relative_all(repo, retired_paths)

    findings, seen = [], set()
    for entry in entries:
        if not entry.get("id"):
            fail(f"an entry in {path} has no id")
        eid = entry["id"]
        # The retired list and the owning file name the concept on purpose;
        # frozen artefacts are exempt from every retirement.
        allow = [RETIRED_FILE] + ([entry["owner"]] if entry.get("owner") else []) + entry.get("allow", []) + frozen

        def add(finding):
            key = (finding["id"], finding["file"], finding.get("line", ""), finding["needle"])
            if key not in seen and not allowed(finding["file"], allow):
                seen.add(key)
                findings.append(finding)

        def add_hit(kind, needle, hit):
            # A permalink pinned to a commit (…/blob/<sha>/…) is a history pointer.
            pin = re.compile(r"/blob/[0-9a-f]{7,40}/[^\s)]*" + re.escape(needle.rstrip("/")), re.I)
            if not pin.search(hit["text"]):
                add({"id": eid, "kind": kind, "needle": needle, **hit})

        for term in entry.get("terms", []):
            for hit in hits.get(term, []):
                add_hit("term", term, hit)
        for key in entry.get("config_keys", []):
            for hit in hits.get(key, []):
                add_hit("config_key", key, hit)
        for p in entry.get("paths", []):
            # A trailing slash names a directory, so `src/media/` doesn't match
            # `src/media-locator.ts`. Without one, the path names a file.
            prefix, is_dir = p.rstrip("/"), p.endswith("/")
            for t in tracked:
                if t == prefix or (is_dir and t.startswith(prefix + "/")):
                    add({"id": eid, "kind": "tracked_path", "needle": p, "file": t})
            for hit in hits.get(p, []) + relative.get(p, []):
                add_hit("path", p, hit)

    n = len(entries)
    if as_json:
        print(json.dumps({"status": "violations" if findings else "ok", "entries": n, "findings": findings}, indent=2))
    elif not findings:
        print(f"retired-concepts: OK ({n} retired concept{'' if n == 1 else 's'})")
    else:
        print(f"retired-concepts: {len(findings)} live reference{'' if len(findings) == 1 else 's'} to retired concepts")
        for f in findings:
            where = f"{f['file']}:{f['line']}" if f.get("line") else f["file"]
            text = f" — {f['text']}" if f.get("text") else ""
            print(f"  [{f['id']}] {f['kind']} \"{f['needle']}\" at {where}{text}")
    return 1 if findings else 0


if __name__ == "__main__":
    sys.exit(main())

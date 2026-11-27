#!/usr/bin/env python3
"""Find broken relative Markdown links and anchors across a repository.

Usage:
  check-links.py [--repo <path>] [--frozen <regex>]...

Checks inline links and reference definitions in tracked or unignored UTF-8
Markdown files up to 3 MB. It checks anchors against Markdown headings and
explicit HTML anchors. It skips code spans and top-level code blocks. Use
--frozen <regex> to exclude paths such as fixtures or released artefacts.
Exit: 0 clean, 1 problems found, 2 usage error.
Needs Python 3.8+ and Git; nothing else.
"""
import os, re, string, subprocess, sys
from urllib.parse import unquote


def die(msg):
    print(f"check-links: {msg}", file=sys.stderr)
    sys.exit(2)


def parse_args(argv):
    opts = {"repo": os.getcwd(), "frozen": []}
    i = 0
    while i < len(argv):
        a = argv[i]
        if a in ("--repo", "--frozen"):
            if i + 1 == len(argv) or argv[i + 1] in ("--repo", "--frozen"):
                die(f"{a} requires a value")
            i += 1
            if a == "--repo": opts["repo"] = argv[i]
            else: opts["frozen"].append(argv[i])
        else:
            die(f"unexpected argument {a}\nusage: check-links.py [--repo <path>] [--frozen <regex>]...")
        i += 1
    opts["repo"] = os.path.abspath(opts["repo"])
    return opts


# Even number of backslashes: the following delimiter is unescaped.
EVEN_BS = r"(?<!\\)(?:\\\\)*"
BARE_TARGET = r"(?:\\[^\n]|[^()\s\\]|\((?:\\[^\n]|[^()\s\\])*\))+"
TARGET = rf"(?P<target><[^>\n]+>|{BARE_TARGET})"
TITLE = r"""(?:"(?:\\[^\n]|[^"\\\n])*"|'(?:\\[^\n]|[^'\\\n])*'|\((?:\\[^\n]|[^()\\\n])*\))"""
LABEL_CHAR = r"(?:\\[^\n]|[^\[\]\\])"
REF_CHAR = r"(?:\\[^\n]|[^\[\]\\\n])"
LABEL = rf"\[(?P<label>(?:{LABEL_CHAR}|\[{LABEL_CHAR}*\])*)\]"
INLINE_DEST = rf"\(\s*{TARGET}(?:\s+{TITLE})?\s*\)"
LINK = re.compile(rf"{EVEN_BS}{LABEL}{INLINE_DEST}")
IMAGE = re.compile(rf"{EVEN_BS}!{LABEL}{INLINE_DEST}")
REFLINK = re.compile(rf"{EVEN_BS}(?P<bang>!)?{LABEL}\[(?P<ref>{REF_CHAR}*)\]")
REFDEF = re.compile(rf" {{0,3}}\[(?P<label>{REF_CHAR}+)\]:[ \t]*(?:\n[ \t]*)?"
                    rf"{TARGET}(?:[ \t]+{TITLE})?[ \t]*(?=\n|\Z)")
CODE_SPAN = re.compile(rf"(?P<esc>{EVEN_BS})(?<!`)(?P<ticks>`+)(?!`).*?(?<!`)(?P=ticks)(?!`)", re.S)
HTML_ATTRS = r"""(?:\s(?:[^"'>\n]|"[^"\n]*"|'[^'\n]*')*)?"""
HTML_TAG = re.compile(rf"</?[a-zA-Z][a-zA-Z0-9-]*{HTML_ATTRS}/?>|<!--.*?-->")
OPEN_TAG = re.compile(rf"<(?P<tag>[a-zA-Z][a-zA-Z0-9-]*)(?P<attrs>{HTML_ATTRS})/?>")
HTML_ATTR = re.compile(r"""([a-zA-Z_:][\w:.-]*)\s*=\s*(?:"([^"\n]+)"|'([^'\n]+)')""")
UNDERSCORE_EM = re.compile(r"(?<![\w\\])(_{1,3})(?=\S)(.+?)(?<=\S)(?<!\\)\1(?!\w)")
ESCAPE = re.compile(rf"\\([{re.escape(string.punctuation)}])")
EXTERNAL = re.compile(r"^[a-zA-Z][\w+.-]*:")
FENCE = re.compile(r"^ {0,3}(`{3,}|~{3,})(.*)$")
FRONTMATTER = re.compile(r"\A---[ \t]*\r?\n(?:.*?\r?\n)??(?:---|\.\.\.)[ \t]*(?:\r?\n|\Z)", re.S)
LIST_ITEM = re.compile(r"^ {0,3}(?:[-+*]|\d{1,9}[.)])[ \t]+")
HEADING = re.compile(r"^ {0,3}(?:#{1,6}[ \t]+(.+?)[ \t]*#*[ \t]*$|"
                     r"([^#\s][^\n]*?)\n {0,3}(?:=+|-+)[ \t]*$)", re.M)


def without_code_blocks(text):
    fence = ""
    indented = in_list = False
    after_blank = True
    lines = []
    for line in text.splitlines():
        match = FENCE.match(line)
        if fence:
            if match and match[1].startswith(fence) and not match[2].strip():
                fence = ""
                lines.append("")
                after_blank = True
            continue
        if not line.strip():
            lines.append("")
            after_blank = True
            continue
        has_indent = line.expandtabs(4).startswith("    ")
        if has_indent and (indented or (after_blank and not in_list)):
            indented = True
            continue
        indented = False
        if not has_indent:
            if LIST_ITEM.match(line):
                in_list = True
            elif not line[0].isspace():
                in_list = False
        if match and (match[1][0] == "~" or "`" not in match[2]):
            fence = match[1]
            continue
        lines.append(line)
        after_blank = False
    return "\n".join(lines)


def git(root, *args):
    result = subprocess.run(["git", "-C", root, *args], capture_output=True)
    if result.returncode != 0:
        die(f"git {args[0]} failed: {os.fsdecode(result.stderr).strip()}")
    return os.fsdecode(result.stdout)


def read_text(path):
    try:
        if os.path.getsize(path) > 3_000_000: return None
        with open(path, encoding="utf-8-sig") as f: return f.read()
    except (UnicodeDecodeError, OSError):
        return None


def strip_code_spans(text):
    paragraphs = re.split(r"\n[ \t]*\n", text)
    return "\n\n".join(
        CODE_SPAN.sub(
            lambda m: m["esc"] + re.sub(r"[^\n]", " ", m[0][len(m["esc"]):]),
            paragraph,
        )
        for paragraph in paragraphs
    )


def split_target(t):
    match = re.search(rf"{EVEN_BS}#", t)
    if match:
        idx = match.end() - 1
        path, frag = t[:idx], t[idx + 1:]
    else:
        path, frag = t, ""
    query = re.search(rf"{EVEN_BS}\?", path)
    if query:
        path = path[:query.end() - 1]
    return unquote(ESCAPE.sub(r"\1", path)), unquote(ESCAPE.sub(r"\1", frag))


def slug(heading):
    return re.sub(r"[^\w\- ]", "", heading.strip().lower()).replace(" ", "-")


def reference_key(label):
    return " ".join(label.split()).casefold()


def strip_body(text):
    return without_code_blocks(FRONTMATTER.sub("", text))


def strip_heading_markup(heading, references):
    spans = []
    sentinel = "\x00"
    while sentinel in heading:
        sentinel += "\x00"

    def save_span(match):
        esc = match["esc"]
        spans.append(match[0][len(esc):])
        return f"{esc}{sentinel}{len(spans) - 1}{sentinel}"

    def restore(text):
        if not spans:
            return text
        return re.sub(rf"{sentinel}(\d+){sentinel}", lambda m: spans[int(m[1])], text)

    def reference_label(match):
        label = match["label"]
        key = reference_key(restore(match["ref"] or label))
        if key not in references:
            return match[0]
        return "" if match["bang"] else label

    masked = CODE_SPAN.sub(save_span, heading)
    while True:
        updated = REFLINK.sub(reference_label, LINK.sub(r"\g<label>", IMAGE.sub("", masked)))
        if updated == masked:
            break
        masked = updated
    masked = HTML_TAG.sub("", masked)
    while True:
        updated = UNDERSCORE_EM.sub(r"\2", masked)
        if updated == masked:
            break
        masked = updated
    return restore(masked)


def refdefs(text):
    at_start = True
    pos = 0
    while pos < len(text):
        if at_start:
            match = REFDEF.match(text, pos)
            if match and match["label"].strip():
                yield match
                pos = match.end()
                if pos < len(text) and text[pos] == "\n":
                    pos += 1
                continue
        nl = text.find("\n", pos)
        end = len(text) if nl == -1 else nl
        at_start = not text[pos:end].strip()
        pos = end + 1 if nl != -1 else len(text)


def anchors(path, cache):
    if path not in cache:
        text = strip_body(read_text(path) or "")
        references = {reference_key(match["label"]) for match in refdefs(text)}

        seen, out = {}, set()
        for atx, setext in HEADING.findall(text):
            base = slug(strip_heading_markup(atx or setext, references))
            candidate = base
            n = seen.get(base, 0)
            while candidate in out:
                n += 1
                candidate = f"{base}-{n}"
            seen[base] = n
            out.add(candidate)
        for tag_match in OPEN_TAG.finditer(strip_code_spans(text)):
            attrs = tag_match["attrs"]
            if not attrs:
                continue
            tag = tag_match["tag"].lower()
            for name, dq, sq in HTML_ATTR.findall(attrs):
                attr = name.lower()
                if attr == "id" or (tag == "a" and attr == "name"):
                    out.add(dq or sq)
        cache[path] = out
    return cache[path]


def inline_targets(text):
    for match in LINK.finditer(text):
        yield match["target"]
        yield from inline_targets(match["label"])


def main():
    opts = parse_args(sys.argv[1:])
    root = opts["repo"]
    try:
        frozen = [re.compile(p) for p in opts["frozen"]]
        root = git(root, "rev-parse", "--show-toplevel").rstrip("\r\n")
        paths = git(root, "ls-files", "-z", "--cached", "--others",
                    "--exclude-standard", "*.md")
    except (OSError, re.error) as error:
        die(str(error))
    problems = []
    anchor_cache = {}
    for f in paths.split("\0"):
        if not f: continue
        if any(p.search(f) for p in frozen): continue
        text = read_text(os.path.join(root, f))
        if text is None: continue
        body = strip_body(text)
        targets = list(inline_targets(strip_code_spans(body))) + [m["target"] for m in refdefs(body)]
        for target in targets:
            if target.startswith("<"): target = target[1:-1]
            if EXTERNAL.match(target) or target.startswith("/"): continue
            path, frag = split_target(target)
            full = os.path.normpath(os.path.join(root, os.path.dirname(f), path)) if path else os.path.join(root, f)
            if path:
                try:
                    in_repo = os.path.commonpath([root, full]) == root
                except ValueError:
                    in_repo = False
                if not in_repo:
                    problems.append(f"{f}: escapes repo {target}")
                    continue
                if not os.path.exists(full):
                    problems.append(f"{f}: missing {target}")
                    continue
            if frag and full.endswith(".md") and os.path.isfile(full) and frag not in anchors(full, anchor_cache):
                problems.append(f"{f}: missing anchor {target}")
    for p in problems: print(p)
    print(f"check-links: {'OK' if not problems else str(len(problems)) + ' problem(s)'}")
    sys.exit(1 if problems else 0)


if __name__ == "__main__":
    main()

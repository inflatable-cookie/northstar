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


BARE_TARGET = r"(?:\\[^\n]|[^()\s\\]|\((?:\\[^\n]|[^()\s\\])*\))+"
TARGET = rf"(?P<target><[^>\n]+>|{BARE_TARGET})"
TITLE = r"""(?:"[^"\n]*"|'[^'\n]*'|\([^()\n]*\))"""
# An opening bracket is escaped when preceded by an odd number of backslashes.
LINK_LABEL = r"(?<!\\)(?:\\\\)*\[(?P<label>(?:[^\[\]]|\[[^\]]*\])*)\]"
LINK = re.compile(rf"{LINK_LABEL}\(\s*{TARGET}(?:\s+{TITLE})?\s*\)")
REFLINK = re.compile(rf"{LINK_LABEL}\[(?P<ref>[^\]\n]*)\]")
REFDEF = re.compile(rf"^ {{0,3}}\[(?P<label>[^\]\n]+)\]:[ \t]*(?:\n[ \t]*)?"
                    rf"{TARGET}(?:[ \t]+{TITLE})?[ \t]*$", re.M)
CODE_SPAN = re.compile(r"(?<!`)(`+)(?!`).*?(?<!`)\1(?!`)", re.S)
ESCAPE = re.compile(rf"\\([{re.escape(string.punctuation)}])")
EXTERNAL = re.compile(r"^[a-zA-Z][\w+.-]*:")
FENCE = re.compile(r"^ {0,3}(`{3,}|~{3,})(.*)$")
FRONTMATTER = re.compile(r"\A---[ \t]*\r?\n(?:.*?\r?\n)??---[ \t]*(?:\r?\n|\Z)", re.S)
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
        with open(path, encoding="utf-8") as f: return f.read()
    except (UnicodeDecodeError, OSError):
        return None


def strip_code_spans(text):
    paragraphs = re.split(r"\n[ \t]*\n", text)
    return "\n\n".join(
        CODE_SPAN.sub(lambda m: re.sub(r"[^\n]", " ", m[0]), paragraph)
        for paragraph in paragraphs
    )


def split_target(t):
    match = re.search(r"(?<!\\)(?:\\\\)*#", t)
    if match:
        idx = match.end() - 1
        path, frag = t[:idx], t[idx + 1:]
    else:
        path, frag = t, ""
    return unquote(ESCAPE.sub(r"\1", path)), unquote(ESCAPE.sub(r"\1", frag))


def slug(heading):
    return re.sub(r"[^\w\- ]", "", heading.strip().lower()).replace(" ", "-")


def reference_key(label):
    return " ".join(label.split()).casefold()


def strip_body(text):
    return without_code_blocks(FRONTMATTER.sub("", text))


def strip_heading_links(heading, references):
    spans = []
    sentinel = "\x00"
    while sentinel in heading:
        sentinel += "\x00"

    def save_span(match):
        spans.append(match[0])
        return f"{sentinel}{len(spans) - 1}{sentinel}"

    def restore(text):
        if not spans:
            return text
        return re.sub(rf"{sentinel}(\d+){sentinel}", lambda m: spans[int(m[1])], text)

    def reference_label(match):
        label = match["label"]
        key = reference_key(restore(match["ref"] or label))
        return label if key in references else match[0]

    masked = CODE_SPAN.sub(save_span, heading)
    while True:
        updated = LINK.sub(r"\g<label>", masked)
        if updated == masked:
            break
        masked = updated
    masked = REFLINK.sub(reference_label, masked)
    return restore(masked)


def anchors(path, cache):
    if path not in cache:
        text = strip_body(read_text(path) or "")
        references = {reference_key(match["label"]) for match in REFDEF.finditer(text)}

        seen, out = {}, set()
        for atx, setext in HEADING.findall(text):
            base = slug(strip_heading_links(atx or setext, references))
            n = seen.get(base, 0)
            out.add(base if n == 0 else f"{base}-{n}")
            seen[base] = n + 1
        out |= set(re.findall(r'<a\s+(?:name|id)="([^"]+)"', strip_code_spans(text)))
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
        text = strip_code_spans(strip_body(text))
        targets = list(inline_targets(text)) + [m["target"] for m in REFDEF.finditer(text)]
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

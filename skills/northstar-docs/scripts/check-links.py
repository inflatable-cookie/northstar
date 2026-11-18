#!/usr/bin/env python3
"""Find broken relative Markdown links and anchors across a repository.

Usage:
  check-links.py [--repo <path>] [--frozen <regex>]...

Checks every tracked or untracked (not ignored) Markdown file. Frozen paths are
regular expressions for files to skip: released artefacts, vendored mirrors,
fixtures. Links inside code spans and fenced blocks are ignored.
Exit: 0 clean, 1 problems found, 2 usage error.
Needs Python 3.8+ and Git; nothing else.
"""
import os, re, subprocess, sys


def die(msg):
    print(f"check-links: {msg}", file=sys.stderr)
    sys.exit(2)


def parse_args(argv):
    opts = {"repo": os.getcwd(), "frozen": []}
    i = 0
    while i < len(argv):
        a = argv[i]
        if a in ("--repo", "--frozen") and i + 1 < len(argv):
            i += 1
            if a == "--repo": opts["repo"] = argv[i]
            else: opts["frozen"].append(argv[i])
        else:
            die(f"unexpected argument {a}\nusage: check-links.py [--repo <path>] [--frozen <regex>]...")
        i += 1
    opts["repo"] = os.path.abspath(opts["repo"])
    return opts


LINK = re.compile(r"(!?\[)((?:[^\[\]]|\[[^\]]*\])*)\]\(\s*(<[^>]+>|[^)\s]+)(\s+\"[^\"]*\")?\s*\)")
# CommonMark: at most three spaces of indent. The target must look like a link,
# so a list continuation such as "[0.05, 0.95]: the ..." isn't mistaken for one.
REFDEF = re.compile(r"^( {0,3}\[[^\]]+\]:[ \t]*)((?:<[^>]+>)|(?:[^\s]*[/.#][^\s]*))(.*)$", re.M)
EXTERNAL = re.compile(r"^[a-zA-Z][\w+.-]*:")


def read_text(path):
    try:
        if os.path.getsize(path) > 3_000_000: return None
        with open(path, encoding="utf-8") as f: return f.read()
    except (UnicodeDecodeError, FileNotFoundError, IsADirectoryError):
        return None


def split_target(t):
    t = t[1:-1] if t.startswith("<") else t
    path, _, frag = t.partition("#")
    return path, (frag if "#" in t else None)


def slug(heading):
    return re.sub(r"[^\w\- ]", "", heading.strip().lower()).replace(" ", "-")


_anchors = {}


def anchors(path):
    if path not in _anchors:
        text = read_text(path) or ""
        seen, out = {}, set()
        for h in re.findall(r"^#{1,6}\s+(.+?)\s*#*\s*$", text, re.M):
            # GitHub keeps underscores in anchors, so only markup is stripped.
            base = slug(re.sub(r"`|\*|\[|\]\([^)]*\)", "", h))
            n = seen.get(base, 0)
            out.add(base if n == 0 else f"{base}-{n}")
            seen[base] = n + 1
        out |= set(re.findall(r'<a\s+(?:name|id)="([^"]+)"', text))
        _anchors[path] = out
    return _anchors[path]


def main():
    opts = parse_args(sys.argv[1:])
    root = opts["repo"]
    frozen = [re.compile(p) for p in opts["frozen"]]
    r = subprocess.run(["git", "-C", root, "ls-files", "--cached", "--others", "--exclude-standard", "*.md"],
                       capture_output=True, text=True)
    if r.returncode != 0: die(f"git ls-files failed: {r.stderr.strip()}")
    problems = []
    for f in r.stdout.splitlines():
        if any(p.search(f) for p in frozen): continue
        text = read_text(os.path.join(root, f))
        if text is None: continue
        text = re.sub(r"```.*?```", "", text, flags=re.S)
        text = re.sub(r"`[^`\n]*`", "", text)  # links shown inside code spans aren't links
        for m in list(LINK.finditer(text)) + list(REFDEF.finditer(text)):
            target = m.group(3) if m.re is LINK else m.group(2)
            if EXTERNAL.match(target) or target.startswith("/"): continue
            path, frag = split_target(target)
            full = os.path.normpath(os.path.join(root, os.path.dirname(f), path)) if path else os.path.join(root, f)
            if path and not os.path.exists(full):
                problems.append(f"{f}: missing {target}")
                continue
            if frag and full.endswith(".md") and os.path.isfile(full) and frag not in anchors(full):
                problems.append(f"{f}: missing anchor {target}")
    for p in problems: print(p)
    print(f"check-links: {'OK' if not problems else str(len(problems)) + ' problem(s)'}")
    sys.exit(1 if problems else 0)


if __name__ == "__main__":
    main()

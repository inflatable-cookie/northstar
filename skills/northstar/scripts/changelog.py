#!/usr/bin/env python3
"""Changelog fragments: one small file per unreleased change under
changelog.d/, folded into CHANGELOG.md when a release is cut.

Usage:
  changelog.py check [--repo <path>]
  changelog.py fold --version <version> [--date YYYY-MM-DD] [--repo <path>] [--dry-run]

A fragment is changelog.d/<name>.<type>.md. Name it with a task or PR
reference plus a short slug so two branches never collide; type is one of
added changed fixed removed security. The body is one entry of a line or two:
wrapped lines join, a blank line inside is malformed.

fold inserts `## [<version>] - <date>` below `## [Unreleased]`, entries in a
stable order (by type, then name), deletes the folded fragments and leaves
changelog.d/.gitkeep so the adoption marker survives in Git. --dry-run prints
the resulting CHANGELOG.md and writes nothing.

check fails when a fragment is malformed, or, once changelog.d/ exists, when
CHANGELOG.md or its `## [Unreleased]` heading is missing or the section holds
direct content.
Exit: 0 clean or folded, 1 problems, 2 usage error.
Needs Python 3.8+; nothing else.
"""
import os, re, sys, time

TYPES = ("added", "changed", "fixed", "removed", "security")
HEADINGS = {"added": "Added", "changed": "Changed", "fixed": "Fixed",
            "removed": "Removed", "security": "Security"}
DIR = "changelog.d"
UNRELEASED = re.compile(r"^##\s+\[Unreleased\]\s*$")
NAME = re.compile(r"[A-Za-z0-9][\w.-]*")

def die(msg):
    print(f"changelog: {msg}", file=sys.stderr); sys.exit(2)

def parse_args(argv):
    if not argv or argv[0] not in ("check", "fold"):
        die("usage: changelog.py check [--repo <path>] | changelog.py fold "
            "--version <version> [--date YYYY-MM-DD] [--repo <path>] [--dry-run]")
    o = {"mode": argv[0], "repo": os.getcwd(), "dry": False, "version": None, "date": None}
    rest, i = argv[1:], 0
    while i < len(rest):
        a = rest[i]
        if a == "--repo": i += 1; o["repo"] = rest[i]
        elif a == "--dry-run": o["dry"] = True
        elif a == "--version" and o["mode"] == "fold": i += 1; o["version"] = rest[i]
        elif a == "--date" and o["mode"] == "fold": i += 1; o["date"] = rest[i]
        else: die(f"unexpected argument {a}")
        i += 1
    if o["mode"] == "fold":
        if not o["version"]: die("fold needs --version")
        if re.search(r"\s", o["version"]): die("--version takes one word")
        if o["date"] and not re.fullmatch(r"\d{4}-\d{2}-\d{2}", o["date"]):
            die("--date must be YYYY-MM-DD")
    o["repo"] = os.path.abspath(o["repo"])
    return o

OPTS = parse_args(sys.argv[1:])
CHANGELOG = os.path.join(OPTS["repo"], "CHANGELOG.md")
FRAGDIR = os.path.join(OPTS["repo"], DIR)

def refuse(messages):
    for m in messages: print(m)
    print("changelog: nothing written")
    sys.exit(1)

def fragment_files():
    if not os.path.isdir(FRAGDIR): return []
    return sorted(f for f in os.listdir(FRAGDIR) if f.endswith(".md"))

def parse_fragment(fname):
    """Return (type, entry), or (None, reason) when the fragment is malformed."""
    stem = fname[:-3]
    name, _, ftype = stem.rpartition(".")
    if not name: return None, "missing <name> before the type (expected <name>.<type>.md)"
    if ftype not in TYPES:
        return None, f"unknown type '{ftype}'; use one of {', '.join(TYPES)}"
    if not NAME.fullmatch(name):
        return None, f"invalid name '{name}'; use a task or PR reference plus a short slug"
    try:
        with open(os.path.join(FRAGDIR, fname), encoding="utf-8") as fh:
            body = fh.read().strip()
    except (OSError, UnicodeDecodeError) as e:
        return None, f"unreadable ({e})"
    if not body: return None, "empty entry"
    if re.search(r"\n\s*\n", body):
        return None, "one entry per fragment; remove the blank line or split the fragment"
    return ftype, " ".join(body.split())

def fragment_problems():
    problems = []
    for fname in fragment_files():
        ftype, reason = parse_fragment(fname)
        if ftype is None: problems.append(f"{DIR}/{fname}: {reason}")
    return problems

def changelog_lines():
    try:
        with open(CHANGELOG, encoding="utf-8") as fh:
            return fh.read().splitlines()
    except (OSError, UnicodeDecodeError):
        return None

def unreleased_index(lines):
    for i, line in enumerate(lines):
        if UNRELEASED.match(line): return i
    return -1

def unreleased_content(lines, heading):
    """First non-blank line below the heading and above the next `## ` heading."""
    for j in range(heading + 1, len(lines)):
        if lines[j].startswith("## "): return None
        if lines[j].strip(): return lines[j]
    return None

# ---------------------------------------------------------------------- check
def check():
    if not os.path.isdir(FRAGDIR):
        print("changelog: OK (no changelog.d/; fragments not adopted)")
        return
    problems = fragment_problems()
    n = len(fragment_files())
    lines = changelog_lines() if os.path.exists(CHANGELOG) else None
    if lines is None:
        problems.append("CHANGELOG.md: missing; create it with a `## [Unreleased]` heading")
    else:
        h = unreleased_index(lines)
        if h < 0:
            problems.append("CHANGELOG.md: no `## [Unreleased]` heading; add it")
        elif unreleased_content(lines, h):
            problems.append("CHANGELOG.md: [Unreleased] holds direct content; "
                            "record the change as a changelog.d/ fragment instead")
    if problems:
        for p in problems: print(p)
        print(f"changelog check: {len(problems)} problem(s)")
        sys.exit(1)
    print(f"changelog: OK ({n} fragment(s) well formed, [Unreleased] clean)")

# ----------------------------------------------------------------------- fold
def fold():
    frags = fragment_files()
    problems = fragment_problems()
    if problems:
        refuse(problems + [f"changelog fold: {len(problems)} malformed fragment(s)"])
    if not frags:
        refuse([f"{DIR}/: no fragments to fold"])
    lines = changelog_lines() if os.path.exists(CHANGELOG) else None
    if lines is None:
        refuse(["CHANGELOG.md: missing; create it with a `## [Unreleased]` heading"])
    h = unreleased_index(lines)
    if h < 0:
        refuse(["CHANGELOG.md: no `## [Unreleased]` heading; add it"])

    parsed = sorted(((ftype, fname, entry) for fname in frags
                     for ftype, entry in [parse_fragment(fname)]),
                    key=lambda t: (TYPES.index(t[0]), t[1]))
    date = OPTS["date"] or time.strftime("%Y-%m-%d", time.gmtime())
    block = [f"## [{OPTS['version']}] - {date}", ""]
    for t in TYPES:
        entries = [e for ft, _, e in parsed if ft == t]
        if entries:
            block.append(f"### {HEADINGS[t]}")
            block += [f"- {e}" for e in entries]
            block.append("")
    j = h + 1  # below the heading and any blank lines that follow it
    while j < len(lines) and not lines[j].strip(): j += 1
    if j == h + 1: block.insert(0, "")  # keep a blank line below the heading
    new = lines[:j] + block + lines[j:]

    if OPTS["dry"]:
        print("\n".join(new))
        print(f"changelog: dry run; {len(frags)} fragment(s) would fold into "
              f"[{OPTS['version']}] - {date}", file=sys.stderr)
        return
    with open(CHANGELOG, "w", encoding="utf-8") as fh:
        fh.write("\n".join(new) + "\n")
    for fname in frags:
        os.remove(os.path.join(FRAGDIR, fname))
    keep = os.path.join(FRAGDIR, ".gitkeep")
    if not os.path.exists(keep): open(keep, "w").close()
    print(f"changelog: folded {len(frags)} fragment(s) into [{OPTS['version']}] - {date}")
    for fname in frags:
        print(f"changelog: removed {DIR}/{fname}")
    print(f"changelog: left {DIR}/.gitkeep; commit CHANGELOG.md with the removals")

if OPTS["mode"] == "check": check()
else: fold()

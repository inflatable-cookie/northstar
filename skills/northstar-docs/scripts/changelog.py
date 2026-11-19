#!/usr/bin/env python3
"""Changelog fragments: one small file per unreleased change under
changelog.d/, folded into CHANGELOG.md when a release is cut.

Usage:
  changelog.py check [--repo <path>]
  changelog.py fold --version <version> [--date YYYY-MM-DD] [--repo <path>] [--dry-run]

A fragment is changelog.d/<name>.<type>.md. Name it with a task or PR
reference plus a short slug so two branches never collide; type is one of
added changed fixed removed security. The body is one entry of a line or two:
wrapped lines join. Blank lines and list markers are malformed.

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
import os, re, stat, sys, tempfile, time
from datetime import date

TYPES = ("added", "changed", "fixed", "removed", "security")
HEADINGS = {"added": "Added", "changed": "Changed", "fixed": "Fixed",
            "removed": "Removed", "security": "Security"}
DIR = "changelog.d"
SECTION = r"^ {0,3}##[ \t]+"
UNRELEASED = re.compile(SECTION + r"\[Unreleased\]\s*$")
FENCE = re.compile(r"^ {0,3}(`{3,}|~{3,})(.*)$")
NAME = re.compile(r"[A-Za-z0-9][\w.-]*")
LIST_ITEM = re.compile(r"^[ \t]*(?:[-+*]|[0-9]{1,9}[.)])(?:[ \t]+|$)", re.M)

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
        if a in ("--repo", "--version", "--date") and (
            i + 1 == len(rest) or rest[i + 1].startswith("--")
        ):
            die(f"{a} requires a value")
        if a == "--repo": i += 1; o["repo"] = rest[i]
        elif a == "--dry-run": o["dry"] = True
        elif a == "--version" and o["mode"] == "fold": i += 1; o["version"] = rest[i]
        elif a == "--date" and o["mode"] == "fold": i += 1; o["date"] = rest[i]
        else: die(f"unexpected argument {a}")
        i += 1
    if o["mode"] == "fold":
        if not o["version"]: die("fold needs --version")
        if re.search(r"[\s\[\]\\]", o["version"]):
            die("--version takes one word without brackets or backslashes")
        if o["date"] is not None:
            try:
                valid_date = date.fromisoformat(o["date"]).isoformat()
            except ValueError:
                die("--date must be a valid YYYY-MM-DD date")
            if o["date"] != valid_date:
                die("--date must be a valid YYYY-MM-DD date")
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
    if LIST_ITEM.search(body):
        return None, "one entry per fragment without list markers; split lists into separate files"
    return ftype, " ".join(line.strip() for line in body.splitlines())

def read_fragments():
    parsed, problems = [], []
    for fname in fragment_files():
        ftype, entry = parse_fragment(fname)
        if ftype is None:
            problems.append(f"{DIR}/{fname}: {entry}")
        else:
            parsed.append((ftype, fname, entry))
    return parsed, problems

def changelog_lines():
    try:
        with open(CHANGELOG, encoding="utf-8") as fh:
            return fh.read().splitlines()
    except (OSError, UnicodeDecodeError):
        return None

def unreleased_content(lines, heading):
    """First non-blank line below the heading and above the next `## ` heading."""
    for j in range(heading + 1, len(lines)):
        if re.match(SECTION, lines[j]): return None
        if lines[j].strip(): return lines[j]
    return None


def section_headings(lines):
    fence = ""
    for i, line in enumerate(lines or []):
        match = FENCE.match(line)
        if fence:
            if match and match[1].startswith(fence) and not match[2].strip():
                fence = ""
        elif match and (match[1][0] == "~" or "`" not in match[2]):
            fence = match[1]
        elif re.match(SECTION, line):
            yield i, line


def validate_changelog(lines, sections):
    if lines is None:
        return -1, "CHANGELOG.md: missing or unreadable; provide a readable file with a `## [Unreleased]` heading"
    headings = [i for i, line in sections if UNRELEASED.match(line)]
    if not headings:
        return -1, "CHANGELOG.md: no `## [Unreleased]` heading; add it"
    if len(headings) > 1:
        return -1, "CHANGELOG.md: more than one `## [Unreleased]` heading"
    heading = headings[0]
    if unreleased_content(lines, heading):
        return heading, ("CHANGELOG.md: [Unreleased] holds direct content; "
                         "record the change as a changelog.d/ fragment instead")
    return heading, None


def write_changelog(lines):
    path = os.path.realpath(CHANGELOG)
    mode = stat.S_IMODE(os.stat(path).st_mode)
    output = tempfile.NamedTemporaryFile(mode="w", encoding="utf-8", delete=False,
                                         dir=os.path.dirname(path))
    try:
        with output:
            output.write("\n".join(lines) + "\n")
        os.chmod(output.name, mode)
        os.replace(output.name, path)
    finally:
        if os.path.exists(output.name):
            os.unlink(output.name)

# ---------------------------------------------------------------------- check
def check():
    if not os.path.isdir(FRAGDIR):
        print("changelog: OK (no changelog.d/; fragments not adopted)")
        return
    parsed, problems = read_fragments()
    lines = changelog_lines()
    _, problem = validate_changelog(lines, section_headings(lines))
    if problem:
        problems.append(problem)
    if problems:
        for p in problems: print(p)
        print(f"changelog check: {len(problems)} problem(s)")
        sys.exit(1)
    print(f"changelog: OK ({len(parsed)} fragment(s) well formed, [Unreleased] clean)")

# ----------------------------------------------------------------------- fold
def fold():
    parsed, problems = read_fragments()
    if problems:
        refuse(problems + [f"changelog fold: {len(problems)} malformed fragment(s)"])
    if not parsed:
        refuse([f"{DIR}/: no fragments to fold"])
    lines = changelog_lines()
    sections = list(section_headings(lines))
    h, problem = validate_changelog(lines, sections)
    if problem:
        refuse([problem])
    version = re.escape(OPTS["version"])
    release_heading = re.compile(SECTION + rf"\[{version}\](?:\s|$)")
    if any(release_heading.match(line) for _, line in sections):
        refuse([f"CHANGELOG.md: version {OPTS['version']} already exists"])

    frags = [fname for _, fname, _ in parsed]
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
    if not os.access(FRAGDIR, os.W_OK | os.X_OK):
        refuse([f"{DIR}/: needs write and search permission to remove folded fragments"])
    try:
        write_changelog(new)
    except OSError as error:
        refuse([f"CHANGELOG.md: could not write release: {error}"])
    try:
        for fname in frags:
            os.remove(os.path.join(FRAGDIR, fname))
        keep = os.path.join(FRAGDIR, ".gitkeep")
        if not os.path.exists(keep): open(keep, "w").close()
    except OSError as error:
        print(f"changelog: release written; fragment cleanup failed: {error}", file=sys.stderr)
        print("Compare remaining fragments with the release before folding again.", file=sys.stderr)
        sys.exit(1)
    print(f"changelog: folded {len(frags)} fragment(s) into [{OPTS['version']}] - {date}")
    for fname in frags:
        print(f"changelog: removed {DIR}/{fname}")
    print(f"changelog: left {DIR}/.gitkeep; commit CHANGELOG.md with the removals")

if OPTS["mode"] == "check": check()
else: fold()

#!/usr/bin/env python3
"""Lean Northstar migration helper: move knowledge, remove process records, and
recompute every relative reference from each file's old location. Also checks
Markdown links repo-wide.

Usage:
  cut.py apply <plan.json> [--repo <path>] [--dry-run]
  cut.py check-links [--repo <path>] [--plan <plan.json>] [--frozen <regex>]...

The plan is JSON:
  {
    "moves":   [["docs/contracts/", "docs/knowledge/contracts/"],
                ["docs/vision/001-vision.md", "docs/knowledge/vision.md"]],
    "removed": ["docs/roadmaps/", "docs/logs/", ".northstar/"],
    "frozen":  ["^platform/releases/", "^migrations/", "/fixtures/"]
  }

A trailing "/" names a directory; the longest matching move wins. Frozen paths
are regular expressions for files that must never be rewritten: released
artefacts, vendored mirrors, applied migrations, fixtures and digested receipts.

apply runs `git mv` and `git rm`, then rewrites references. It rewrites
Markdown links and reference definitions, backticked relative paths, and
repository-root or ../-relative paths in any text file. A link into a removed
record becomes plain text, or a readable Git-history pointer when the link text
was itself a path. It prints what it could not fix; fix those by hand.
Exit: 0 done, 1 check-links found problems, 2 usage error.
Needs Python 3.8+ and Git; nothing else.
"""
import json, os, re, subprocess, sys

def die(msg):
    print(f"cut: {msg}", file=sys.stderr); sys.exit(2)

def parse_args(argv):
    if not argv or argv[0] not in ("apply", "check-links"):
        die("usage: cut.py apply <plan.json> [--repo <path>] [--dry-run] | cut.py check-links [--repo <path>] [--plan <plan.json>] [--frozen <regex>]...")
    mode, rest = argv[0], argv[1:]
    opts = {"mode": mode, "repo": os.getcwd(), "dry": False, "plan": None, "frozen": []}
    i = 0
    while i < len(rest):
        a = rest[i]
        if a == "--repo": i += 1; opts["repo"] = rest[i]
        elif a == "--dry-run": opts["dry"] = True
        elif a == "--frozen": i += 1; opts["frozen"].append(rest[i])
        elif a == "--plan" and mode == "check-links": i += 1; opts["plan"] = rest[i]
        elif mode == "apply" and opts["plan"] is None: opts["plan"] = a
        else: die(f"unexpected argument {a}")
        i += 1
    if mode == "apply" and not opts["plan"]: die("apply needs a plan file")
    opts["repo"] = os.path.abspath(opts["repo"])
    return opts

OPTS = parse_args(sys.argv[1:])
ROOT = OPTS["repo"]

def git(*args):
    r = subprocess.run(["git", "-C", ROOT, *args], capture_output=True, text=True)
    if r.returncode != 0: die(f"git {' '.join(args[:2])} failed: {r.stderr.strip()}")
    return r.stdout

TEXT_SKIP = re.compile(r"\.(png|jpe?g|gif|webp|ico|pdf|pptx|docx|xlsx|zip|gz|tar|woff2?|ttf|otf|mp4|mp3|wav|sqlite|db|oci|bin|wasm|icns|lock)$", re.I)
LINK = re.compile(r"(!?\[)((?:[^\[\]]|\[[^\]]*\])*)\]\(\s*(<[^>]+>|[^)\s]+)(\s+\"[^\"]*\")?\s*\)")
REFDEF = re.compile(r"^(\s*\[[^\]]+\]:\s*)(\S+)(.*)$", re.M)
CODE_REL = re.compile(r"`((?:\.\.?/)+[^`\s]+)`")
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

# ---------------------------------------------------------------- check-links
def slug(heading):
    s = re.sub(r"[^\w\- ]", "", heading.strip().lower())
    return s.replace(" ", "-")

def anchors(path, cache={}):
    if path not in cache:
        text = read_text(path) or ""
        seen, out = {}, set()
        for h in re.findall(r"^#{1,6}\s+(.+?)\s*#*\s*$", text, re.M):
            # GitHub keeps underscores in anchors, so only markup is stripped.
            base = slug(re.sub(r"`|\*|\[|\]\([^)]*\)", "", h)); n = seen.get(base, 0)
            out.add(base if n == 0 else f"{base}-{n}"); seen[base] = n + 1
        out |= set(re.findall(r'<a\s+(?:name|id)="([^"]+)"', text))
        cache[path] = out
    return cache[path]

def check_links():
    patterns = list(OPTS["frozen"])
    if OPTS["plan"]:
        with open(OPTS["plan"]) as fh: patterns += json.load(fh).get("frozen", [])
    frozen = [re.compile(p) for p in patterns]
    problems = []
    for f in git("ls-files", "--cached", "--others", "--exclude-standard", "*.md").splitlines():
        if any(p.search(f) for p in frozen): continue
        text = read_text(os.path.join(ROOT, f))
        if text is None: continue
        text = re.sub(r"```.*?```", "", text, flags=re.S)
        text = re.sub(r"`[^`\n]*`", "", text)  # links shown inside code spans aren't links
        for m in list(LINK.finditer(text)) + list(REFDEF.finditer(text)):
            target = m.group(3) if m.re is LINK else m.group(2)
            if EXTERNAL.match(target) or target.startswith("/"): continue
            path, frag = split_target(target)
            full = os.path.normpath(os.path.join(ROOT, os.path.dirname(f), path)) if path else os.path.join(ROOT, f)
            if path and not os.path.exists(full):
                problems.append(f"{f}: missing {target}"); continue
            if frag and full.endswith(".md") and os.path.isfile(full) and frag not in anchors(full):
                problems.append(f"{f}: missing anchor {target}")
    for p in problems: print(p)
    print(f"check-links: {'OK' if not problems else str(len(problems)) + ' problem(s)'}")
    sys.exit(1 if problems else 0)

# ---------------------------------------------------------------------- apply
def describe_removed(p):
    m = re.match(r"docs/roadmaps/archive/([^/]+)\.md", p)
    if m: return f"the `{m.group(1)}` roll-up in Git history"
    m = re.match(r"docs/roadmaps/(g\d+)/(\d{3})-[^/]+\.md", p)
    if m: return f"task {m.group(1)}.{m.group(2)} (Git history)"
    m = re.match(r"docs/roadmaps/(g\d+)/", p)
    if m: return f"the {m.group(1)} runway (Git history)"
    m = re.match(r"docs/logs/(\d{4})-(\d{2})/(\d{2})-\d+-([^/]+)\.md", p)
    if m: return f"the {m.group(1)}-{m.group(2)}-{m.group(3)} `{m.group(4)}` log (Git history)"
    m = re.match(r"docs/handoffs/(?:\d{8}-\d*-?)?([^/]+)\.md", p)
    if m: return f"the `{m.group(1)}` handoff (Git history)"
    for prefix, words in (("docs/roadmaps", "the retired roadmaps"), ("docs/logs", "the retired logs"),
                          ("docs/handoffs", "the retired handoffs"), (".northstar", "the retired lifecycle records")):
        if p.startswith(prefix): return f"{words} (Git history)"
    return f"`{os.path.basename(p)}` (Git history)"

def apply():
    with open(OPTS["plan"]) as fh: plan = json.load(fh)
    moves, removed = plan.get("moves", []), plan.get("removed", [])
    frozen = [re.compile(p) for p in plan.get("frozen", [])]
    old_files = set(git("ls-files").splitlines())
    old_dirs = {d for f in old_files for d in [os.path.dirname(f)] if d}
    for d in list(old_dirs):
        while d: old_dirs.add(d); d = os.path.dirname(d)
    exists_old = lambda p: p in old_files or p.rstrip("/") in old_dirs

    def map_path(p):
        # The most specific rule wins, whether it is a move or a removal, so a
        # file moved out of a removed directory is moved, not deleted.
        best = None
        for r in removed:
            if p == r.rstrip("/") or (r.endswith("/") and p.startswith(r)):
                if best is None or len(r) > best[0]: best = (len(r), "removed", p)
        for old, new in moves:
            if old.endswith("/"):
                if p == old.rstrip("/"): cand = new.rstrip("/")
                elif p.startswith(old): cand = new + p[len(old):] if new.endswith("/") else new
                else: continue
            elif p == old: cand = new
            else: continue
            if best is None or len(old) > best[0] or (len(old) == best[0] and best[1] == "removed"):
                best = (len(old), "moved", cand)
        return (best[1], best[2]) if best else ("same", p)

    moved = {f: n for f in sorted(old_files) for k, n in [map_path(f)] if k == "moved" and n != f}
    removed_files = [f for f in old_files if map_path(f)[0] == "removed"]
    by_target = {}
    for o, n in moved.items(): by_target.setdefault(n, []).append(o)
    for n, olds in by_target.items():
        if len(olds) > 1:  # several files fold into one: keep the non-README, remove the rest
            keep = [o for o in olds if not o.endswith("README.md")][:1] or olds[:1]
            for o in olds:
                if o not in keep: del moved[o]; removed_files.append(o)
    reverse = {n: o for o, n in moved.items()}

    if not OPTS["dry"]:
        for o, n in sorted(moved.items()):
            os.makedirs(os.path.join(ROOT, os.path.dirname(n)), exist_ok=True)
            git("mv", o, n)
        for i in range(0, len(removed_files), 500):
            if removed_files[i:i + 500]: git("rm", "-q", "-r", "--", *removed_files[i:i + 500])

    report = {"rewritten": 0, "to_removed": 0, "fix_by_hand": [], "missing": []}
    moved_prefixes = sorted({o.rstrip("/") for o, _ in moves} | {r.rstrip("/") for r in removed}, key=len, reverse=True)
    root_rel = re.compile(r"(?<![\w./@-])((?:" + "|".join(re.escape(p) for p in moved_prefixes) + r")(?:/[\w.@/+-]*)?)") if moved_prefixes else None
    dot_rel = re.compile(r"((?:\.\./)+[\w.@/+-]+)")

    def resolve(old_file, target):
        abs_ = os.path.normpath(os.path.join(ROOT, os.path.dirname(old_file), target))
        rel = os.path.relpath(abs_, ROOT)
        return ("external", abs_) if rel.startswith("..") else ("repo", "" if rel == "." else rel)

    def relative_to(new_file, target, external=False, slash=False, dot=False):
        r = os.path.relpath(target if external else os.path.join(ROOT, target), os.path.join(ROOT, os.path.dirname(new_file)))
        if slash and not r.endswith("/"): r += "/"
        if dot and not r.startswith("."): r = "./" + r
        return r

    def rewrite(old_file, new_file, target):
        if not target or EXTERNAL.match(target) or target.startswith(("#", "/")): return target, None
        path, frag = split_target(target)
        if not path: return target, None
        kind, loc = resolve(old_file, path)
        if kind == "external":
            if old_file == new_file: return target, None
            nt = relative_to(new_file, loc, True, path.endswith("/"), path.startswith("./"))
        else:
            mk, mapped = map_path(loc)
            if mk == "removed": return None, loc
            if mk == "same" and not exists_old(loc): report["missing"].append(f"{new_file}: {target}")
            if old_file == new_file and mk == "same": return target, None
            nt = relative_to(new_file, mapped, False, path.endswith("/"), path.startswith("./"))
        if frag is not None: nt += "#" + frag
        if nt != target: report["rewritten"] += 1
        return nt, None

    new_files = sorted((old_files - set(removed_files) - set(moved)) | set(moved.values()))
    for nf in new_files:
        of = reverse.get(nf, nf)
        if any(p.search(of) for p in frozen) or TEXT_SKIP.search(nf): continue
        full = os.path.join(ROOT, nf)
        if os.path.abspath(full) == os.path.abspath(OPTS["plan"]): continue
        text = read_text(full)
        if text is None: continue
        orig = text
        if nf.endswith(".md"):
            def link_sub(m):
                opener, label, tgt, title = m.group(1), m.group(2), m.group(3), m.group(4) or ""
                nt, gone = rewrite(of, nf, tgt[1:-1] if tgt.startswith("<") else tgt)
                if gone:
                    report["to_removed"] += 1
                    plain = label.strip()
                    if not opener.startswith("!") and re.fullmatch(r"`?[\w./#-]+`?", plain) and ("/" in plain or plain.strip("`").endswith(".md")):
                        return describe_removed(gone)
                    return label
                return f"{opener}{label}]({'<' + nt + '>' if tgt.startswith('<') else nt}{title})"
            text = LINK.sub(link_sub, text)
            def ref_sub(m):
                nt, gone = rewrite(of, nf, m.group(2))
                if gone: report["to_removed"] += 1; return f"{m.group(1)}{describe_removed(gone)}{m.group(3)}"
                return f"{m.group(1)}{nt}{m.group(3)}"
            text = REFDEF.sub(ref_sub, text)
            def code_sub(m):
                raw = m.group(1); kind, loc = resolve(of, raw.split("#")[0])
                if kind != "repo" or not exists_old(loc): return m.group(0)
                nt, gone = rewrite(of, nf, raw)
                return describe_removed(gone) if gone else f"`{nt}`"
            text = CODE_REL.sub(code_sub, text)
        else:
            def dot_sub(m):
                raw = m.group(1); kind, loc = resolve(of, raw)
                if kind != "repo" or not exists_old(loc.rstrip("/")): return raw
                mk, mapped = map_path(loc)
                if mk == "removed": report["fix_by_hand"].append(f"{nf}: {raw}"); return raw
                if mk == "same" and of == nf: return raw
                return relative_to(nf, mapped, False, raw.endswith("/"))
            text = dot_rel.sub(dot_sub, text)
        if root_rel:
            def root_sub(m):
                raw = m.group(1); stripped = raw.rstrip(".,;:)"); tail = raw[len(stripped):]
                p = stripped.split("#")[0]
                if not exists_old(p.rstrip("/")): return raw
                mk, mapped = map_path(p.rstrip("/"))
                if mk == "removed": report["fix_by_hand"].append(f"{nf}: {stripped}"); return raw
                if mk == "same": return raw
                if stripped.endswith("/") and not mapped.endswith((".md", "/")): mapped += "/"
                return mapped + stripped[len(p):] + tail
            text = root_rel.sub(root_sub, text)
        if text != orig and not OPTS["dry"]:
            with open(full, "w", encoding="utf-8") as fh: fh.write(text)

    print(json.dumps({"dry_run": OPTS["dry"], "moved": len(moved), "removed": len(removed_files),
                      "rewritten_links": report["rewritten"], "links_to_removed": report["to_removed"]}, indent=1))
    if report["fix_by_hand"]:
        by_file = {}
        for r in sorted(set(report["fix_by_hand"])):
            f, _, ref = r.partition(": "); by_file.setdefault(f, []).append(ref)
        print(f"References to removed paths outside Markdown links, in {len(by_file)} file(s) (fix by hand, or mark the file frozen):")
        for f, refs in sorted(by_file.items(), key=lambda kv: -len(kv[1])):
            sample = ", ".join(refs[:3]) + (f", … {len(refs) - 3} more" if len(refs) > 3 else "")
            print(f"  {f} ({len(refs)}): {sample}")
    if report["missing"]:
        print(f"Links that were already broken before the cut: {len(report['missing'])}")
        for r in report["missing"][:200]: print("  " + r)

if OPTS["mode"] == "check-links": check_links()
else: apply()

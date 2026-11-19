#!/usr/bin/env python3
"""Compare skill file contents, executable bits and symlink targets.

Usage: check-skill-install.py [<installed-skills-root>]   (default ~/.agents/skills)
Exit: 0 every skill matches, 1 a skill differs or is missing, 2 usage error.
"""
import hashlib, os, sys
import stat

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


def raise_walk_error(error):
    raise error


def files(base):
    out = {}
    for dirpath, dirs, names in os.walk(base, onerror=raise_walk_error):
        if dirpath == base:
            dirs[:] = [name for name in dirs if name != ".effigy"]
            names = [name for name in names if name != ".effigy"]
        links = [name for name in dirs if os.path.islink(os.path.join(dirpath, name))]
        for name in names + links:
            path = os.path.join(dirpath, name)
            rel = os.path.relpath(path, base).replace(os.sep, "/")
            if os.path.islink(path):
                out[rel] = ("symlink", os.readlink(path))
            elif os.path.isfile(path):
                with open(path, "rb") as f:
                    executable = os.fstat(f.fileno()).st_mode & (stat.S_IXUSR | stat.S_IXGRP | stat.S_IXOTH)
                    out[rel] = ("file", executable, hashlib.sha256(f.read()).hexdigest())
            else:
                raise OSError(f"{path}: expected a regular file or symlink")
    return out


def main(argv):
    if len(argv) > 1:
        print(__doc__.strip(), file=sys.stderr)
        return 2
    target_root = os.path.expanduser(argv[0] if argv else "~/.agents/skills")
    source_root = os.path.join(ROOT, "skills")
    failed = False
    for skill in sorted(os.listdir(source_root)):
        source = os.path.join(source_root, skill)
        if not os.path.isdir(source):
            continue
        target = os.path.join(target_root, skill)
        if not os.path.isdir(target):
            print(f"{skill}: not installed at {target}")
            failed = True
            continue
        try:
            a, b = files(source), files(target)
        except OSError as error:
            print(f"{skill}: {error}")
            failed = True
            continue
        problems = [f"missing: {p}" for p in sorted(a) if p not in b]
        problems += [f"differing: {p}" for p in sorted(a) if p in b and a[p] != b[p]]
        problems += [f"unexpected: {p}" for p in sorted(b) if p not in a]
        if problems:
            failed = True
            print(f"{skill}: " + ", ".join(problems))
        else:
            print(f"{skill}: OK ({len(a)} files)")
    return 1 if failed else 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))

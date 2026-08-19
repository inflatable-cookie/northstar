# Cleanup Docs Mode

Use this mode to inspect a project's `docs/` tree for files and folders that do
not fit the Northstar protocol and to rework clear drift into the right
canonical home.

## Operating posture

Cleanup is an evidence-led docs maintenance pass, not a purge. An unfamiliar
path is a finding to inspect, not proof that it should be deleted. Keep useful
project-specific material when it has a clear owner and destination, even when
Northstar does not prescribe its exact filename.

## Procedure

1. Identify the docs authority, posture, active generation, and current task.
   Read the repository front doors, applicable contracts, and the Northstar
   standard-spine guidance before classifying paths.
2. Inventory `docs/` recursively. Include top-level folders, anchor files,
   nested files, deprecated patterns, empty directories, and every note under
   `docs/triage/` except its `README.md` anchor. Check filenames, links,
   references, and content rather than relying on names or age alone.
3. Classify each candidate as canonical, supported add-on, legitimate
   project-specific surface, clear legacy/duplicate, stale or empty, or
   ambiguous. Compare the path with the repo's posture; do not penalize a
   justified strict or optional surface as drift.
4. For clear findings, choose the smallest clean repair: rehome content into
   the correct Northstar section, merge duplicate material, normalize naming or
   sections, update references, and remove the superseded source only after the
   destination and reference rewrite are complete. Preserve meaningful history
   in the appropriate log or archive rather than leaving a shim behind.
5. Give every triage note a disposition. Promote or rework useful notes, merge
   duplicates, and remove notes that are implemented, superseded, or no longer
   useful. Keep unresolved notes only while they are genuinely open, with a
   next check or owner when possible; an open note is an interim state, not a
   permanent home. If a
   triage note or docs outlier has an uncertain owner, destination, meaning, or
   removal consequence, ask the operator instead of guessing.
6. Re-run relevant docs validation and report the result. Do not start roadmap
   execution, edit production code, or silently promote an ambiguous finding.

## Report shape

Return a compact table or equivalent list with:

`path | classification | evidence | proposed destination/action | state`

Use `repaired`, `unchanged`, `needs-operator`, or `blocked` for the state. Name
each operator question precisely. If no cleanup is authorized, keep the pass
read-only and report repairs as proposals.

## Boundaries

Cleanup is read-only unless the operator explicitly authorizes bounded docs
repair. Never delete an unclassified file or folder, never use age alone as a
deletion rule, and never create a compatibility shim in a deprecated path. Ask
the operator whenever the evidence does not establish a safe canonical home or
removal decision.

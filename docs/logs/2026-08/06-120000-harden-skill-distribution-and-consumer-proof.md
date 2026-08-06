# Harden Skill Distribution And Consumer Papercut Proof

Roadmap refs: g02.024, cards 068-069

## What changed

- documented the published `npx skills update northstar -g -y` path and global
  install inspection command
- added an Effigy-native Rhai source-repository parity checker for an installed
  Northstar skill
- verified `/Users/tom/.agents/skills/northstar` against the source tree
- ran the papercuts loop in Longhorn and recorded the real Effigy doctor/health
  task friction in Longhorn's root queue
- kept papercut triage manual and left consumer implementation untouched

## Evidence

- `effigy check:skill-install /Users/tom/.agents/skills/northstar`: passed
- source and shared global install trees match
- `npx skills list -g --json`: showed the configured GitHub source and harness
  targets
- Longhorn `PAPERCUTS.md`: one new actionable entry
- the default Longhorn doctor path was interrupted after confirming that
  `health` expands to the full `qa` task; no consumer code was changed

## Lane state

- g02.024 complete
- continuation envelope exhausted
- lane budget complete
- pause signal: `lane-complete`

## Triage

The Longhorn entry is not promoted. It should remain in that repository's normal
maintenance queue until the owner decides whether `health` needs a cheap
baseline or a clearer full-suite warning. Northstar's own source queue entry
for the undocumented update path is resolved by the new distribution docs.

## Next task

Compile the next g02 milestone from the consumer evidence.

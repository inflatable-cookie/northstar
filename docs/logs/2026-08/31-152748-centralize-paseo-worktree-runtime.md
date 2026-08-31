# Centralize Paseo Worktree Runtime

Date: 2026-08-31
Roadmap: `g02.038`
Card: `g02.038/106`
Status: complete

## Result

Northstar now owns the Paseo worktree Rhai helper inside the installable skill.
The skill Effigy catalog exports `paseo:worktree`; copy-ready project settings
invoke it with `effigy skill run` and keep the consuming project as the runtime
target. Consumer repos no longer copy the implementation or register a local
task.

The starter requires the repo's real idempotent setup task between sibling
preparation and dependency-link replay. It no longer assumes that a no-argument
`effigy bootstrap` installs an existing worktree.

Orchestrator guidance now requires required sibling links in the managed
worktree's container directory before project setup. It retains the originating
Paseo agent ID and explicitly calls `send_agent_prompt` after posting a
changes-requested review; PR comments alone are not treated as a wake-up.

Operator feedback also removed the redundant per-PR merge prompt. The active
orchestrator lane is now pre-authorized to merge its worker PR after it records
an accepted review for the exact current head, confirms required checks pass and
the intended base is mergeable, and finds no stricter repository rule or
explicit operator pause. Workers and standalone direct-review threads still do
not merge.

Figmatic is the consumer proof target. Its settings prepare Longhorn and Poodle,
run `effigy setup`, invoke the installed skill for prepare/link/unlink, and
contain no copied helper or local lifecycle task.

## Validation

- active Effigy `v0.12.1+local.fd14c5c` lists the installed
  `northstar/paseo:worktree` selector;
- installed-skill self-tests pass with both automatic Northstar targeting and
  an explicit Figmatic `--repo` target;
- the helper accepts Effigy's forwarded `--` delimiter and validates the typed
  `effigy.deps.link.v1` / `effigy.deps.unlink.v1` results returned by
  `effigy::run_json`;
- five skill scripts no longer shadow Effigy's injected `skill_root` global;
  repo-local and external-skill quality checks both resolve their payloads;
- a real Paseo Figmatic workspace from `origin/main` created Longhorn and Poodle
  symlinks in its container before `effigy setup`, replayed the Poodle Bun link,
  and removed the worktree-local registration on archive;
- both `paseo.json` files parse as JSON;
- `git diff --check` passes in Northstar and Figmatic;
- local `effigy test:paseo-worktree` passes create, reuse, and conflict refusal;
- skill creator validation passes;
- source and installed Northstar skill trees match, excluding generated caches;
- `effigy qa:docs` and `effigy qa` pass in Northstar;
- `effigy qa:docs` and `effigy qa` pass in Figmatic: 616 tests passed and 11
  intentional integration/doc tests were ignored.

The test workspace was archived, its residual clean worktree and test branch
were removed, and no worktree-local Bun registration remains.

## Next

No automatic follow-on card. Return to generation planning or accept the next
operator-provided live-use correction.

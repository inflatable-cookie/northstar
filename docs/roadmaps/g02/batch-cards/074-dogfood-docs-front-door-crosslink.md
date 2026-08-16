# 074 - Dogfood Docs Front Door Crosslink

Status: ready
Owner: repo maintainers
Updated: 2026-08-16
Master spec refs: `docs/specs/026-orchestrator-thread-and-worker-pr-loop.md`, `docs/specs/027-northstar-native-pre-execution-discovery.md`
Dogfood parent: `g02.025/072`
Governing refs: `docs/contracts/001-working-rules.md`, `docs/specs/README.md`, `g02.025`
Auto-start next card: no

## Ready-State Checks

- [x] Objective is bounded enough to finish without fresh planning decisions.
- [x] Governing refs point at current canonical surfaces.
- [x] Scope boundaries and stop conditions are explicit.
- [x] Acceptance, validation, and evidence requirements are explicit.
- [x] No unresolved planning gap governs the card's scope.
- [x] No unresolved intent checkpoint governs the card's scope.
- [x] Auto-start is disabled because this is a worker-loop probe.

## Objective

Add a concise active-planning crosslink to `docs/specs/README.md` so a fresh
operator can find spec 027 and its source-backed translation memo without
searching the repository.

## Scope

- update `docs/specs/README.md` only;
- link the active spec and its related translation memo;
- preserve the existing artifact, lifecycle, and archive guidance;
- do not alter the spec, memo, roadmap, skill, contract, or implementation files.

## Steps

1. Read the handoff, `AGENTS.md`, this card, the active roadmap, and the governing
   refs before editing.
2. Add one small `Active planning` section or equivalent front-door link block to
   `docs/specs/README.md`.
3. Run `git diff --check` and `effigy qa:docs`.
4. Commit the one-file change on the worker branch.
5. Push the branch and open a reviewable PR against the pushed `main` base.
6. Report the changed file, validation output, commit, and PR URL through the
   operator.

## Acceptance criteria

- `docs/specs/README.md` contains a clear link to
  `docs/specs/027-northstar-native-pre-execution-discovery.md`;
- the link identifies the related research translation memo;
- no other file is changed by the worker;
- `git diff --check` and `effigy qa:docs` pass;
- the PR body links this card and the dogfood parent.

## Evidence required

- worker starting branch/worktree/base verification;
- final one-file diff;
- commit and PR refs;
- `git diff --check` output;
- `effigy qa:docs` output;
- operator-relayed chunk report.

## Stop conditions

- stop if the requested front-door placement is ambiguous;
- stop if the change would require modifying another canonical surface;
- stop if QA exposes a planning or contract gap;
- stop if the worker cannot verify the pushed base or dedicated worktree.

## Next task

After the worker PR is reviewed and the dogfood parent closes, remove or retain
this probe only according to the recorded dogfood evidence; it is not a reusable
product lane by itself.

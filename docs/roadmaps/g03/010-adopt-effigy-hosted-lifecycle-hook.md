# g03.010 Adopt the Effigy-Hosted Lifecycle Hook

Owner: repo maintainers
Created: 2026-09-13
Governing refs: contract 001, system architecture, bundle section 12, Queue contract 005
Depends on: `g03.009` complete at `c9e3533`; Queue `g01.013` complete at `bd3eb8b`; Effigy interface accepted at `4f2b466`
UI classification: none

## Outcome

Queue invokes Northstar's lifecycle adapter through the installed or project-local
Northstar skill using Effigy's exact stdio transport. Consumer repositories keep
only the generic Queue manifest, Northstar projection configuration, and generated
lifecycle state. They do not copy Northstar runtime code or carry a launcher.

## Ready-State Rubric

- [x] Effigy resolves qualified skill selectors from the project first and then a
      unique global install, and exposes exact `--stdio passthrough` transport.
- [x] Queue `g01.013` delivers `paseo.queue.control.v2` trusted host runners with
      immutable executable artifacts and literal argv.
- [x] Trusted runner `effigy` is active and healthy on host `srv_FQNrK3mv8-wL`,
      revision 1, at native digest `sha256:86994ae8cd0f6528d26dc2cdb1006973b828ff9adcb9fc368c7cbebdda27e749`.
- [x] Northstar's current v1 repository hook remains available to bootstrap this
      task through implementation and merge.
- [x] Scope, removal boundary, starter behavior, compatibility policy, and live
      cutover oracle are explicit.
- [x] UI classification is `none`.

## Decisions

- The runtime chain is `Queue -> Effigy -> Northstar skill -> lifecycle adapter`.
  Queue stays document-system agnostic; Effigy stays skill-system generic;
  Northstar owns lifecycle meaning and repository projections.
- The Queue manifest selects trusted runner `effigy` with literal argv
  `["skill", "run", "northstar/queue:hook", "--stdio", "passthrough"]`.
  It supplies neither `--path` nor `--json`.
- The skill catalog exposes `northstar/queue:hook` and anchors every skill-owned
  script with `{skill}`. The consumer repository remains the execution target and
  working directory.
- Remove the repository launcher, copied runtime payload, runtime copier, and
  their parity doctrine together. Before 1.0 there is no compatibility shim for
  the superseded deployment shape.
- Standalone lifecycle commands remain supported through the same installed skill.
  Queue and its trusted-runner registry remain optional integrations.
- Starter material may declare the v2 Queue route, but it must state the external
  Effigy and host approval prerequisites plainly and fail closed when either is
  absent. It must not contain executable Northstar hook code.
- This task is the cutover proof. Dispatch begins under the current committed v1
  hook. After merge, `task.closeout` must discover the merged v2 manifest, execute
  the registered Effigy artifact, resolve the merged Northstar selector, and
  publish the terminal record and projections while consuming the exact handoff.

## UI Design Brief

Not applicable.

## Dispatch manifest

- **State:** ready after this planning commit is pushed; one lifecycle cutover
  lane, no concurrent sibling.
- **Completion:** implementation and independent exact-head review pass; PR merges;
  Queue runs `task.closeout` through the v2 trusted runner and
  `northstar/queue:hook`; the hook publishes `g03.010` terminal state, refreshes
  declared projections, and deletes the exact submitted handoff; no closeout
  agent or closeout workspace is created.
- **Owned mutable paths:** Northstar skill catalog, lifecycle adapter/core schemas
  and references, lifecycle adoption/runtime tests, reusable doctrine and starter
  lifecycle surfaces, repo-contract checks, `.paseo/queue.json`, removal of
  `.paseo/hooks/**`, and concise architecture/contract/task/front-door updates.
- **Reserved closeout surfaces:** `.northstar/lifecycle/v1/tasks/g03.010.json`,
  declared generated projection blocks, and deletion of this task's exact handoff
  belong exclusively to the required Queue hook after merge.
- **Worker:** automatic adequate complex implementation pool; reviewer must use an
  independent provider/model identity.
- **Serial edges:** this is the only Northstar writer lane. Portfolio rollout waits
  for its terminal v2 proof.
- **Excluded:** Queue or Effigy source changes; Queue database edits; trusted-runner
  approval/revocation; consumer-repository rollout; automatic generation rollover
  or compaction; UI, CI, release, or thread/workspace destruction.
- **Escalation:** stop before merge if the registered runner is absent or unhealthy,
  or if Queue cannot prove which manifest/program it will use for closeout.

## Work

1. Add `northstar/queue:hook` to the Northstar skill catalog using `{skill}`-anchored
   assets. Update existing skill tasks that still depend on invocation-relative
   `scripts/` paths.
2. Teach the lifecycle adapter to validate and consume the strict v2 control
   manifest while retaining required v1 event/result compatibility for existing
   repositories. Keep Queue-specific program transport out of lifecycle state.
3. Convert Northstar's `.paseo/queue.json` to v2 trusted runner programs with the
   frozen Effigy argv. Preserve hook events, modes, delivery, paths, time/output
   limits, commit-subject rules, and closeout authority exactly.
4. Remove Northstar's repository launcher and copied runtime payload. Remove the
   runtime copy/check tool and tests or doctrine whose only purpose was keeping
   copied bytes in parity.
5. Convert starter lifecycle material to configuration-only adoption. Require an
   Effigy version that supports automatic resolution and passthrough, document
   project-local/global skill resolution and host runner approval, and retain a
   clear standalone path when Queue is absent.
6. Replace copied-runtime checks with focused source-resolution, raw-stdio, v1/v2
   manifest, missing-runner, missing-skill, project-local precedence, global
   fallback, starter-consumer, and no-repository-runtime proofs.
7. Run the live cutover. After merge, make no manual integration edit: the required
   v2 hook must publish terminal state and remove this handoff from synchronized
   main.

## Acceptance and review oracle

| Invariant | Adversarial counterexample | Required proof |
| --- | --- | --- |
| Effigy is the runtime boundary | A repository launcher or copied TypeScript payload still executes | No `.paseo/hooks/**` or starter hook payload remains; v2 pins trusted runner `effigy` |
| Northstar owns lifecycle semantics | Queue or Effigy gains Northstar paths, states, or schema knowledge | External source diffs are empty; only opaque selector/argv crosses the boundary |
| Skill resolution is exact | Invocation cwd makes `scripts/lifecycle-queue-hook.ts` resolve from the consumer | Catalog uses `{skill}`; project-local and unique-global fixtures execute the intended bytes |
| Transport is exact | Effigy adds a header, footer, newline, or JSON envelope | Captured process boundary parses exactly one hook-result object with separate stderr and preserved exit status |
| Configuration is portable | Manifest embeds Tom's absolute path, digest, or install root | Repository contains runner ID and literal argv only; host approval stays outside Git |
| Missing prerequisites fail closed | Missing runner or Northstar skill falls back to copied code or an agent closeout | Required hook records visible failure before effect; no alternative closeout route runs |
| Standalone remains first-class | Removing the copied hook makes lifecycle maintenance require Queue | Installed skill lifecycle commands and consumer fixtures pass with Queue absent |
| Starter is copy-ready | Adoption instructions require copying Northstar executable code | Starter copies only manifest/configuration and explains external prerequisites |
| Live closeout proves the cutover | g03.010 closes through the old v1 executable or a manual docs commit | Queue evidence pins trusted runner `effigy`; hook publishes one closeout commit and consumes the exact handoff |

## Stop conditions

Stop if the change requires a repository shell launcher, copied Northstar runtime,
an absolute host path in Git, Queue or Effigy knowledge of Northstar lifecycle
semantics, a fallback closeout agent for a configured required hook, or a manual
post-merge lifecycle edit. Repair the same required closeout event if the v2 proof
fails; do not recreate the task or rewrite accepted history.

## Evidence

Northstar main at `c9e3533` still carries `.paseo/hooks/northstar-lifecycle` and a
copied `northstar-lifecycle.runtime/` payload. The installed skill owns the same
adapter and core, but its catalog does not expose `queue:hook` and its script paths
are invocation-relative. Queue main at `bd3eb8b` accepts a generic trusted runner;
Effigy main at `4f2b466` accepts qualified automatic resolution and exact stdio
passthrough. The remaining work is the Northstar-owned cutover and live proof.

## Next task

After terminal v2 closeout, return to Chatterbox to prepare the configuration-only
portfolio rollout. Do not roll out repositories from implementation or closeout.

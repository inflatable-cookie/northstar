# Papercuts

Small, actionable friction found during agent work. Agents append entries when
they hit a solvable hurdle; they do not stop the current task to fix one.

## Open

<!-- Keep entries short. Append newest entries at the top. Do not include secrets. -->

- **2026-08-28 — skill assets omitted batch-card template (resolved):** assets
  README listed `docs/specs/templates/batch-card-template.md` for stricter
  installs, but the file lived only under `template-bundle/` and was absent
  from the distributable skill package; impact was compile-roadmaps inferring
  fields from existing cards instead of the declared template; fixed by
  shipping a copy at
  `skills/northstar/assets/templates/docs/specs/templates/batch-card-template.md`
  and pointing the README at that path; affected surfaces are skill assets,
  compile-roadmaps consumers, and template-bundle parity.

- **2026-08-28 — vendored Effigy skill uses stale tasks JSON path
  (resolved):** examples queried `.result.payload.tasks[]` while live
  `effigy --json tasks` exposes `.result.catalog_tasks[]`; impact was failed
  machine-readable task inventory before ownership filtering; fixed by
  copying Effigy PR 49 (`552ef1b93283`) jq examples to
  `.result.catalog_tasks[].task` in `.agents/skills/effigy/SKILL.md` and
  `references/`; affected surfaces are the vendored Effigy skill examples.

- **2026-08-27 — install parity counted the Rust tool's build cache (resolved):**
  agent-owned Cargo bootstrap can leave `tools/rust-quality/target/` inside an
  installed skill, and the parity checker treated those ignored artifacts as
  payload drift; impact was a huge false failure after a valid published
  install; fixed by excluding that one declared Cargo cache alongside Effigy
  receipts; affected surface was `scripts/check-northstar-skill-install.rhai`.

- **2026-08-26 — docs QA traverses ignored Rust build output (resolved):** adding a
  skill-shipped Cargo crate left its ignored `target/` directory beneath the
  installed-payload source, and docs QA tried to decode a fingerprint artifact
  as UTF-8; impact is that validation fails after ordinary local Rust builds;
  fixed by restricting the command-surface text scan to known text files and
  excluding Cargo target trees; affected surface was
  `scripts/check-northstar-command-skills.rhai`.

- **2026-08-26 — Rhai Git helpers cannot inspect a foreign target root
  (resolved by boundary redesign):**
  skill-local audit tasks select the installed skill as `catalog_root`, so
  `git::status()` and `git::changed_files()` inspect the skill rather than the
  consumer root passed to the task; impact is that portable cross-repo scope
  discovery must use a narrowly allowlisted structured `git -C <target>`
  subprocess; plausible fix is an optional target-root argument or typed
  read-only Git context; affected surfaces are Effigy Rhai Git helpers and
  installed cross-repo audit tasks. Rust v2 now uses a Cargo-native binary;
  Effigy is optional repository evidence rather than the audit host.

- **2026-08-26 — skill-creator validator lacks executable mode:** the documented
  direct `quick_validate.py` invocation returned permission denied even though
  the script is readable and works through `python3`; impact is a misleading
  validation failure during skill distribution; plausible fix is to ship the
  script executable or document interpreter invocation; affected surface is
  the system `skill-creator` package.

- **2026-08-26 — production qualifier created generated output before its
  discovery snapshot:** the TypeScript audit self-test wrote
  `subject-notes.md` before recorder initialization while the live subject
  created it afterward; impact was a false-green qualifier and a wasted
  576-second frozen replicate, followed by the inverse mismatch when the live
  subject created the note first; fixed in revision S by qualifying both valid
  orderings and treating the note as optional scope but mandatory final output;
  affected surfaces are the production answer key, preparer, verifier, and
  deterministic harness.

- **2026-08-26 — exact rule-label recall penalized equivalent defect repair:**
  two isolated production audits made the same parser correction, but one used
  boundary plus readability labels and the other used boundary alone; impact
  was a second 467-second frozen cohort halt despite full physical defect
  coverage; plausible fix is exact primary-defect recall with a bounded valid
  corroborating-label set; affected surfaces are overlapping partially
  decidable rules and production evidence scoring.

- **2026-08-26 — single-rule fixture labels hid valid cross-rule findings:** a
  production whole-repository audit correctly applied boundary and readability
  rules to an error-labelled parser fixture, but the exact precision oracle
  allowed only the error rule; impact was a 589-second frozen cohort failure
  after otherwise valid work; plausible fix is a cross-rule answer-key review
  over every defective and clean case before freeze; affected surfaces are
  multi-rule audit benchmarks and exact precision gates.

- **2026-08-26 — trial oracles enforced unstated implementation choices:** early
  TypeScript trials required a TCP port range, input identity, and exact
  `aria-label` markup that their subject contracts did not state; the authoring
  oracle also confused rule signals with mechanical behavior; impact was three
  false trial failures after valid work; fixed locally by aligning contracts,
  separating behavior gates from comparison signals, and binding verifier
  hashes; plausible systemic fix is a contract-to-oracle coverage check before
  launch; affected surfaces are protected-behaviour and paired authoring trials.

- **2026-08-26 — Bun frozen install succeeds without an existing lock:** the
  TypeScript repair corpus ran `bun install --frozen-lockfile` before its first
  lock existed; Bun installed dependencies successfully but wrote no lock;
  impact is a plausible false reproducibility claim; plausible fix is to require
  lock presence before frozen installation and use an explicit lock-generation
  step for a new fixture; affected surfaces are TypeScript benchmark setup and
  future dependency-backed evidence packets.

- **2026-08-26 — nested container task fails from its documented package cwd:**
  Acowtancy's `cattle-grid/check` failed as local `effigy check` because the
  nested catalog declares `run_in = "container"` without its own target, while
  root-qualified selector passed through workspace ownership; built-in nested
  test routes then ran host-side and bypassed that container declaration;
  impact is false tooling failure and brittle language-pack evidence;
  plausible fix is to make nested catalogs inherit the owning workspace target
  for both named and built-in selectors, or expose one authoritative
  root-qualified route; affected surfaces are Effigy nested catalog routing
  and mixed-workspace audit discovery.

- **2026-08-26 — research route names a missing playbook:** the Northstar
  research mode requires `docs/research/research-to-implementation-playbook.md`,
  but neither that path nor a bundle-docs equivalent exists in the source repo;
  impact is a failed required read and ambiguity about the promotion workflow;
  plausible fix is to add the canonical playbook or update the mode to the
  actual authority; affected surfaces are the research mode and research front
  doors.

- **2026-08-25 — skill description budget is enforced only at closeout:** the
  Rust activation text passed skill validation but failed the later command
  surface check because the main description exceeded 60 characters; impact is
  late rewrite churn on discoverability metadata; plausible fix is to include
  the description-length assertion in skill-local validation or document the
  cap beside the frontmatter; affected surfaces are `skills/northstar/SKILL.md`
  and the command-skill checker.

- **2026-08-25 — Effigy/Rhai complexity limit lacks decomposition guidance:** a
  bounded recorder self-test failed at parse time with `Expression exceeds
  maximum complexity` before any case ran; impact is trial-and-error splitting
  for otherwise ordinary deterministic task scripts; plausible fix is to expose
  the configured limit and a function-level remediation hint in the error or
  Rhai guide; affected surfaces are Effigy-native validators and skill-local
  self-tests.

- **2026-08-25 — Seatbelt packet isolation denies `/dev/null` redirects:** the
  Rust audit recorder initially suppressed successful `jq` validation through
  `/dev/null`, but the write-denying subject profile blocks that device; impact
  is that an otherwise valid packet-local checker can fail only under the real
  evidence boundary; plausible fix is to make the profile's device policy
  explicit or keep packet helpers free of `/dev/null` redirects; affected
  surfaces are isolated subject/reviewer profiles and packet-local tooling.

- **2026-08-25 — zsh `path` loop variable destroys command lookup:** an archive
  verification loop used `path` for a manifest field, which overwrote zsh's
  special `$path` array and made `shasum` and `awk` disappear mid-loop; impact
  was a false validation failure after the prototype checks passed; plausible
  fix is to reserve shell-special names and use task-qualified variables such
  as `relative_path`; affected surfaces are ad hoc zsh validation snippets and
  future archive-verification helpers.

- **2026-08-25 — Rust evidence aggregate self-test hard-coded historical counts:**
  the focused revision G preparer and review tests passed with three audit arms
  and three reviews while `trial-runner.sh self-test` still reported nine and
  six; impact is misleading closeout evidence despite correct underlying checks;
  plausible fix is to derive or update aggregate labels with cohort shape;
  affected surface is the Rust quality prototype self-test summary.

- **2026-08-24 — macOS trial isolation needs canonical paths and a private Codex home:**
  Seatbelt resolved `/tmp` as `/private/tmp`, while ephemeral Codex still needed
  writable runtime state; impact was two false startup failures before any
  subject work; plausible fix is a checked launcher that canonicalizes every
  deny path, provisions a per-arm runtime home, and probes read/write boundaries
  before timing starts; affected surfaces are the Rust quality independent-trial
  launcher and future language-pack evidence runners.

- **2026-08-22 — parallel Effigy QA selectors contend on shared task locks:**
  running `effigy qa` and `effigy qa:docs` together caused a repo-contract lock
  conflict even though the docs check completed; impact is a false validation
  failure and rerun; plausible fix is to document serial validation or make
  task locks selector-aware; affected surfaces are Effigy task execution and
  repository validation guidance.

- **2026-08-19 — duplicated spine lists made a broad docs patch brittle:** the
  triage rollout touched several intentionally mirrored structure summaries and
  one large patch failed on stale surrounding context; impact was avoidable
  edit/retry churn and a higher chance of inconsistent copy-ready references;
  plausible fix is to centralize or mechanically validate the spine enumeration
  while keeping summaries concise; affected surfaces are `bundle-docs/`,
  `template-bundle/`, `README.md`, and docs-structure checks.

- **2026-08-17 — Atlas synthesized strategy before user discovery:** live use in
  existing projects found that Atlas laid out what should happen before asking
  for the operator's vision; impact was useful options arriving in the wrong
  direction and agent-authored strategy being mistaken for discovery; plausible
  fix is a discovery-first checkpoint with first-principles questions, an
  explicit pause, and no synthesis until the operator supplies or confirms
  direction; affected surfaces are the Atlas mode, router, adapter, spec,
  roadmap, and validation log.

- **2026-08-17 — consumer instruction audit depended on the Northstar source catalog:** the documented consumer command could not resolve from an installed skill because Effigy resolves Rhai tasks from the selected project/catalog root; impact was that `check:agent-instructions` worked only inside the Northstar source checkout; plausible fix is to ship a minimal skill-local Effigy catalog and shared audit helper, with the source task pointing at that same helper; parity must ignore Effigy's generated `.effigy/` receipts; affected surfaces are `skills/northstar/effigy.toml`, the installed skill helper, the root `effigy.toml`, the parity checker, and the agent-instruction review mode.

- **2026-08-17 — worker preflight was advertised as a normal-mode rule:** a
  consumer AGENTS audit treated Effigy orientation followed by a worktree check
  as the universal startup order; impact was unnecessary worktree concern for
  normal agents and a misleading Bovine finding; plausible fix is to activate
  the four-command preflight only from an orchestrator-dispatched handoff with
  explicit worker-mode metadata; affected surfaces are root AGENTS templates,
  the Northstar router, orchestrator mode, and handoff contracts.

- **2026-08-17 — harness worktree path mismatch duplicated a worker checkout:**
  t3code launched a clean registered worktree under `~/.t3/worktrees`, but the
  worker preflight treated its generated path/branch as invalid because they did
  not match handoff placeholders and created another worktree under a manual
  container; impact was 59 tool calls and an unwanted duplicate checkout;
  plausible fix is to make the current clean registered non-`main` worktree
  authoritative and run the four-command probe before Effigy orientation;
  affected surfaces are the worker handoff template, orchestrator mode, router,
  AGENTS guidance, and worktree contracts.

- **2026-08-17 — installed-skill audit discoverability:** `SKILL.md`, the
  router, and normalize-docs mode do not name `effigy
  check:agent-instructions` or contract 003, so the Poodle consumer review
  required searching the Northstar source checkout; impact is that an agent
  will not discover the review process without an operator hint; plausible fix
  is to route AGENTS review requests explicitly from normalize-docs; affected
  surfaces are the installed Northstar skill and normalize-docs reference.

- **2026-08-17 — agent-instruction audit target bridge scope:** auditing
  `../poodle/AGENTS.md` still checked Northstar's root/template Claude bridges
  and reported both OK while Poodle's bridge lacked exact `@AGENTS.md`; impact
  is a false-green consumer bridge result; plausible fix is to derive the
  bridge from each target root or accept explicit bridge paths; affected
  surface is `scripts/check-northstar-agent-instructions.rhai`.

- **2026-08-17 — agent-instruction audit byte metric:** the audit reports
  `text.len()` as bytes, but Poodle's Unicode-bearing `AGENTS.md` measured 5,413
  bytes with `wc -c` while the audit reported 5,397; impact is understated byte
  and approximate-token evidence; plausible fix is to count encoded bytes;
  affected surface is `scripts/check-northstar-agent-instructions.rhai`.

- **2026-08-16 — path-only worker handoff resolution:** the fresh worker's first
  relative `read_file` lookup resolved under `/Users/tom` instead of the named
  worktree and required repository search to recover the handoff path; impact is
  that a path-only brief is not yet uniformly consumable by every file-tool
  backend; plausible fix is to make worker file resolution explicitly root at
  the selected worktree; affected surfaces are the worker launcher/tool adapter
  and `skills/northstar/references/modes/orchestrator.md`.

- **2026-08-16 — stale remote HEAD lock during worker preflight:** `git fetch
  origin` was blocked by a leftover `refs/remotes/origin/HEAD.lock`; after
  confirming no Git process was active, removing the stale lock restored fetch;
  impact is avoidable launch friction; plausible fix is a guarded preflight that
  detects and reports stale locks without deleting live locks; affected surfaces
  are the orchestrator launch procedure and local Git preflight.

- **2026-08-16 — skill parity checker runtime (resolved):** `effigy
  check:skill-install` failed before comparison because the runtime did not
  provide array `.join(...)`; impact was that source/install parity could not be
  proven; fixed by using an explicit separator loop in
  `scripts/check-northstar-skill-install.rhai`; parity now passes for 32 files.

- **2026-08-16 — roadmap provenance check:** the docs QA also requires the phrase
  `consumer papercuts evidence` in the g02 front door after the next-task rewrite;
  impact is that provenance disappears from a currentness update; plausible fix is
  to make provenance a structured field rather than a prose contains-check;
  affected surface is `docs/roadmaps/README.md`.

- **2026-08-16 — roadmap currentness check:** docs QA contains-checks still
  require historical prose such as `` `g02.024` is complete `` and `No blocking
  roadmap milestone is open` after the active lane changes; impact is that
  truthful currentness edits fail QA or must retain explicitly superseded text;
  plausible fix is to assert structured milestone/card status instead of stale
  prose; affected surfaces are `docs/roadmaps/g02/README.md` and
  `docs/roadmaps/generation-index.md`.

- **2026-08-16 — research index hard-break whitespace:** `git diff --check`
  flags Markdown hard-break spaces on a metadata line when that line is edited;
  impact is noisy diff validation; plausible fix is to use ordinary newline style
  or exclude intentional Markdown hard breaks from the check; affected surface is
  `bundle-docs/research/master-index.md`.

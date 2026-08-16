# Papercuts

Small, actionable friction found during agent work. Agents append entries when
they hit a solvable hurdle; they do not stop the current task to fix one.

## Open

<!-- Keep entries short. Append newest entries at the top. Do not include secrets. -->

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

- **2026-08-16 — roadmap currentness check:** the docs QA contains-check still
  requires the historical completion phrase `` `g02.024` is complete `` after a
  next-task rewrite; impact is that legitimate currentness edits fail QA;
  plausible fix is to assert structured status instead of stale prose; affected
  surface is `docs/roadmaps/g02/README.md`.

- **2026-08-16 — research index hard-break whitespace:** `git diff --check`
  flags Markdown hard-break spaces on a metadata line when that line is edited;
  impact is noisy diff validation; plausible fix is to use ordinary newline style
  or exclude intentional Markdown hard breaks from the check; affected surface is
  `bundle-docs/research/master-index.md`.


# TypeScript And Svelte Explicit Audit And Repair

Use only when the operator explicitly requests a TypeScript or Svelte quality
audit, no-slop pass, whole-codebase review, or audit-and-fix action. Ordinary
coding never selects this mode.

Load `../language-quality/typescript/strict-audit.json` and
`../language-quality/typescript/audit-recording.md`. Do not load or invent an
everyday authoring projection.

## Resolve before mutation

1. Check the applicable marked activation block plus
   `docs/contracts/typescript-quality-profile.json` and deviations file. If any
   are missing, choose the narrowest package-owning scope and run
   `effigy --repo <installed-northstar> northstar/typescript-quality:setup apply <absolute-target-root> <scope-directory>`.
   Setup discovers package ownership and overlays; it never installs packages.
2. Require strict explicit-audit workflow. Resolve owned packages,
   unregistered candidates, exclusions, and Svelte version evidence. Apply the
   Svelte 5 and SvelteKit 2 overlays only to packages that own them. Stop that
   overlay on unsupported or unresolved versions; base TypeScript may remain.
3. Resolve `worktree` for uncommitted/staged/unstaged/tranche requests and
   `repository` for whole-codebase/workspace requests. Ask only when intent is
   genuinely ambiguous.
4. Inventory Git state read-only. Give every dirty file an in-scope or excluded
   disposition. For repository scope, cover every owned package and relevant
   source/config/test surface; report unregistered candidates separately.
5. Read repository architecture and public error, package, request, and
   serialization contracts. Changes to those contracts are operator decisions.
6. Partition scope into non-empty units with disjoint files. Initialize the
   recorder before assessment or mutation.

## Assess before editing

Run separate correctness, architecture, and human-quality passes. Inspect source
and direct call paths before recording a finding. Record exact location,
evidence, action, confidence, disposition, and effective authority, then record
the complete unit assessment before mutation.

- `report_only`: report; no repair plan.
- `review_required`: use `repair_planned` only with a bounded plan, owned files,
  protected behavior, and viable validation. Use `reported` to retain an honest
  finding without mutation when repair or proof is unavailable.
- `operator_decision`: record the stop; do not mutate.
- deviation: require an exact repository-owned accepted record.
- `TS-SLOP-001`: evaluation-only/report-only. Maintain a total candidate ledger
  and assess corroborated candidates independently under a normative rule.

Repository tools provide evidence, not authority. Record compiler, framework,
lint, and test classes separately with selector, package cwd, actual environment,
exit status, diagnostics, warning count, and failure stage. A clean result needs
zero exit and zero warnings. Routing, startup, configuration, or collection
failure is `unavailable`, never a source pass.

## Repair and finalize

- Treat one assessed unit as one coherent wave. Make the smallest authorized
  change that resolves its findings and preserves named behavior.
- Run `extend` before editing a direct caller, test, doc, or contract outside
  current ownership. The recorder rejects late and cross-unit extension.
- Never install dependencies, migrate toolchains, blanket format/fix, clean up
  unrelated code, replace architecture, or break interfaces.
- Format only files already changed by an authorized repair.
- Complete each unit with exact changed-file attribution and repository-native
  evidence. Preserve report-only and excluded dirty files byte-for-byte.
- Finalize only after every unit completes. The recorder rejects hidden
  mutation, changed policy, cross-unit attribution, and dirty-state loss.

Report resolved scope and overlays, catalogue hash, findings, candidate ledger,
repair waves, deviations, extensions, preservation, tool evidence, operator
stops, and limitations. Completion is not certification, NASA compliance,
high-assurance validation, everyday-authoring evidence, or proof for deferred
toolchain/testing rules.

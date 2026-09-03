# Dispatch Convergence Rust Package Canary

Date: 2026-09-03
Roadmap: `g02.048`
Card: `119`
Status: consumer canary in flight

Northstar PR 27 passed exact-head review at
`63353b1bb83d4e6fefb6a28e800412bcbd125046` and squash-merged as
`256d0f78892e5cc22fa1672431fe8310df4f9162`. Registry version `1.4.0`,
the generic Rust routes, the real-package lifecycle oracle, and the bounded
fallback are now on `main`.

Convergence owns the next serial proof under ready milestone `g02.031` and
card 102, committed and pushed as
`c8f513fb1070aee60a40815e07a84db89fd314c3`. Paseo workspace
`wks_05ec1974d0842837` runs worker
`883c13b9-ea3e-4504-a567-7fe363e2b69d` from the committed handoff. The
worktree container has read-only links to the Northstar and
Northstar-language-packs primary checkouts.

The lane is evidence-only: installed package identity, distinct everyday and
explicit workflows, profile/deviation/evidence compatibility, Rust-only
inventory, visible fallback, and consumer byte preservation. Product repair
and card 120 remain out of scope.

## Next Task

Review the Convergence canary PR at its reported exact head. Card 120 stays
blocked until that evidence is accepted.

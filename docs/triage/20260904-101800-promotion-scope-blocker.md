# Promotion scope blocker: superseded planning-delegate surfaces

Status: resolved; operator-confirmed scope expansion
Disposition: route the expanded map through the same promotion lane

The bounded promotion worker stopped before edits. Removing
`skills/northstar/assets/templates/northstar-discovery-delegate.md.template`
would break the required `effigy check:command-skills` because
`scripts/check-northstar-command-skills.rhai` still reads that template.

Exact-token review also found live planning-delegate references in these
out-of-map surfaces:

- `skills/northstar/references/handoff-contract.md`
- `template-bundle/contracts/002-agent-local-paths-template.md`
- `docs/contracts/contract-index.md`

The operator confirmed that these four callers may be added to the promotion
map. The original destination map and the later reviewer-placement override
remain unchanged.

The worker retained workspace `wks_9a7941e458c92da3` and child identity
`54d6b7c6-6e41-42ef-9f37-30fa7d7baf9a`; no files were changed. Resume that
same child only after the updated handoff is pushed. The later
operator-confirmed packet still overrides reviewer placement if the lane
resumes.

# Adopt Automation Runtime Policy

Status: complete
Owner: repo maintainers
Date: 2026-04-08
Roadmap refs: g01.002
Governing refs: docs/contracts/001-working-rules.md, docs/specs/archive/002-automation-runtime-policy.md

## Summary

Defined Northstar's automation runtime hierarchy as `Effigy -> TypeScript+Bun
-> explicit exceptions`, aligned the setup surfaces with that rule, and applied
it to Northstar itself by migrating the live checker lane away from Bash.

## Files Changed

- added `bundle-docs/sections/10-automation-runtime-policy.md`
- updated live and template working-rules surfaces with the runtime policy
- updated `northstar-setup`, its repo contract, and its starter templates
- added `skills/northstar-setup/assets/templates/scripts.README.md.template`
- rewrote the live checker scripts as:
  - `scripts/check-northstar-bundle.ts`
  - `scripts/check-northstar-repo-contract.ts`
  - `scripts/lib/checks.ts`
- updated `effigy.toml` to use Bun-run TypeScript checkers
- removed the legacy Bash checker scripts
- synced `northstar-setup` into both installed skill homes

## Validation

- `effigy qa`
- `effigy qa:docs`

## Outcome

- Northstar now publishes a clear default automation stack instead of implying
  one through scattered examples
- new repos can inherit the runtime policy directly from setup and starter
  templates
- Northstar itself now follows the policy for its main repo checker lane
- Effigy remains the front door for repo maintenance rather than being
  displaced by custom Bun scripts

## Unresolved

- the policy is now clear, but the next autonomy limit is still ready-state
  selection and closeout coordination rather than scripting runtime drift

## Next Task

Compile the next live milestone around ready-state selection and closeout
mechanics for longer hands-off execution.

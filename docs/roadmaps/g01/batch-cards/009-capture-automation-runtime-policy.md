# 009 - Capture Automation Runtime Policy

Status: archived
Owner: repo maintainers
Updated: 2026-04-08
Master spec refs: docs/specs/archive/002-automation-runtime-policy.md
Roadmap refs: g01.002 batch 2.1
Governing refs: docs/contracts/001-working-rules.md, bundle-docs/README.md, skills/northstar-setup/SKILL.md
Auto-start next card: yes, if the policy is explicit in doctrine, setup, and template guidance

## Objective

Define the automation runtime policy as a real Northstar rule and thread it
through the setup surfaces new repos will actually use.

## Scope

- add the doctrine for the automation runtime stack
- add the rule to the live working rules and template working-rules surface
- align `northstar-setup`, its repo contract, and starter templates
- add a standard scripts README template

## Steps

1. Write the automation runtime doctrine.
2. Update the live and template working-rules surfaces with the policy.
3. Update `northstar-setup` and its references/templates so new repos inherit
   the policy clearly.
4. Update the repo script guidance so the live repo reflects the same rule.

## Acceptance Criteria

- the policy is explicit in bundle doctrine
- the policy is captured in live and template working-rules surfaces
- `northstar-setup` and its templates point repos at the same stack
- a copy-ready scripts README template exists

## Evidence Required

- updated doctrine, contract, and setup/template files

## Stop Conditions

- the policy reads like a ban on Effigy rather than a runtime hierarchy
- setup still leaves runtime choice implicit for new repo scripts

## Completion Notes

The policy is now explicit in doctrine, live and template working rules,
`northstar-setup`, and both the live and templated scripts guidance. New repos
have a clear runtime hierarchy instead of an implied mixed-scripting default.

## Next Task

Migrate the live repo checker scripts to TypeScript+Bun, sync the updated setup
skill into the installed homes, and validate the repo.

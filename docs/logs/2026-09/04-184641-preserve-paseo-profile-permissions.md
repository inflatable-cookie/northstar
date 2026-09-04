# Preserve Paseo Profile Permissions

Date: 2026-09-04  
Status: complete

## Result

Northstar now treats a selected Paseo profile as a complete launch bundle for
every child thread it creates. Agent creation copies the profile's
provider/model, `modeId`, `thinkingOptionId`, and `featureValues`; it may not
omit or downgrade the operator-configured full-accept/full-access permission
mode and fall back to an ask-for-permission default.

The rule covers workers, reviewers, chatterboxes, planning delegates, bounded
research children, mechanical projection workers, and successor coordinators.
It removes routine tool approval interruptions without widening any child's
planning, mutation, destructive-action, review, or merge authority.

## Failure fixed

Northstar selected agents from current Paseo profile notes but several launch
recipes named only the model, workspace, prompt, and finish notification. Paseo
profiles are not passed to `create_agent` by name: their fields must be
materialized into the call. Omitting `settings.modeId` therefore discarded the
profile's permission setting and let the provider default back to asking.

## Evidence

- the reusable doctrine, source-repo contract, architecture, master spec, and
  installed orchestrator mode carry one complete-profile launch invariant;
- the command-skill checker accepts an exact profile-settings projection and
  rejects both an omitted `modeId` and an ask-mode downgrade;
- skill-creator validation, `effigy check:command-skills`, `effigy qa:docs`,
  and `effigy qa` pass;
- the installed Northstar copy matches source exactly: 111 files.

## Next

Use the next real Paseo child launch as dogfood evidence: its effective runtime
mode should match the selected profile without a basic-operation approval
prompt.

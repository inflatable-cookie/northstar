<!-- northstar:typescript-quality:start -->
## Northstar TypeScript/Svelte explicit audit

Use Northstar's TypeScript/Svelte quality pack only when the operator explicitly
requests a TypeScript or Svelte quality audit, no-slop pass, whole-codebase
review, or audit-and-fix action. Ordinary TypeScript/Svelte coding does not
activate it.

For explicit audit intent, load the main Northstar router and select
`TypeScript/Svelte explicit audit-and-repair`. Resolve package ownership and
strict profile state before assessment. Record findings before mutation, keep
repairs inside recorder-authorized files, preserve pre-existing dirty work, and
use repository-owned compiler, framework, lint, and test evidence without
installing dependencies or inventing commands.
<!-- northstar:typescript-quality:end -->

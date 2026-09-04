# Workspace-Container Example

Use this specimen when a project has:

- a thin orchestration root
- one nested docs-authority repo
- one or more shipping child repos

This is the cleanest recurring multi-repo Northstar shape.

## Example Shape

```
workspace-root/
├── README.md
├── AGENTS.md
├── effigy.toml
├── app-a/
├── app-b/
└── ledger/                 # docs-authority repo
    ├── README.md
    ├── AGENTS.md
    ├── effigy.toml
    ├── vision/
    ├── architecture/
    ├── contracts/
    ├── roadmaps/
    ├── logs/
    └── specs/             # only when consequence-triggered modules are warranted
```

Representative real repos from the Northstar proof runs:

- `acowtancy/ledger`
- `songsprout/trellis`
- `contact-patch/cp-docs`
- `underlay-reference/acme-docs`
- `loophole/composer/composer-docs`

## Contract Split

The workspace root owns:

- orchestration README and AGENTS guidance
- root Effigy tasks for workspace-wide flows when needed
- links into the nested authority repo

The nested docs-authority repo owns:

- the compact Northstar docs spine and consequence-triggered modules
- `qa:docs`
- `qa:northstar`
- docs policy
- migration or lifecycle planning state

Shipping child repos own:

- real build/test/release posture when they actually ship artifacts
- app-local implementation docs only if they do not compete with the authority repo

## Effigy Pattern

Pick one of two clean modes:

1. nested repo is the true repo root for docs validation

- run `effigy qa:docs --repo /path/to/authority-repo`
- use local relative paths in that nested repo's `effigy.toml`

2. workspace root routes into the child catalog

- run `effigy <child>/qa:docs --repo /path/to/workspace-root`
- use root-prefixed paths in the child catalog's docs tasks and docs-policy config

Do not mix those modes in the same task surface.

## Front-Door Rules

The workspace root should say plainly:

- which nested repo is the docs authority
- where active planning lives
- when to use root orchestration tasks versus authority-repo docs tasks

The nested authority repo should say plainly:

- authority mode and active lifecycle state
- the active generation/milestone/spec lane
- the current ready card or paused planning gate

## Anti-Patterns

- duplicating the full docs spine at the workspace root and in the authority repo
- teaching `--repo .` as the normal example in either place
- adding release posture to the authority repo when it is docs-only
- leaving root and authority front doors disagreeing about where planning lives
- mixing local relative docs-policy paths with root-routed child-catalog tasks

## Next Task

Use this specimen when the next multi-repo setup or migration has a thin root
plus nested docs-authority shape.

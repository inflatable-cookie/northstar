# Logs

Logs capture dated evidence and assessments for Northstar's own development
work.

## Segmentation model

- Group logs by month directory: `YYYY-MM/`
- Name each log: `DD-HHMMSS-<slug>.md`

## Cadence and evidence rule

- Normal delivery evidence closes directly on its completed batch card
  (outcome, validation, PR, commit, and material limits).
- Dedicated logs are reserved for incidents, releases, material migrations,
  cross-lane decisions, or evidence sets too large to keep the card legible.
- Historical evidence is retained through generation roll-ups; routine logs
  are pruned at generation closure.

## Recent active-lane evidence

- `2026-09/04-191812-pin-reviews-to-worker-workspaces.md`
- `2026-09/04-184641-preserve-paseo-profile-permissions.md`
- `2026-09/04-141135-route-pre-pr-decisions-through-chatterbox.md`
- `2026-09/04-132051-wire-installed-language-package-route.md`
- `2026-09/04-122000-finish-continuous-coordinator-delivery.md`

## Historical provenance

Evidence from closed generations is curated in their generation roll-ups:
- `g01`: `docs/roadmaps/archive/g01.md`
- `g02`: `docs/roadmaps/archive/g02.md`

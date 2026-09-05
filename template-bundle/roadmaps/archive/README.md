# Closed-generation roll-ups

**Type: REQUIRED after a generation closes** -- One non-authoritative file per
closed generation.

Create `docs/roadmaps/archive/gNN.md` when a generation is safely closed:
during rollover, or during refresh / normalize / authorized cleanup of a
generation that is already closed but still expanded.

Copy [rollup-template.md](./rollup-template.md) and replace the placeholders.
Do not copy old execution steps, card instructions, or active status into the
roll-up. Git remains the full-fidelity archive.

Keep only the active sequential generation expanded.

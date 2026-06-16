# 022 - Formalize Repo Posture Classification

Status: retired-in-place
Owner: repo maintainers
Updated: 2026-04-10
Vision refs: docs/vision/001-northstar-delivery-vision.md
Governing refs: docs/contracts/001-working-rules.md
Roadmap refs: g02.019

## Problem

Northstar now has stronger docs-shape guidance, but the skills still rely too
heavily on operator judgment to decide what kind of repo state they are
looking at. In practice, the same handful of states recur:

- healthy active execution lane
- paused strict planning gate
- baseline routing-only repo
- migration-in-progress repo
- drifted or untrustworthy repo

Without an explicit posture model, setup, planning, and recovery work still
needs more interpretation than it should.

## Goal

Make repo-posture classification and paused-gate triage explicit in doctrine
and the core Northstar skills.

## Target Outcome

- one compact posture taxonomy exists in the package
- `northstar-setup` classifies posture as part of setup/normalization work
- `northstar-plan` distinguishes execution-ready lanes from paused planning
  gates and intent checkpoints more mechanically
- `northstar-recover` diagnoses drift against the same posture model

## Ready Chain

- `064-promote-repo-posture-classification-into-skills.md` — complete

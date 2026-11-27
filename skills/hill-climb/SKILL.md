---
name: hill-climb
description: Rate each part of a scope out of 10, then fix and re-rate when asked. Use for a quality assessment, scorecard or hill-climb on a codebase, crate or docs set.
---

# Hill-climb

Rate each part of the scope out of 10. For an assessment, report the
verified findings and recommended target. For an improvement run, fix what
holds the lowest parts back, re-rate, and record the achieved standard.

## 1. Define the scope

- Name the scope and split it into parts: a module, a crate's CLI or daemon
  surface, an app's backend or renderer, the tests, one docs file. A part is
  small enough that one reader can judge it whole.
- Fix the rubric before the first read. For code, rate each part on:
  correctness and safety, clarity, structure, error handling, tests, idiom
  and simplicity. Adapt the dimensions for docs or design, and keep
  correctness first.
- Anchors: **10** exemplary, nothing worth changing; **9** strong, clean and
  well-tested with at most trivial polish nits not worth a dedicated pass;
  **8** solid, no bugs or structural debt but minor real gaps or edge cases
  worth a cleanup batch; **7** good, with clear bugs, error-handling or test
  gaps, or structural friction to fix; **5–6** real debt; **below 5** risky.
- Rate integration as one extra score out of 10: how the parts fit together,
  with seams, duplication and contracts between parts.
- Name the spec documents (architecture, safety model, contracts) readers
  must read first. Findings anchored to stated guarantees are the most useful.

## 2. Read independently

- Use one fresh read-only reader when it can assess the whole scope and
  how the parts fit together. Split broader scopes across readers. Run
  those reads in parallel when the harness allows, or as separate
  fresh-context passes.
- Never show a reader earlier scores or findings; a re-read must not be
  anchored.
- Each reader returns scores by dimension and overall, plus concrete
  `file:line` findings, bugs first. Every score below 9 must cite the
  actionable findings holding it at that anchor. Readers never see the
  target; the coordinator filters findings to parts below it in steps 3–4.
- If the harness can't give a reader fresh context, tell the operator the
  read wasn't independent, or ask them to run it in a fresh session.

## 3. Verify and set the target

Check surprising claims yourself before they become work. Drop findings
that don't hold up, and align each score with the severity of its verified
findings using the rubric anchors so reader calibration stays consistent
across rounds.

The baseline is the lowest verified overall score among the parts and
integration. Use the operator's target when given. Otherwise aim one level
above the baseline, up to 10. The target applies to every part and integration. If a fix can
confidently reach a higher level in the same run, take it.

If the operator asked for an assessment, report here.

## 4. Fix in batches

- Turn verified findings into tasks grouped by area. Real bugs go in their
  own correctness batch, first. Structure, contracts and docs follow.
- Never run two batches that touch the same files at once. Check open PRs,
  branches and worktrees for in-flight work in those areas, and wait for it.
- Check downstream callers before changing public behaviour. Agree on a
  compatibility plan before making a breaking change, and describe it in the PR.
- Keep the scorecard in the project's planning surface when one is
  available. Otherwise include it in the report.

## 5. Re-read

After each round, repeat the independent read (step 2) for every part that
was below target or modified in the round, plus integration whenever changes
touched seams or shared contracts. Untouched parts that already met the
target keep their verified score. When fixes remove, split or merge parts,
update the scorecard and re-read the affected parts and integration. Stop
when every part and integration meet the target, or a round does not raise
the verified floor. Explain any remaining shortfall,
including integration.

## 6. Make it a standing gate

Only when the operator asks for a standing standard, record the rubric and
the verified floor in the project's agent instructions:

- A worker rates the parts it touched and, if the change affects how parts fit
  together, integration.
- A reviewer checks the same scores at the revision under review. Send back
  a change that drops a part across a rubric anchor (a new bug, unhandled
  error path or test gap) or adds a part below the floor. Score jitter of a
  point with no such finding is not a regression.

After that, sweeps are occasional checks at milestones or when scores drift.

## Report

Give the operator the scorecard (each part and integration, per read) and
the verified floor. For an assessment, include the recommended target and
next fixes. For an improvement run, include what changed, any parts short
of the target, and any standing gate recorded.

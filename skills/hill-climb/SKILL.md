---
name: hill-climb
description: Assess or raise the quality of a defined scope by rating each part out of 10, then fixing and re-rating when asked. Use for a quality sweep, a hill-climb, or a request to bring a codebase, crate, or docs set up to a target score.
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
- Anchors: 10 exemplary; 8 solid, nits only; 7 good, with clear improvements
  due; 5–6 real debt; below 5 risky.
- Rate integration as one extra score out of 10: how the parts fit together,
  with seams, duplication and contracts between parts.
- Name the spec documents (architecture, safety model, contracts) readers
  must read first. Findings anchored to stated guarantees are the most useful.

## 2. Read independently

- Split the scope across several read-only readers, run in parallel if the
  harness allows, otherwise as separate fresh-context passes.
- Never show a reader earlier scores or findings; a re-read must not be
  anchored.
- Each reader returns scores by dimension and overall, plus concrete
  `file:line` findings, bugs first. Once a target is set, limit other
  findings to parts below it.

## 3. Verify and set the target

Check surprising claims yourself before they become work. Drop findings
that don't hold up and correct the scores they affected.

The baseline is the lowest verified overall score among the parts and
integration. Use the operator's target when given. Otherwise aim one level
above the baseline, up to 10. The target applies to every part and integration. If a fix can
confidently reach a higher level in the same run, take it.

If the operator asked for an assessment, report here.

## 4. Fix in batches

- Turn verified findings into tasks grouped by area. Real bugs go in their
  own correctness batch, first. Structure, contracts and docs follow.
- Never run two batches that touch the same files at once, and wait for
  in-flight feature work in those areas.
- Check downstream callers before changing public behaviour. Agree on a
  compatibility plan before making a breaking change, and describe it in the PR.
- Keep the scorecard in the project's planning surface when one is
  available. Otherwise include it in the report.

## 5. Re-read

After each round, re-read with fresh readers (step 2). Stop when every part
and integration meet the target, or a round moves nothing. Explain any
remaining shortfall, including integration.

## 6. Make it a standing gate

When the operator wants a standing standard, record the rubric and the
verified floor in the project's agent instructions:

- A worker rates the parts it touched and, if the change affects how parts fit
  together, integration.
- A reviewer checks the same scores at the revision under review. Send back
  a change that lowers an existing score or adds a part below the floor.

After that, sweeps are occasional checks at milestones or when scores drift.

## Report

Give the operator the scorecard (each part and integration, per read) and
the verified floor. For an assessment, include the recommended target and
next fixes. For an improvement run, include what changed, any parts short
of the target, and any standing gate recorded.

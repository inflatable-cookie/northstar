---
name: hill-climb
description: Raise the quality of a defined scope at least one level per run by rating every part out of 10, fixing what holds the lowest parts back, and re-rating. Use when the operator asks for a quality sweep, a hill-climb, a code-quality pass, or to get a codebase, crate or docs set "up to an 8".
---

# Hill-climb

Rate every part of a scope out of 10, lift the parts below the current level,
re-rate, then raise the level. Sweeps alone don't hold the gains; the
rubric ends as a standing gate on every change.

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
- Each reader returns a table (part, score per dimension, overall) and
  `file:line` findings only for parts below the current target, bugs first.
  Above the target it says nothing unless there is a bug.

## 3. Set the baseline

The baseline is the first level every part must reach: the lowest level that
most parts already sit at or near, usually 6 or 7.

Each run must lift the whole scope at least one level: every part to the
baseline, the next run to baseline + 1, and so on toward 10. One level is the
minimum, not a cap. If a part can confidently reach a higher level in the same
run, take it.

## 4. Verify before acting

Readers produce false positives and true positives that look alike. Check
every surprising claim yourself (run the formatter, call the API, reproduce
the bug) before it becomes work. Drop what doesn't reproduce.

## 5. Fix in batches

- Turn verified findings into tasks grouped by area. Real bugs go in their
  own correctness batch, first. Structure, contracts and docs follow.
- Never run two batches that touch the same files at once, and wait for
  in-flight feature work in those areas.
- When downstream projects pin the code, list public API removals in each
  batch's PR.
- Keep the scorecard (scores per part per read, and the current level) in the
  project's planning surface, not in the repository.

## 6. Re-read

After each round, re-read with fresh readers (step 2). When every part meets
the current level, raise it by at least one. Stop when the operator's target is met or
a round moves nothing; report which parts are stuck and why.

## 7. Make it a standing gate

New work lands below the level and drags the average back, so a sweep alone
won't converge. Once the sweep ends, write the rubric and current level into
the project's agent instructions:

- A worker rates the parts it touched before marking work ready.
- A reviewer rates them at the exact head under review, lists the scores, and
  sends back any change that lowers a part, or adds a new part below the
  current level.

After that, sweeps are occasional checks at milestones or when scores drift.

## Report

Give the operator the scorecard (each part and integration, per read), the
current level, the bugs fixed, the parts stuck below the level with the
reason, and where the standing gate now lives.

# Review

The reviewer is independent: a different thread, and a different model where
possible. It checks the exact PR head against the brief.

## Check

1. **Outcome.** Does the change deliver what the brief says, and nothing
   unrelated?
2. **Correctness.** Look for bugs, missed callers, broken contracts and unsafe
   changes. Run the repository's validation command.
3. **Knowledge.** If the change alters what is true, is the owning file in
   `docs/knowledge/` updated in the same PR? Did it restate a fact that belongs
   elsewhere? Does it reintroduce anything in `retired.toml`?
4. **No process residue.** No task status, handoff files or delivery logs added
   to the repository.

## Report

Lead with the verdict: approve, or request changes. List findings by
severity, each with the file and line, what is wrong, and a concrete failure
case. Skip style nits unless they hide a real problem. Report through Queue.

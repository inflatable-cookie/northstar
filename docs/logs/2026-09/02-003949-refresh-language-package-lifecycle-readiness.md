# Refresh Language Package Lifecycle Readiness

Date: 2026-09-02
Roadmap: `g02.048`
Cards: `g02.048/116-117`
Status: planning repair complete; card 117 ready

## Result

PR 21 merged card 116 at `eaeac8889dd340e03558594e3d486b5dceaef9ce`.
The post-merge readiness pass did not promote card 117 immediately. It found
two machine boundaries named by architecture and contract 004 but not settled
well enough to implement: canonical package-tree identity and the
operator-owned trust/lifecycle state used for activation, revocation, and
rollback.

The repair now defines required `sha256:` manifest and tree identities, a
portable sorted length-framed file stream, executable-bit handling, and
fail-closed path/type rules. It also defines immutable receipt references, an
operator trust/revocation document, a revisioned lifecycle index, atomic
selection replacement, and rollback against retained reverified content.
Those rules are promoted into architecture and contract 004; spec 034 retains
the detailed framing and decision history.

Card 117 names the exact accepted card-116 commit and file hashes, owns the two
remaining schemas and generic runtime implementation, and carries new content-
identity and stale-writer oracle rows. No language policy, TypeScript/Rust
extraction, global path, required Effigy dependency, or consumer-owned trust
entered the card.

## Readiness

- Posture: `strict-ready` for card 117.
- Planning verdict: coherent.
- Execution boundary: card 117 only; cards 118-120 remain dependency-blocked.
- Operator decision: none before dispatch unless implementation contradicts
  the promoted digest or state model.
- Auto-start: no.

## Validation

- `effigy qa:docs` passed;
- `effigy qa` passed;
- `git diff --check` passed.

## Next

Dispatch card 117 from the accepted card-116 baseline. Review and merge its
generic lifecycle proof before refreshing the TypeScript canary.

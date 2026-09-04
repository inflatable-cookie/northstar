# Promote Continuous Coordinator Delivery

Date: 2026-09-04
Status: canonical planning promoted; card 129 ready

## Result

Live card-128 delivery proved the corrected role topology but exposed three
remaining mechanical stalls. The coordinator stopped after merge, stopped again
after closeout, and required operator `continue` to inspect the next card. Its
review contract did not explicitly prevent same-model self-review, and the
GitHub connector's rejected write required an ad hoc native-CLI fallback.

Spec 037 now requires continuous progression across every actionable mechanical
transition. Child-wait yields remain prompt and non-polling, but they do not
notify Chatterbox. Only an empty canonical runway sends Chatterbox one
administrative notice. Blockers still go to their named escalation owner.

The cross-model triage decision is promoted: reviewer and worker must have
different underlying provider/model identities. Card 129 implements these
corrections, plus a bounded authenticated native-write fallback after an
unchanged valid merge gate. Card 126's passive cohort covers the first ten
natural post-card-129 PR lanes or ends at 17:00 Europe/London on 2026-09-18.
Observation never blocks delivery.

## Dispatch

`g02.054/129` is the sole ready implementation lane. Card 126 is serial and
passive after its merge and installed parity. No promotion worker or further
operator confirmation is required.

## Validation

- `git diff --check` — clean
- `effigy qa:docs` — PASS
- adversarial planning review — one ready implementation lane, one serial
  passive observation lane, no operator-confirmed meaning left unresolved

## Next task

Dispatch card 129 immediately, review it with a different underlying model,
merge, refresh installed parity, and begin passive card-126 observation.

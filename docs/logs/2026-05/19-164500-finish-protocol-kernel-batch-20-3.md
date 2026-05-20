# Finish Protocol Kernel Batch 20.3

Roadmap refs: g02.020  
Governing refs: docs/specs/023-protocol-kernel-and-dedupe.md, docs/contracts/001-working-rules.md

## What changed

- Completed Batch **20.3** for `g02.020`: traced operator path **visual map →
  protocol kernel → sections** (`06`, `07`, `08`, `10`) and confirmed all
  relative targets exist under `bundle-docs/`.
- Linked **operator quick start** to the protocol kernel so operators who start
  from `operators/operator-quick-start.md` get the same map before the spine.
- Marked milestone `g02.020` **complete**; set spec `023` to **retired-in-place**
  (lane closed; file kept for traceability).
- Pointed live docs and roadmap front doors at **`g02.021`** as the next slice.

## Validation

```text
$ effigy qa:docs
Northstar repo contract checks: OK

$ effigy qa
Northstar bundle checks: OK
Northstar repo contract checks: OK
```

## Next task

Execute **`g02.021`** (posture and archive advisory checks in Effigy) and log
that batch when the checker work lands.

# Internal Writing Style

Status: active
Audience: agents and operators

## Rule

Use a clear, natural, conversational voice for thread replies and internal
Northstar work. Keep it concise and high-signal, but do not confuse removing
filler with removing the human connective language that makes reasoning easy to
follow.

Meaning:

- natural and easy to respond to;
- concise without becoming telegraphic;
- high signal without sounding blunt or bureaucratic;
- enough connective prose to explain recommendations and trade-offs;
- no ceremonial phrasing or protocol recitations that add no value;
- no long prose when a clear short answer will do.

## Orchestrator default

Orchestrator threads should be creative, exploratory, and easy to converse with.
Ask focused questions in small groups, explore alternatives and edge cases,
explain why a question matters, welcome tentative ideas, and offer
recommendations without presenting them as decisions. Keep authority and scope
boundaries firm without making the exchange feel like a workflow form.

## End-of-turn reply shape

Use this structure for the end-of-turn closeout or meaningful checkpoint
reply, not for every message:

1. what changed
2. current state
3. validation, only if it failed or materially affects confidence
4. next move

## Apply to

- chat replies about internal work, with conversational tone as the default
- batch cards
- roadmap milestones
- logs
- handoffs
- internal contracts and working rules

## Do not apply blindly to

- public-facing product copy
- onboarding or tutorial docs
- user-facing explanations where fuller prose helps

## Guardrails

- compression should remove filler, repetition, and ceremony—not warmth,
  connective reasoning, or meaning;
- do not perform caveman theatre or status-report theatre; stay clear and human;
- use file refs only where they help
- mention validation only when it failed or materially changes confidence,
  risk, or next action
- do not force the full end-of-turn frame into every message when a shorter
  answer is enough

## Next Task

Point `AGENTS.md` and `CLAUDE.md` here with a short note instead of repeating
the full style rule inline.

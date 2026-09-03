# Chatterbox ping: possible queue plugin

Status: open
Owner: operator + Northstar orchestrator
Source: chatterbox intake-channel planning on 2026-09-03

Paseo has no atomic notify-only or send-if-idle API. Spec 035 therefore
keeps automated orchestrator notification out of v1. A future atomic,
non-interrupting queue or conditional send may notify `Orchestrator=true`
after a chatterbox writes a triage note. Until then, the chatterbox reports
the path to the operator and the file is the durable signal.

The operator may later drop a queue plugin that can deliver a small
notification without starting an orchestrator turn. That should add only
the notification transport. Do not rewrite chatterbox authority, git
protocol, or triage lifecycle for it.

Do not start that adapter from this note.

# Chatterbox ping: possible queue plugin

Status: open
Owner: operator + Northstar orchestrator
Source: chatterbox intake-channel planning on 2026-09-03

Paseo has no notify-without-a-new-turn API. Spec 035 therefore uses an
idle-only `send_agent_prompt` to `Orchestrator=true` after a chatterbox
writes a triage note. A running orchestrator is not pinged; the file is
the durable signal.

The operator may later drop a queue plugin that can deliver a small
notification without starting an orchestrator turn. That should replace
only the ping transport. Do not rewrite chatterbox authority, git
protocol, or triage lifecycle for it.

Do not start that adapter from this note.

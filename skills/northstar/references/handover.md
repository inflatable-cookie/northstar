# Handover

A planner (Chatterbox) hands over to a fresh successor when it needs a clean
context, a different skill, or a different model. The successor continues the
same planning. Nothing about the handover is written into the repository.

## Before handing over

- **Land every ruling.** Anything the operator decided in this thread goes into
  its owning knowledge file, or closes its entry in `questions.md`. A ruling
  that exists only in this conversation is lost at handover.
- **Note what's in flight:** Queue tasks this thread submitted or is watching,
  and anything waiting on the operator.

## Steps

1. **Start the successor** in the same workspace, with the same provider and
   model settings and the `Chatterbox=true` label. Tell it which skill to load,
   for example `northstar`.
2. **Brief it in its first prompt.** There is no handoff file. Keep the brief
   short:
   - the current state;
   - what's in flight;
   - what's waiting on the operator;
   - any instruction it must carry on, quoted word for word.

   Everything durable already lives in the repository. The brief only points at
   it.
3. **Move Queue routing** so completion and attention notices reach the
   successor. From the Queue plugin root (`~/Dev/projects/paseo-northstar-queue`),
   with `PASEO_AGENT_ID` set to this thread:

   ```sh
   node bin/northstar-transfer-origin.mjs preflight \
     | node bin/northstar-transfer-origin.mjs transfer <successor-agent-id>
   ```

   The transfer reads the preflight plan on stdin; there is no `--plan` flag.
   Pipe it rather than saving it to a shared file, which another thread could
   overwrite in between. Check that the result names the successor and the
   task set you expect. An empty
   plan is normal when nothing is routed to this thread.
4. **Name the projects it owns.** Queue sends a project's prompts only to its
   owner thread. List the projects this thread owns (`projects` shows each
   owner) in the brief, so the successor can claim them (below).
5. **Tell the successor** `Ownership transfer complete`, as a background
   message.
6. **Yield.** Don't archive or rename this thread; it stays as history. From
   now on the successor owns planning, and this thread doesn't act.

## Claiming projects

Any new Chatterbox, whether a refresh successor, a fresh thread, or one spun off
to take over a project, claims each project it's responsible for as its first
action: `project.claim` with `{"project": "<key>", "note": "Chatterbox refresh
from <old thread>"}` (or a note saying why it owns it), run from the Queue
plugin root with `PASEO_AGENT_ID` set to this thread, which becomes the owner.
A claim always succeeds; a previous live owner gets one notice and its pending
prompts are superseded. Check that the project detail names
this thread as owner. A project nobody has claimed stays dormant and silent.

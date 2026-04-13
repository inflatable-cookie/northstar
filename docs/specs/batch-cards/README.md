# Batch Cards

Use this folder for active Northstar execution cards derived from the current
master spec lane.

## Rules

- create a card only when the next batch is specific enough to execute without
  fresh planning
- keep one live ready card at a time for the active strict lane
- completed cards must not remain advertised as ready
- if there is no ready card, the lane is back in planning

## Current Posture

This folder contains the active card chain for the current `g02` Northstar
lane. The governing roadmap milestone and active master spec decide which card
is actually ready; do not guess from filename order alone.

## Next Task

Use the active roadmap milestone and master spec to identify the next ready
card, and re-enter planning if no ready card is explicitly named.

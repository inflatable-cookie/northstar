---
name: take-stock
description: Audit what a repository or set of repositories holds now, what's stale, and what depends on it, before deciding what to change. Use when the operator has lost track of a project, asks for an audit or "what's there now", or wants to tidy something up.
---

# Take stock

Find out what is true now, from evidence, and hand the operator a short
picture to decide from. Taking stock is read-only: change nothing until the
operator rules.

## 1. Name the scope

State what is being audited (one repository, a folder, a set of repositories
using X) and the question behind it: tidy up, change direction, retire,
publish. The question decides what counts as stale.

## 2. Inventory

Read from the fetched default branch, not a local checkout that may be stale
or mid-task.

- **Surfaces:** what the project ships or exposes: packages, binaries, skills,
  scripts, task-runner selectors, CI, config, docs. One line each on what it
  does.
- **Stated intent:** what the README, vision or agent instructions say the
  project is. Note where it disagrees with the surfaces.
- **In flight:** open PRs, unmerged branches, worktrees, stashes, and the
  project's planning surface. Work in progress isn't stale.
- **Activity:** when each surface last changed, from `git log`.

## 3. Find what's stale

Mark each surface live, stale, dead or unknown, with the evidence:

- docs or instructions that claim something no longer true;
- references to removed or renamed things;
- code, scripts or selectors with no callers;
- dependencies nothing imports;
- PRs and branches nobody will finish;
- installed or vendored copies that have drifted from their source.

Unknown is a valid answer. Don't guess a surface dead because it's quiet.

## 4. Find the dependents

For each surface worth changing, find who relies on it: other repositories
(search sibling checkouts and the code host), installed copies, CI in other
projects, agent instructions that name it, published consumers. A dependent
you miss breaks later.

## 5. Report

Keep it short enough to decide from:

- what the project is now, in a paragraph;
- a table of surface, state, evidence and dependents;
- where stated intent and reality disagree;
- recommendations ranked by value, each with its blast radius;
- the questions only the operator can answer.

Then stop. Follow-up work belongs to the skill that fits it: `repo-sweep`
for a change across repositories, `hill-climb` for quality, `atlas` for
direction.

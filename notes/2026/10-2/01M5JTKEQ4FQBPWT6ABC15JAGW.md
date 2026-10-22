---
id: 01M5JTKEQ4FQBPWT6ABC15JAGW
created: 2026-10-22T22:09:44.676022Z
updated: 2026-10-22T22:09:44.676022Z
type: task
title: Recertification starts from last year — a new DDQ from the same requester carries forward the answers given last time to check, and flags the questions that are new or reworded
task_status: todo
assignee: steve
label: feature
priority: medium
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1264
---
Sprint 84, DDQ-1 (ADR in COM-1245).

**Chain:** on the chain — API

## What people see

- On a new DDQ, once its questions exist: **Carry forward from a previous DDQ**. Compass offers the requester's earlier sent DDQs (matched by organisation and contact domain), newest first. **Start the next one from this** on a sent DDQ is a shortcut to the same thing.
- Each new question is matched to last time's: **same** (carried forward as a draft, marked "from DDQ-3 — check it's still true"), **reworded** (carried forward, marked, with both wordings shown), or **new** (left unanswered).
- If the library has a newer approved version of what was said last time, that version is used and marked.

Carried-forward answers still go through review and approval; nothing is approved automatically.

**Done when:** this year's version of a sample questionnaire, with two new and three reworded questions, starts with everything else drafted from last year's.
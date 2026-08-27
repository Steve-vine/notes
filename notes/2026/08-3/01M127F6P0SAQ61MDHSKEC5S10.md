---
id: 01M127F6P0SAQ61MDHSKEC5S10
created: 2026-08-27T18:24:44.224781Z
updated: 2026-08-27T18:24:44.224781Z
type: task
title: An engagement says how far in the vendor can reach, and the register can filter on it
label: feature
priority: medium
assignee: steve
task_status: backlog
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 471
company: null
---
ADR 0060 §1. `vendor_engagements.access_level` — nullable, single-valued, the highest true rung (the ladder is nested, so one value is the whole answer).

`access_requirements` **keeps its place** beside it as the note that says what the access is for and how it is constrained. Nothing is discarded and nothing is machine-guessed from it — existing engagements start with no rung, deliberately.

Surfaces: engagement create / amend / approval-request forms, the engagement card, the engagement's revisions, and a register filter — including "access not yet classified", which is the visible backlog this creates.
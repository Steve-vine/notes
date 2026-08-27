---
id: 01M127FWQP0A4Y4Z6T8EZYMT4G
created: 2026-08-27T18:25:06.806411Z
updated: 2026-08-27T18:25:06.806411Z
type: task
title: A tier that rises asks for a review
label: feature
priority: medium
assignee: steve
task_status: backlog
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 475
company: null
---
ADR 0060 §6. When an engagement's effective tier goes up, the vendor's review becomes due and the work lands in Actions. Per ADR 0055 this is a **declared action source**, not a bespoke `notify()`.

Assessments already on file are not invalidated, reopened or rewritten — they were answered truthfully against the questionnaire sent at the time, and ADR 0032's snapshot ethos already keeps them readable. What changes is that we are asked to look again.

A falling tier raises nothing.
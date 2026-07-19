---
id: 01KXX7HBG3ZT3QD8EK1Y34FGH2
created: 2026-07-19T13:02:37.059030371Z
updated: 2026-07-19T13:23:22.23801312Z
type: task
title: Update — learn from a resolved incident
label:
- feature
assignee: steve
priority: high
task_status: backlog
project: 01KX671DATY39VW6GWK3M2T3DN
number: 136
tech: null
sprint: sdv8hgy
blocked_by:
- 01KXX7GWGYRFEK4HZ9FDGHVVHA
- 01KXX7H0RX5T3F7GGKV5B12PYN
---
**Sprint 13 (vertical slice: backend + UI).** The back bookend — turn a resolved incident into memory the next one recalls.

- **Backend**: **diagnostic-signature** computation (after Investigate, from the cause found) + write-back of the incident instance to memory (including **failed attempts** and newly-discovered structure/context), and an AI-proposed **playbook distillation**.
- **UI**: at resolution, an AI-proposed **"what I learned"** bubble in the incident timeline — the proposed playbook / memory note — that the human **confirms or edits before it is written**. Never automatic (AI-proposes / human-confirms, ADR 0025 posture).

**DoD**: resolving an incident produces the confirm-what-was-learned step; confirming writes it to memory/playbooks and it then shows on the next matching incident's Recall. Not done until the confirm step renders and a confirmed lesson round-trips into Recall.

Depends on Recall + Playbooks.
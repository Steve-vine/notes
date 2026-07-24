---
id: 01KYAT4G7VAYB40WZ9KXEA8D82
created: 2026-07-24T19:37:46.491095Z
updated: 2026-07-24T19:38:17.080228Z
type: task
title: Catalogue and review the artificial limitations on AI surfaces
project: 01KX671DATY39VW6GWK3M2T3DN
number: 265
sprint: svgrad3
assignee: steve
label:
- brief
priority: medium
task_status: backlog
---
Motivating case (2026-07-24): an operator asked issue-chat to check DataDog directly; it replied that it is limited to what ISE already holds. The connector Evidence capability (on-demand DataDog metrics/logs, ADR 0031) exists — but is wired to the investigation task types, not the chat surfaces, and chat runs behind the ADR 0023 read-only-DB boundary.

Working from the ISE-263 map, produce a catalogue of every imposed limitation and a verdict on each:

- **Deliberate and still right** (e.g. default-deny actions, ADR 0017) — keep, document.
- **Deliberate but outgrown** — e.g. chat without connector evidence tools made sense when chat was a cheap Q&A surface over the DB; now that operators investigate *in* chat, "check DataDog" is a reasonable ask. Evidence tools are read-only, so extending them to chat arguably doesn't breach ADR 0023's intent (no writes) — but that's an ADR amendment to argue, not assume. Same review for: chat history-turns window, per-surface tool subsets, spend shares.
- **Accidental** — limitations nobody chose (tool wiring gaps, context omissions found by the map).

Each "outgrown" verdict becomes a proposal: what to relax, what it costs (the caps exist partly for spend control — link to the Sprint 23 visibility work), and which ADR it amends. Expect at least one ADR (chat evidence access). Record decisions in the ISE Canon as made.

Depends on ISE-263 (the map).
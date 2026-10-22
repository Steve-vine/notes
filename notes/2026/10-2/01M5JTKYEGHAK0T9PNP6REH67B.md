---
id: 01M5JTKYEGHAK0T9PNP6REH67B
created: 2026-10-22T22:10:00.784431Z
updated: 2026-10-22T22:10:25.52748Z
type: task
title: The assistant works a DDQ — reads the questionnaire, sets up the questions, finds what Compass holds for each, drafts answers with their sources and evidence, assigns what it can't answer, and offers new answers to the library — but never releases anything held back
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1266
sprint: s5uw2fz
assignee: steve
label:
- feature
priority: high
task_status: todo
---
Sprint 84, DDQ-1 (ADR in COM-1245). ADR 0109 pattern: as the person, the same as on screen.

**Chain:** independent (built last, once the screens it mirrors exist)

## What the person does

"Here's Acme's questionnaire, it's DDQ-7 — work through it." The assistant:
1. **Reads the questionnaire:** the spreadsheet's sheets as a grid (so it can see which columns are which), the pasted email, or, for an online DDQ, the client's pages in the person's browser after they've signed in.
2. **Sets up the questions:** chooses sheets and columns for a spreadsheet, or splits the email into questions, or adds them one by one from the online system, with sections and references.
3. **For each question, asks Compass what it holds:** library suggestions first, then policies and standards, controls, evidence and trust centre documents. Each comes back with its classification and **whether it can be given on this DDQ**, so the assistant knows before drafting that something will be held back.
4. **Drafts the answer**, with its short response, sources, evidence and classification, marked as drafted through the assistant.
5. **Assigns** questions it can't answer to the person's chosen colleague, with a note.
6. Reports back: answered, assigned, held back and why, and what's left.
7. Once approved: **offers new answers to the library**, and for an online DDQ types the approved answers into the client's system for the person to check and submit.

It can also read and maintain the library (search, draft, edit) and approve, if the person holds *Approve DDQ answers*. It **cannot release held-back information** (COM-1245 call 13), and the API refuses.

## Notes (technical)

- Tools in a ddq module, auto-discovered; lookups in ddq_common like the other modules. Read tools: list/get DDQ, read questionnaire (grid with cell refs / email text), list questions, search answer sources (library + content + controls + evidence + trust centre docs, each with `may_share`), library search/get. Write tools mirror the screens: set up questions, add question, save answer, assign, submit for review, approve/send back, add to library, library entry CRUD.
- Every write carries the via-assistant mark (ADR 0109).

**Done when:** from a sample spreadsheet, a person's assistant sets up DDQ-1, drafts most answers from Compass with sources, assigns two questions, and reports one Sensitive policy held back for want of an NDA.
---
id: 01M5JTKEQ4FQBPWT6ABC15JAGW
created: 2026-10-22T22:09:44.676022Z
updated: 2026-10-23T16:23:12.983895Z
type: task
title: Recertification starts from last year — a new DDQ from the same requester carries forward the answers given last time to check, and flags the questions that are new or reworded
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1264
sprint: s5uw2fz
blocked_by:
- 01M5JTK8ZHJDB0J15T2KCNYG1H
comments:
- id: 01M5MS5MEKF5M69JVZXWM8DHQ7
  author: Steve Vine
  at: 2026-10-23T16:23:12.083207Z
  text: |-
    Done — merged in #1283 (migration 0680_ddq_carry_forward).

    - On a DDQ that's still being answered and has its questions, the Questions card has **Carry forward from a previous DDQ**. It lists the requester's earlier **sent** DDQs, newest first — same organisation name (capitals and spacing don't matter) or a contact at the same email domain (Gmail-style addresses: the same address only). A DDQ made with **Start the next one from this** has that one preselected.
    - A preview first: "5 the same · 3 reworded · 2 new", how many answers will be drafted, each question beside last time's.
    - Same and reworded questions get a draft of what was **sent** last time, marked "Carried forward from DDQ-3 — check it's still true"; reworded ones also show "Reworded — last time: …". If the library now has a newer approved version, that's used and marked "Updated from the library since DDQ-3 (version 2)".
    - New questions stay unanswered, marked "New this time". A source or file no longer held is left off, with a note.
    - Only unanswered questions are filled; nothing is approved; one History line for the whole thing. A **Last time** filter on the Questions card.

    My calls:
    - Matching uses the same text-similarity as library suggestions, with a boost when the question's reference is unchanged — enough to tell "encrypted when stored" from "encrypted in transit".
    - Only answers that were approved when sent are carried; a question marked Not answered last time is matched but left undrafted.
    - A carried answer stays recorded as "carried forward" even after it's edited.
assignee: steve
label:
- feature
priority: medium
task_status: review
---
Sprint 84, DDQ-1 (ADR in COM-1245).

**Chain:** on the chain — API

## What people see

- On a new DDQ, once its questions exist: **Carry forward from a previous DDQ**. Compass offers the requester's earlier sent DDQs (matched by organisation and contact domain), newest first. **Start the next one from this** on a sent DDQ is a shortcut to the same thing.
- Each new question is matched to last time's: **same** (carried forward as a draft, marked "from DDQ-3 — check it's still true"), **reworded** (carried forward, marked, with both wordings shown), or **new** (left unanswered).
- If the library has a newer approved version of what was said last time, that version is used and marked.

Carried-forward answers still go through review and approval; nothing is approved automatically.

**Done when:** this year's version of a sample questionnaire, with two new and three reworded questions, starts with everything else drafted from last year's.
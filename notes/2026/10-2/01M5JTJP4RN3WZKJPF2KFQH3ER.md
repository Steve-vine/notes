---
id: 01M5JTJP4RN3WZKJPF2KFQH3ER
created: 2026-10-22T22:09:19.512646Z
updated: 2026-10-23T18:06:19.762666Z
type: task
title: Approved answers feed the library — a new or improved answer is offered as a library draft for approval, so the next DDQ gets it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1260
sprint: s5uw2fz
blocked_by:
- 01M5JTJGF62N26YGD7VND0B8RS
comments:
- id: 01M5MG9WAK68E0G2KKPKH9N7X0
  author: Steve Vine
  at: 2026-10-23T13:48:14.035433Z
  text: |-
    Done — merged in #1277 (6761c579, migration 0665_ddq_answer_to_library).

    - Under an approved DDQ answer that didn't come from the library unchanged, approvers see **Add to library**: **Update "<entry>"** (a new version of the entry it came from) or **New entry** (the client's question, rewordable — if reworded, the client's wording is kept as another wording). Response, sources, evidence and classification are copied. It lands **Awaiting approval** and isn't suggested until approved there.
    - The Review card has **Add all new answers to the library (n)** — updates the entry an answer came from where it can, otherwise a new entry, and says what it left out and why.
    - Never offered: an answer released by an Admin, one used from the library unchanged, or one already added.
    - The answer then reads "Added to the library by …: '…' (version 1, awaiting approval)" with a link. A library entry's **Used in** lists each DDQ ("DDQ-7 · Northwind Legal"); the register's **Last used** is filled.

    My calls:
    - Only approvers can add (Approve DDQ answers); allowed whatever the DDQ's status, including sent.
    - An entry already being worked on (a draft or awaiting approval) or retired can't take an update — shown disabled with the reason; a draft is never overwritten.
    - An answer with only "Yes"/"No" and no detail gets that word as its library answer text.
    - A new entry's owner is the approver who added it.
    - On an assignee's page, "From the library" shows as plain text (they can't open the library).
assignee: steve
label:
- feature
priority: high
task_status: done
---
Sprint 84, DDQ-1 (ADR in COM-1245).

**Chain:** on the chain — API

## What people see

When a DDQ answer is approved and it **didn't come from the library unchanged**, the approver sees **Add to library**:
- **New entry:** the question becomes the entry's question, with the client's wording kept as another wording.
- **Update "<existing entry>"** (when it came from one and was changed): a new version of that entry.

Either way it lands as **Awaiting approval** in the library. That's a second, deliberate approval, because a library answer will be reused (Steve: approval first). On a DDQ, **Add all new answers to the library** does it in bulk.

An answer released by an Admin is never offered to the library (its release covers that DDQ only).

The library entry's **Used in** lists this DDQ, and the DDQ's question links to the entry.

**Done when:** an answer from an assigned colleague is approved, offered to the library, approved there, and suggested on the next DDQ.
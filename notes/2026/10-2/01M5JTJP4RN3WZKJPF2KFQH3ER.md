---
id: 01M5JTJP4RN3WZKJPF2KFQH3ER
created: 2026-10-22T22:09:19.512646Z
updated: 2026-10-22T22:10:46.650384Z
type: task
title: Approved answers feed the library — a new or improved answer is offered as a library draft for approval, so the next DDQ gets it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1260
sprint: s5uw2fz
blocked_by:
- 01M5JTJGF62N26YGD7VND0B8RS
assignee: steve
label:
- feature
priority: high
task_status: todo
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
---
id: 01M62B8VJRJE51B73NWN3JR83T
created: 2026-10-28T22:49:39.672634Z
updated: 2026-10-29T21:14:39.590313Z
type: task
title: Deciding and approving — each flag accepted, edited or dismissed with a reason, "never" positions escalated, the review approved by someone other than its owner, and a decided clause added to the Positions library
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1441
sprint: s2v7d6y
blocked_by:
- 01M62B8EJP5EPEVMQB0KV8E1Z8
assignee: steve
label:
- feature
priority: high
task_status: active
---
Sprint 98, Contract Review (ADR 0134, COM-1435).

## What people see

- **On each flag**, the clause's assignee chooses:
  - **Accept**: the suggested response stands;
  - **Edit**: change the client-facing comment or the suggested wording;
  - **Dismiss**, with a reason ("Covered by schedule 3", "Agreed on the call").
  - A **Matches** flag needs no decision. Every other flag must be decided before the review can be approved.
- **We'll agree to it anyway:** for a "Conflicts with what we do" flag, accepting the client's wording means promising something we don't do today. It asks for a reason and **marks the clause as a commitment** (COM-1443), so it becomes work to do rather than a silent risk.
- **Escalation:** a flag in a topic's **never** position, or accepted anyway against what we do, needs **an approver's agreement** on that clause. It shows "Needs sign-off" and goes to people with *Approve contracts* in Actions.
- **Submit for approval:** when every clause is decided, the owner submits. The review shows a summary: counts by flag, and every escalation with its reason.
- **Approve** (*Approve contracts*, not the owner and not anyone who decided an escalated clause) or **Send back** with a note, which returns the review to In review and the named clauses to their assignees.
- **Add to Positions:** on a decided clause, someone with *Manage positions* can **add it to the library**, either as a new fallback wording on the topic's position or as a new position, landing **Awaiting approval** (COM-1437). The library learns from what was negotiated.

## Who can do what

- The clause's assignee decides its flags.
- *Approve contracts* gives escalation sign-off and review approval, never on their own work.
- *Manage positions* adds clauses to the library.

## Notes (technical)

- Tables: `contract_clause_decisions(clause_id, flag_id, decision, comment, wording, reason, decided_by, escalated, signed_off_by)`, revisioned. The review's status transitions live in one place, `core/contracts/status.py`.
- "Add to library" reuses `ddq_library.add_to_library`'s shape (offer rules: decided, not unchanged from the library, added once per version).
- An Actions source for sign-off and approval queues.

**Chain:** on the chain (migration + API).

**Done when:** on staging, Steve decides every flag on a test review, accepts one conflict anyway (it's escalated and signed off by a second person), gets the review approved by a third, and adds one negotiated clause to Positions.
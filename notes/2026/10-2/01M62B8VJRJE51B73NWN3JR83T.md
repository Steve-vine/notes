---
id: 01M62B8VJRJE51B73NWN3JR83T
created: 2026-10-28T22:49:39.672634Z
updated: 2026-10-30T08:16:01.356542Z
type: task
title: Deciding and approving — each flag accepted, edited or dismissed with a reason, "never" positions escalated, the review approved by someone other than its owner, and a decided clause added to the Positions library
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1441
sprint: s2v7d6y
blocked_by:
- 01M62B8EJP5EPEVMQB0KV8E1Z8
comments:
- id: 01M64WETGNEMQHHKFGY1QK6D5N
  author: Steve Vine
  at: 2026-10-29T22:28:29.845251Z
  text: |-
    Done — PR #1459 merged (5d17589f), migration 0745.

    What's there:
    - **On each flag**, whoever the clause is with chooses one of these (a clause still with Polaris is decided by the owner or Review contracts):
      - **Accept:** the suggested response stands;
      - **Edit:** change the comment or wording; the part you don't change keeps the suggestion;
      - **Dismiss**, with a reason;
      - **We'll agree to it anyway**, with a reason. This is offered on conflicts, new commitments and outside-position flags.
      - Matches needs no decision.
    - **Commitments:** agreeing to a conflict, or accepting a new commitment, marks the clause a commitment (it shows "Commitment" in the list).
    - **Escalation:** dismissing or agreeing to a conflict or an outside-position flag shows "Needs sign-off". It goes to approvers in Actions and is signed off by an approver who didn't decide it.
    - **Submit for approval (owner):** only once every flag is decided; until then it shows how many are left. The review becomes "Awaiting approval" and its clauses are fixed. The Summary card shows counts by flag, every escalation with its reason and sign-off, and the commitments we'd take on.
    - **Approve:** needs Approve contracts, and can't be the owner or anyone who decided an escalated clause. Every escalation must be signed off first, and the button says why when you can't. **Send back** needs a note and can reopen named clauses with their assignees.
    - **Add to Positions:** on a decided clause (Manage positions), it adds a new position, or a new fallback on the topic's position, Awaiting approval. It's offered once per clause, and not when the library already says the same.
    - **Polaris** can't decide, sign off, submit or approve.

    My calls:
    - **Agreeing to a client's wording that falls outside our positions escalates too**, not only a "never" position. The fallback is defined as what we accept without escalation.
    - **A new status, "Awaiting approval"**, sits between In review and Approved.

    To test on staging: decide every flag on a test review, agree to one conflict anyway, have a second person sign it off and a third approve, then add one negotiated clause to Positions.
- id: 01M658JD5ZY3TQWHZTPP3RZVR5
  author: Steve Vine
  at: 2026-10-30T02:00:10.175301Z
  text: |-
    Pre-UAT pass (Claude, staging): **Couldn't check**.

    Every flag comes from Polaris. With nothing flagged, the owner gets no Submit for approval, and the server refuses a submit ("nothing is flagged yet"). So deciding, escalating and approving can't be reached without the AI provider.

    For Steve: after Review with Polaris on CR-1 (see COM-1439), decide the flags as E2E Admin A and approve as E2E Admin B.

    Screenshot: ~/compass-uat/sprint-98/COM-1441/.
assignee: steve
label:
- feature
priority: high
task_status: done
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
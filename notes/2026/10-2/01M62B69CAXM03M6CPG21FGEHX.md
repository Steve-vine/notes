---
id: 01M62B69CAXM03M6CPG21FGEHX
created: 2026-10-28T22:48:15.498441Z
updated: 2026-10-28T22:50:28.105639Z
type: task
title: 'ADR: contract review — Polaris reads a client''s contract against what we actually do, our standard contract and our approved positions; reviewers work it together with assignments, comments and @mentions; once signed, what we agreed becomes tracked commitments'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1435
sprint: s2v7d6y
assignee: steve
label:
- brief
priority: high
task_status: todo
---
Sprint 98, Contract Review (ADR 0134). Builds on:
- ADR 0124/0125/0127 (DDQs: Polaris reads a client's document, answers from Compass, and keeps a Q&A library that learns from approved answers);
- ADR 0116 (incident notification rules);
- ADR 0115 (SAP);
- ADR 0122 (the Evidence register);
- ADR 0055 (Actions);
- ADR 0109 (Polaris works as the person).

Write `decisions/0134-contract-review.md`, and add Modules ▸ Contracts to `brief/information-architecture.md`.

## Steve's asks (2026-10-28)

- Upload a client contract; Polaris highlights where it doesn't match what we actually do, including our controls and our standard client contract.
- An **acceptable positions** list, like the DDQ Q&A library (Steve: "Yes").
- **Once signed, track what we agreed** (Steve: "Yes").
- Several people collaborate on one contract: a **reviewers list** (like owners) and **internal comments with @mentions** ("@mark, can you review this section").

## What the ADR decides

1. **A Contracts module**, per company: **Reviews**, **Positions**, **Commitments**, **Clients**, and Settings (the standard contract).
2. **Clients** are a short list per company: name and other names it goes by. A review, a commitment and (later) a DDQ name a client. A client is created when its first contract is started.
3. **The standard contract**: one or more per company (MSA, DPA, SLA schedule), uploaded as Word, versioned. Every review records which version it was compared against.
4. **Positions** are the library. Each is a topic (liability cap, breach notification, audit rights, data location, subprocessors, security standards, insurance, termination, governing law, and so on) with:
   - our **preferred** position;
   - what's **acceptable** as a fallback;
   - what we **never** accept;
   - suggested wording, and the standard contract clause.

   Draft → Awaiting approval → Approved, versioned, and nobody approves their own, exactly as the DDQ library. **A decided review clause can be added to the library**, so it learns.
5. **A review** is one client contract (Word or PDF; a revised version from the client is a new version of the same review). Polaris splits it into clauses, tags each with a topic, and **flags** each one:
   - **Conflicts with what we do**: against controls and their assessments, policies and standards, incident notification rules, recovery targets, data locations, subprocessors, SAP activities, certificates and check results;
   - **Outside our positions**;
   - **Within our fallback**;
   - **Differs from our standard contract**;
   - **New commitment**: something we'd agree to that nothing in Compass tracks;
   - **Matches**.

   Each flag quotes the clause, cites the Compass record it's judged against (linked), and suggests a response or redline. When Polaris can't tell, it says so and gives the clause to a person.
6. **Reviewers**: a review has an owner and a reviewers list. Clauses or whole sections are **assigned**, to Polaris or a person, with a due date, the way DDQ questions are. **Internal comments** on any clause, with **@mentions** that reach the person through Actions and email. Comments never leave Compass.
7. **Deciding**: every flag is accepted, edited or dismissed with a reason. A review is **approved** by someone with *Approve contracts* who isn't its owner. Then it **goes back to the client as Word** with Compass's client-facing responses as comments in the margin (internal comments never), plus a summary PDF.
8. **Signed**: record the signed date, term, renewal or notice date and the signed copy (to the Evidence register, restricted). Every accepted obligation becomes a **commitment**: client, clause, what we promised, owner. Where Compass can enforce it, the commitment **takes effect**:
   - a breach-notice clause becomes an incident notification rule that applies when that client is affected;
   - "annual pen test report to the client" becomes a SAP activity;
   - the renewal becomes an Actions reminder.

   The rest is tracked with its owner and review date.

## Who can do what

| Permission (new) | Allows |
|---|---|
| View contracts | See reviews, positions, commitments and clients |
| Review contracts | Start reviews, work assigned clauses, comment, decide flags |
| Manage positions | Draft and edit positions, add decided clauses to the library |
| Approve contracts | Approve a review (not their own) and approve positions (not their own) |

Named reviewers and assignees can see and work **their** review without *View contracts*, as DDQ assignees can. Built-in Admin gets all four; the starter roles stay frozen.

## My calls (for Steve to overturn)

- Clients are a light list inside Contracts, not a CRM. DDQs can link to them later.
- @mentions can name anyone active in Compass. Mentioning someone who isn't a reviewer **adds them as a reviewer**, after a confirmation ("Add Mark as a reviewer?"), so they can open it.
- The position topics are seeded as a starter list of 14 with no positions filled in. Polaris can draft positions from the standard contract for a person to approve.
- Word comments only, no tracked-change redlines in this sprint. The suggested wording is in each comment.
- Signed contracts are restricted evidence: only *View contracts* and the review's reviewers see them in the register.
- A commitment that would change an incident rule or the plan is **proposed** and confirmed by a person. Polaris never puts one into effect by itself.

## Notes (technical)

- Reuse the DDQ machinery where it fits:
  - layout reading (`core/ddq_layout.py`, ADR 0125) for splitting a document into clauses;
  - `core/ddq_assignments.py` as the pattern for assignments (Polaris is always an assignee);
  - `core/ddq_library.py` / `qa_library` for the positions library's approval and versions;
  - `core/ddq_word.py` for Word output. Comments need python-docx ≥ 1.2 (`add_comment`), so bump the floor.
- @mentions are new in Compass. Build them once as a shared comment component and core helper (parse, resolve, Actions source), so other modules can adopt them.
- Contract text is client confidential and is data, never instructions (as with DDQs). Polaris sends it only to the organisation's configured provider (ADR 0127).

**Chain:** independent (docs only).

**Done when:** ADR 0134 is merged and Steve has read the calls above.
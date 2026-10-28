---
id: 01M62B7CAZYNSEQBTTAMMN829S
created: 2026-10-28T22:48:51.295125Z
updated: 2026-10-28T22:50:43.910583Z
type: task
title: Start a contract review — upload the client's contract (Word or PDF), name the client and what kind of contract it is, and Polaris splits it into sections and clauses, each tagged with its topic
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1438
sprint: s2v7d6y
blocked_by:
- 01M62B706A3TQXW6KT1DJNCQYS
assignee: steve
label:
- feature
priority: high
task_status: todo
---
Sprint 98, Contract Review (ADR 0134, COM-1435).

## What people see

- **Contracts ▸ Reviews:** a table with reference (CR-7), client, contract, kind, owner, status, due date, flag counts ("3 conflicts · 5 outside positions"), last activity. Filters by status, client and owner. The table is sortable.
- **New review:**
  - **client** (pick, or add a new one);
  - **title** (e.g. "ACME MSA 2027");
  - **kind** (MSA, DPA, Service schedule, NDA, Order form, Other);
  - **compare against**: the standard contract(s) to use, defaulting by kind (an MSA compares with our MSA, and so on);
  - owner (defaults to the person starting it) and due date;
  - the file: Word or PDF. Scanned PDFs are refused with "This PDF has no text. Ask the client for Word or a text PDF".
- **Reading the contract:** Polaris splits it into **sections and clauses**, keeping the contract's own numbering (12.2(a)), and tags each clause with its **topic** from the Positions topics. Clauses with no topic are tagged "General".
- **The review page:**
  - the contract on the left as clauses, each with its number, text, topic chip and flag (COM-1439);
  - the clause's panel on the right (flags, decision, comments, assignment).
  - A person can **change a clause's topic**, **merge** two clauses or **split** one if Polaris cut it wrongly.
- **Status:** Draft → In review → Approved → Sent → Signed (COM-1443), or **Abandoned** with a reason.
- **Restricted:** a review is seen only by *View contracts* holders and the review's reviewers and assignees (COM-1440).

## Who can do what

- *Review contracts* starts a review and adjusts its clauses.
- *View contracts* reads.

## Notes (technical)

- Tables: `contract_reviews` (company-scoped, numbered by sequence, CR-n), `contract_review_versions(review_id, n, attachment_id, received_on)`, `contract_clauses(version_id, number, heading, text, topic_id, order)`.
- Splitting: use Word numbering and headings where present. Use the ADR 0125 layout reader (`core/ddq_layout.py`) for PDFs and messy Word files.
- The file goes into the attachment store (ADR 0074). The review is **not** listed in the Evidence register until it's signed.
- Contract text is data, never instructions (as `ddq_text`).

**Chain:** on the chain (migration + API).

**Done when:** on staging, Steve uploads a real client MSA (Word) and a PDF DPA. Each is split with the contract's own numbering and sensible topics, and he fixes one wrongly split clause.
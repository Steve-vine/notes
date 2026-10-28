---
id: 01M62B706A3TQXW6KT1DJNCQYS
created: 2026-10-28T22:48:38.85811Z
updated: 2026-10-28T22:50:42.859002Z
type: task
title: 'Positions — the library of what we''ll accept in a client contract: per topic, our preferred position, the fallback we''ll accept and what we never accept, with wording and our standard clause; drafted, approved and versioned like the DDQ Q&A library'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1437
sprint: s2v7d6y
blocked_by:
- 01M62B6KP8HDK2EYY7JM4210M4
assignee: steve
label:
- feature
priority: high
task_status: todo
---
Sprint 98, Contract Review (ADR 0134, COM-1435).

## What people see

- **Contracts ▸ Positions:** a table with topic, preferred, fallback, never, status (Draft / Awaiting approval / Approved), last used, and the Compass facts it rests on. Search and a filter by status. The table is sortable.
- **Topics** are seeded as a starter list:
  - limitation of liability, indemnities, data protection and processing, breach notification;
  - security standards and certifications, audit and inspection rights, subprocessors, data location and transfers;
  - business continuity and recovery, insurance, confidentiality, termination and exit, service levels, governing law.

  Admins can add, rename and retire topics.
- **A position** has:
  - **preferred** (what we offer);
  - **acceptable fallback** (what we'll agree to without escalation);
  - **never** (what needs a director's sign-off, or is refused);
  - **suggested wording** for each;
  - the **standard contract clause** it matches (e.g. MSA v3 §12.2);
  - optional **Compass facts** it rests on, picked from: a control, a policy or standard, an incident notification rule, a recovery target, a certificate. For example, "Breach notification — we can do 48 hours" rests on the incident rule and the incident policy.
- **Draft with Polaris:** from the standard contract, Polaris drafts a position per topic it finds (preferred = what the standard says). Each lands as Draft for a person to complete.
- **Submit → Approve:** Awaiting approval → Approved by someone with *Approve contracts* who didn't write it. Editing an approved position makes a new version that needs approval again. Earlier versions stay readable, with the reviews that used them.
- **Used in:** each position lists the reviews whose clauses were judged against it.

## Who can do what

- *Manage positions* drafts and edits.
- *Approve contracts* approves, but not their own.
- *View contracts* reads.

## Notes (technical)

- Model it on `core/ddq_library.py` and `qa_library`: versions, submit and approve, "approved before reusable", "used in". Share code where the shapes match; don't fork it.
- Tables: `contract_topics` (organisation-wide rubric, retire not delete), `contract_positions(company_id, topic_id)`, `contract_position_versions(…, preferred, fallback, never, wording JSONB, standard_clause_ref, status, approved_by)`, `contract_position_facts(version_id, kind, target_id)`.
- Positions are per company, because companies can have different standard contracts.

**Chain:** on the chain (migration + API).

**Done when:** on staging, Steve has Polaris draft positions from the MSA, completes "Limitation of liability", and a second person approves it.
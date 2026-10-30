---
id: 01M62B706A3TQXW6KT1DJNCQYS
created: 2026-10-28T22:48:38.85811Z
updated: 2026-10-30T08:16:01.304499Z
type: task
title: 'Positions — the library of what we''ll accept in a client contract: per topic, our preferred position, the fallback we''ll accept and what we never accept, with wording and our standard clause; drafted, approved and versioned like the DDQ Q&A library'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1437
sprint: s2v7d6y
blocked_by:
- 01M62B6KP8HDK2EYY7JM4210M4
comments:
- id: 01M64RZZ36QFEJ6FA5SC57QJQ4
  author: Steve Vine
  at: 2026-10-29T21:27:57.285934Z
  text: |-
    Done — PR #1455 merged (eb5cbf5b), migration 0741.

    What's there:
    - **The Positions tab:** a sortable table showing topic, preferred / fallback / never, status, last used and what each rests on. It has search and a status filter. "Add position" picks from topics that have no position yet.
    - **A position's page:**
      - the version in use and the one being worked;
      - edit preferred, fallback and never, with suggested wording for each;
      - the standard contract clause it matches (pick contract → version → clause);
      - the Compass records it rests on: a control, policy/standard, incident rule, recovery target or certificate;
      - Submit, Approve or Send back (a reason is required), and Discard;
      - every earlier version, readable, and "Used in" (filled once reviews are flagged).
    - **"Nobody approves their own":** everyone who wrote or edited a version is recorded on it, and none of them can approve it, even with Approve contracts. The button says why. Editing an approved position starts a new version; the approved one stays in use until the new one is approved.
    - **Draft with Polaris:** pick a standard contract and Polaris's window opens with the request in its prompt box. It doesn't send by itself. Polaris drafts one position per topic it finds (preferred = what the standard says, with its clause number), each as a Draft. Polaris has no tool to approve.
    - **Admin ▸ Rubrics ▸ Contract topics:** add, rename and change the tagging words, retire and restore. The 14 starter topics are seeded once, so retiring one sticks.

    My calls:
    - **No shared code with the DDQ library:** positions follow its rules but don't share its code, because that library lets the drafter approve their own entry.
    - **What the table shows:** the approved wording where there is one, otherwise the draft's.

    To test on staging: run Draft with Polaris from the MSA, complete "Limitation of liability" and submit it, then have a second person approve it.
- id: 01M658J18NFVC8DRBS23773NAH
  author: Steve Vine
  at: 2026-10-30T01:59:57.973129Z
  text: |-
    Pre-UAT pass (Claude, staging, E2E Test Company): **Passed** for writing and approving a position; **Couldn't check** "Draft with Polaris" (needs the AI provider).

    - "Limitation of liability" was completed by E2E Admin A: preferred, fallback, never, wording, standard clause (MSA v1 11.1) and the incident rule it rests on.
    - Admin A's Approve is disabled: "You wrote this version — someone else must approve it".
    - E2E Admin B approved it; it shows Approved, in use as version 1.
    - Worth a manual look: choosing the Version option by mouse didn't take in a headless browser, but the keyboard did.

    Screenshots: ~/compass-uat/sprint-98/COM-1437/.
assignee: steve
label:
- feature
priority: high
task_status: done
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
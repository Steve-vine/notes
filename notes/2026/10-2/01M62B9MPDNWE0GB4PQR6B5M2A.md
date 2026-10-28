---
id: 01M62B9MPDNWE0GB4PQR6B5M2A
created: 2026-10-28T22:50:05.389603Z
updated: 2026-10-28T22:50:05.389603Z
type: task
title: Signed — record the signed contract, its term and renewal date; every obligation we accepted becomes a commitment in Contracts ▸ Commitments, with an owner, how it's met and when it's next checked
priority: high
assignee: steve
label: feature
task_status: todo
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1443
---
Sprint 98, Contract Review (ADR 0134, COM-1435).

## What people see

- **Mark as signed** on a Sent review:
  - signed date;
  - the **signed copy** (required);
  - term start and end, **renewal or notice date**, and auto-renews yes/no.
  - The signed copy goes into **Audit ▸ Evidence** as restricted (type "Log or record"): only *View contracts* holders and the review's reviewers see it there.
  - If the signed text differs from the last approved version, Compass compares them and lists the differences. Each must be acknowledged before signing completes, so last-minute changes are seen.
- **Commitments** are proposed from the signed version. Every clause whose decision accepted an obligation (a "New commitment" flag, a conflict accepted anyway, a fallback that commits to something specific) becomes a draft commitment. The owner confirms or drops each one, with a reason. A commitment has:
  - the client, the clause (linked), and **what we promised**, in a sentence ("Notify ACME of a personal data breach within 24 hours");
  - a **kind**: notification, reporting, testing, certification, data location, service level, insurance, other;
  - an **owner**;
  - **how it's met**: a link to the Compass record that delivers it (COM-1444 makes some automatically) or "Tracked here";
  - a **check** cadence (yearly by default) with a next-check date.
- **Contracts ▸ Commitments:**
  - a table with client, commitment, kind, owner, how met, next check, status (Met / At risk / Not met / Ended). Filters by client, kind and status. The table is sortable;
  - **Check** records "still met" or "not met" with a note and optional evidence;
  - **Not met** offers to raise a gap on a linked control or a risk.
- **Actions:**
  - commitment checks due, to the commitment's owner;
  - the **renewal or notice date**, 90 and 30 days ahead, to the review's owner;
  - commitments whose source record changes, for example when the incident rule they rely on is edited.
- A **client's page** lists its signed contracts and commitments.

## Who can do what

- *Review contracts* or the owner marks as signed and confirms commitments.
- A commitment's owner records its checks.
- *View contracts* reads.

## Notes (technical)

- Tables: `contract_signatures(review_id, signed_on, attachment_id, term_start, term_end, renewal_on, auto_renews)` and `contract_commitments(company_id, client_id, clause_id, text, kind, owner_id, met_by_kind, met_by_id, cadence_months, next_check_on, status)`, plus `contract_commitment_checks`.
- Restricted evidence reuses the register's restriction rule (ADR 0122 §2), extended with a Contracts rule.
- Actions sources: checks due, renewal, source changed.

**Chain:** on the chain (migration + API).

**Done when:** on staging, Steve signs a review with one late change (acknowledged), confirms four commitments, records a check, and sees the renewal reminder in Actions.
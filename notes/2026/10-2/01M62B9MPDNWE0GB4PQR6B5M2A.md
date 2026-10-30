---
id: 01M62B9MPDNWE0GB4PQR6B5M2A
created: 2026-10-28T22:50:05.389603Z
updated: 2026-10-30T02:00:13.874627Z
type: task
title: Signed — record the signed contract, its term and renewal date; every obligation we accepted becomes a commitment in Contracts ▸ Commitments, with an owner, how it's met and when it's next checked
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1443
sprint: s2v7d6y
blocked_by:
- 01M62B98D706H5MHDPEAVS9AEC
comments:
- id: 01M64Y7R7P2Q5PB2W46HB4FGJ0
  author: Steve Vine
  at: 2026-10-29T22:59:35.286114Z
  text: |-
    Done — PR #1461 merged (454152a9), migration 0747.

    What's there:
    - **Mark as signed** (a Sent review; Review contracts or the owner): signed date, the signed copy (required), term start and end, renewal or notice date, and auto-renews.
      - The signed copy is checked against the approved version first. Every clause whose words differ is listed with a word-by-word difference, and each must be ticked as acknowledged before signing completes.
      - The signed copy goes into **Audit ▸ Evidence** as "Signed contract · CR-n" (type Log or record). It is restricted: only people with View contracts, or named on the review, see it there (and can download it).
    - **Commitments proposed** on signing, for every clause that accepted an obligation (a new commitment, a conflict agreed anyway, or an accepted fallback). Each starts Proposed, with a kind guessed from its topic. The owner either:
      - confirms it, with what we promised in a sentence, kind, owner, how it's met (a Compass record, or Tracked here) and check cadence (yearly by default); or
      - drops it with a reason.
    - **Contracts ▸ Commitments:** a sortable table showing client, commitment, kind, owner, how met, next check and status (Met / At risk / Not met pills; Proposed / Dropped / Ended dots), filtered by client, kind and status. Each commitment has its own page.
    - **Record a check:** met, or not met with a note required; it sets the next check. Not met points to raising a gap or a risk.
    - **Actions:**
      - checks due, for the commitment's owner;
      - the renewal or notice date, from 90 days ahead and reminded at 30, for the review's owner;
      - "what a commitment relies on changed", when the record it's met by was edited since its last check.
    - **End contract:** ends its commitments.
    - **Clients:** the client page and Clients tab now count reviews, signed contracts and open commitments, and list them.

    Small gaps for later (none blocks testing):
    - Someone named on a review but without View contracts can open each commitment but not the list.
    - The "how it's met" picker offers controls, policies, incident rules, recovery targets and certificates, not yet data assets, subprocessors or plan activities. Polaris and the API accept those.
    - A certificate's "Met by" links to the evidence register rather than the item.

    To test on staging: sign a review with one late change (acknowledge it), confirm four commitments, record a check, and see the renewal reminder in Actions.
- id: 01M658JGSJM4Z68YENPCZCR1H9
  author: Steve Vine
  at: 2026-10-30T02:00:13.874408Z
  text: |-
    Pre-UAT pass (Claude, staging): **Couldn't check**. It needs a sent review (COM-1441/1442).

    Seen: Contracts ▸ Commitments opens empty, with Checks due.

    A signed copy with one late change (14.1, 30 → 60 days) is ready: /home/steve/compass-uat/sprint-98/docs/E2E-20261030-client-MSA-signed.docx.
assignee: steve
label:
- feature
priority: high
task_status: review
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
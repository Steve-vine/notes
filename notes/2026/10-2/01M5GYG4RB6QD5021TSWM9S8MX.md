---
id: 01M5GYG4RB6QD5021TSWM9S8MX
created: 2026-10-22T04:39:21.611436Z
updated: 2026-10-22T20:05:59.737947Z
type: task
title: If the database is ever rolled back past sprint 82 and upgraded again, files added in Audit ▸ Evidence and vendor certificate files lose their company
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1244
comments:
- id: 01M5JGVTH97QT083F83RM5SBCR
  author: Steve Vine
  at: 2026-10-22T19:19:33.16103Z
  text: |-
    Done — merged in PR #1234 (migration 0490). Not yet on staging.

    After a rollback past sprint 82 and an upgrade, files added straight into Audit ▸ Evidence and vendor certificate files now keep their company, so they stay in the register. On a normal upgrade it changes nothing.

    My call: a certificate file that lost its details in a rollback also gets its type back as "Certificate or audit report" (what the app files it under by default). A file added in the register keeps "Other", because the type someone chose can't be recovered.

    Checked: the migcheck probe (use at head → downgrade 0430 → upgrade) now shows both files OK with their company (they were FAIL). A new migration test covers the same round trip.
assignee: steve
label:
- tech_debt
priority: low
task_status: done
---
Found 2026-10-22 by testing sprint 82's migrations against a populated database (scratchpad `migcheck/run.sh`). The forward upgrade is clean; this only bites after a downgrade.

**Chain:** on the chain — migration

## What's wrong

The scenario: use the new features at head, downgrade to 0430, then upgrade again.

- **Company lost:** files added straight into Audit ▸ Evidence (owner type `evidence`) and uploaded vendor certificate files (owner type `vendor_certification`) come back with no company and type "Other", so they drop out of the register. Cause: `0445_evidence_facts.py` has no `_COMPANY_BACKFILL` rule for those two owner types.
  - an `evidence` file's owner id is the company itself;
  - a certificate file's company comes through certificate → vendor → company.
- **Also lost on a rollback** (the migrations already say so):
  - link edits made at head;
  - version lineage;
  - renewed certificates, which show two current copies;
  - control links, revision evidence snapshots and export file locations.

Compass fixes forward and never rolls back a release (ADR 0041), so this is insurance only.

## Fix

A new migration whose upgrade backfills `company_id` for those two owner types, idempotently. Merged migrations are append-only, so 0445 isn't edited.

**Done when:** the migcheck probe (head use → downgrade 0430 → upgrade) leaves those files with their company.
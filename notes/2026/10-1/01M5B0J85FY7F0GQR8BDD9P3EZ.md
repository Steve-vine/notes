---
id: 01M5B0J85FY7F0GQR8BDD9P3EZ
created: 2026-10-19T21:20:01.199393Z
updated: 2026-10-19T21:20:01.199393Z
type: task
title: Closed requests keep the person's details only for the company's retention period — then Compass clears them, keeps the counts and outcome, and records each clearance in a retention log an auditor can read
priority: medium
task_status: todo
label: feature
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1143
---
Sprint 79, Data Privacy (ADR in COM-1129). The audit evidence asks for "retention logs". The register itself holds personal data, so it has to follow its own retention rule (storage limitation, UK GDPR Art. 5(1)(e)).

## What people see

**Settings ▸ Retention** (per company):

- **Keep a closed request's personal details for**: a number of years after closing. Default **6 years** (HIPAA documentation retention is 6 years, and the UK limitation period for claims is 6 years). The minimum is **2 years** (CCPA's 24-month record of requests); the screen says why.
- **Keep disclosures for**: default 6 years (HIPAA accounting looks back 6). Minimum 6 if the company uses HIPAA.
- Changing a period applies to everything already closed; a shorter period takes effect at the next nightly run. Saving shows how many requests that will clear.

**What clearing does** (nightly, per company):

- **Clears**: the person's name, contact details, address and reference; representative details; "what they said"; the verification note; timeline comments; letters' filled text; attachments; and the names in fulfilment, recipient and accounting notes.
- **Keeps**: the number, company, types, law, channel, kind of person, dates (received, due, extended, closed), decisions and reasons, system and recipient outcomes (without notes), on time or late, owner.
- The request page then reads "Personal details cleared on 3 Nov 2032 under the company's 6-year retention", with the kept facts below.
- The same applies to disclosures (the about-whom names, description and attachments) and requests to disclose.

**Retention log** (Settings ▸ Retention, and exportable): one line per clearance, with the date, the record (DSR-12, DIS-4), the rule applied (6 years after closing on…) and "by the nightly retention run". This is the evidence.

## Rules

- Clearing can't be undone, and the screen says so.
- A request or disclosure linked to an **open** incident, or under a **legal hold** (a tick on the record, with a reason), is skipped. The log notes "held".
- Restricted requests are cleared the same way.

## Notes (technical)

- An idempotent Celery task that takes company ids; it overwrites columns with null or "cleared" and deletes attachments from object storage.
- A retention log table, insert-only.
- History rows must also lose the cleared values. Check the activity log redaction: activity entries for these tables must store field names, not values, or be cleared too.

**Done when:** a request closed longer ago than the period has its personal details cleared and a log line written; counts and outcomes still show; a held record is skipped and logged.
---
id: 01M68M8H9ABM8M7DBBEC6KJ301
created: 2026-10-31T09:22:12.906964Z
updated: 2026-10-31T09:22:49.383793Z
type: task
title: Data subject requests, Contracts, Audits, the Schedule, Vulnerabilities, Attestations, Risk Assessments and Evidence follow the one-action-per-thing rule, with an action until each is closed
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1481
sprint: scpaa6p
assignee: steve
label:
- improvement
priority: medium
task_status: todo
---
Sprint 100, Actions (ADR 0137 rule 2). This is the second half of the module review, working from COM-1468's per-type table.

## What changes

**Data subject requests:** one row per open request at its step.
- **Acknowledge**, then **Send the extension letter** (when extended), then **Respond** (due on the deadline).
- While paused: **Chase the person** (14 days waiting).
- Today an owned request shows nothing until 7 days before its deadline. It will always show, emailing from 7 days.
- Requests to disclose: **Respond**, due on Respond by. It always shows, emailing from 3 days.

**Contracts:** one row per review at its step.
- **Review clauses** (for each person given clauses, one row per review).
- **Sign off** (escalated clauses), then **Approve**, then **Renew** (from the renewal date).
- Mentions stay their own row (someone asked you something).
- Each commitment: **Check**, and **Recheck** when what it relies on changed. Fold the two into one row.
- Today an owned review shows only a week before it's due. It will always show.

**Audits**
- Each request: **Provide evidence** for its owner.
- An unowned request goes to the default owner (the audit lead), replacing today's separate "Assign an owner" row.
- Overdue requests no longer make a second row for the lead. They see them with My actions off.
- Findings and auditor comments: check they're one row each.

**Schedule (SAP)**
- Each entry: **Plan activity · Complete**, for its owner, due on its end date. It always shows, emailing from 14 days. Today it's invisible until then.
- The "3 plan entries are overdue" roll-up goes.

**Vulnerabilities**
- **Fix**, then **Review the acceptance** (when accepted), then **Decide an acceptance** (when asked).
- A vulnerability with no fix-by date (informational) is due N days after it was found, set on Admin ▸ Actions.
- **New:** unmatched findings become one row per company, **Vulnerabilities · Place** "8 to place", for the default owner.

**Attestations:** unchanged (one row per document to sign).

**Risk Assessments**
- **Continue**, then **Approve**, then **Rework** (sent back), then **Reassess** (AI system or processing changed).
- Follow-ups keep their own rows.
- A DPIA's ICO reply: **Record the ICO's reply**.

**Evidence:** **Replace** out-of-date evidence, as today. Check that the uploader and the record's owner don't both get a row. If they do, the record's owner only, falling back to the uploader.

**Chain:** on the chain. Blocked by COM-1470 and COM-1473.

**Done when:** on staging, for each module, the pre-UAT pass finds every open thing with exactly one row (apart from separate follow-ups and mentions) and none once it's closed.
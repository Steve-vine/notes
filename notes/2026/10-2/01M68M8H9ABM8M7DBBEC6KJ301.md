---
id: 01M68M8H9ABM8M7DBBEC6KJ301
created: 2026-10-31T09:22:12.906964Z
updated: 2026-10-31T13:00:01.873079Z
type: task
title: Data subject requests, Contracts, Audits, the Schedule, Vulnerabilities, Attestations, Risk Assessments and Evidence follow the one-action-per-thing rule, with an action until each is closed
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1481
sprint: scpaa6p
blocked_by:
- 01M68M4TR5X3N0A30R9F8XGY5V
- 01M68M5RS2BS736HK2PFS7R8B8
comments:
- id: 01M68W944MFTGCMTDWB5S56PTP
  author: Steve Vine
  at: 2026-10-31T11:42:20.819848Z
  text: |-
    Done: PR #1497 merged.

    - **Data subject requests:** one row per open request at its step: Acknowledge, then Send the extension letter, then Chase the person, then Respond. It's on the list from the day the request is logged until it closes, not just the last 7 days. Requests to disclose are always on the list too.
    - **Contracts:** a review being worked, and a signed contract's renewal, are always on the owner's list. A commitment's Check and Recheck are one row. Titles name the thing ("CR-7 · ACME MSA 2027").
    - **Audits:**
      - A request nobody owns is the lead's own row ("— nobody owns it yet"), replacing "Assign an owner".
      - The lead's extra "Overdue" rows are gone. The lead sees others' overdue requests on the audit itself rather than on Actions, because audit work has no module-wide team.
    - **Schedule (plan):** every open activity is always on its owner's list, and unowned ones go to the plan managers. The "N plan entries are overdue" roll-up is gone.
    - **Vulnerabilities:**
      - Fix appears from when it's recorded. Informational ones are due 90 days after being found.
      - While an acceptance has been asked for, only the people who can accept it get a row.
      - New: **Vulnerabilities · Place unmatched findings**, one row per company.
    - **Risk assessments:** one row per assessment at its step. Continue shows from the start, due 30 days later. A DPIA waiting on the ICO is always on the list.
    - **Evidence going out of date:** the record owner's job only, or whoever added it if the record has no owner. Before, both got a row. It still appears only 30 days before, so the list isn't flooded with every piece of evidence.
    - **Attestations:** unchanged.

    To test on staging, in E2E Test Company: for each of these modules, every open item should have exactly one row (apart from follow-ups and mentions, which are separate things), and none once it's closed.
- id: 01M690QBYH1NDBJENDQEN675DX
  author: Steve Vine
  at: 2026-10-31T13:00:01.87285Z
  text: |-
    Pre-UAT (staging, 31 Oct, every E2E account, through the API): Passed for duplicates.
    - No item has two rows for any reader, apart from content with two reviewers (see COM-1478).

    Couldn't check: the module steps. E2E Test Company has no data subject requests, contract reviews, audits, plan activities or vulnerabilities to walk through. The integration tests cover each module's steps. Worth looking at with real data in Test Company during your smoke test.
assignee: steve
label:
- improvement
priority: medium
task_status: review
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
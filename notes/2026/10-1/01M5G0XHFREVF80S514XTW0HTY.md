---
id: 01M5G0XHFREVF80S514XTW0HTY
created: 2026-10-21T20:02:23.352232Z
updated: 2026-10-22T18:24:39.943754Z
type: task
title: Evidence warns when it's out of date — amber a month before its valid-until date, red after, a to-do for whoever looks after it, and the controls with out-of-date evidence easy to find
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1210
sprint: sno3i7m
blocked_by:
- 01M5G0X6CFX828QRJ312NDEYX0
comments:
- id: 01M5GQWK1T4H2AV4ZG9NWX59D3
  author: Steve Vine
  at: 2026-10-22T02:43:49.434792Z
  text: |-
    Done — merged in PR #1224.

    - **Every file and link has a valid-until date.** It's the date given, or else its evidence type's "Valid for" counted from the end of the period it covers, or from the day it was added. The register shows the date, with "from its type" beneath it when it was worked out.
    - **Status:** Current; **Due soon** (amber) within 30 days; **Out of date** (red) after the date. The date itself still counts as in date.
    - **Where the status shows:**
      - the register (filterable by it), with By core control and By framework counts such as "2 current · 1 out of date";
      - the "Some due soon" and "Some out of date" filters, which now work;
      - the header of the evidence's page;
      - each file and link on the assessment card, and "Linked from elsewhere";
      - the control page's evidence line, e.g. "1 out of date".
    - **Plan, incident and data subject request files** never go out of date. Their page says "A record of work done — it doesn't go out of date".
    - **Edit details** on an evidence page (Manage evidence) changes the type, what it is, the period and the valid-until date. Leave the date empty to work it out from the type again. On the assessment card, a pencil beside each file does the same for assessors.
    - **To-do:** an Actions item, "Evidence out of date", for the person who added the evidence and the owner of the record it sits on (the assessment owner or the risk owner). It appears 30 days before, is reminded on the day, then stays overdue until someone gives the evidence a later date.
    - It only warns: no control's status, maturity or gaps change.

    My calls (beyond the task):
    - **Incident and data subject request files** count as records of work whether the record is open or closed. Plan files count as records once the activity is done or cancelled.
    - **Policies and vendor certificates** go by their own dates (next review, expiry). A policy past its review shows Out of date. Neither raises this new to-do, because they already have their own review and expiry to-dos.
    - **Only the two people named get the to-do**, not every evidence manager. Otherwise the first day would put every year-old file on every admin's list.
    - **On the assessment card the pill only appears when something's wrong** (due soon or out of date), so current files stay quiet. The register and the evidence page always show it.
    - **Editing on the evidence page** is for evidence on an assessment, a risk or the register. Elsewhere it says to change it where it sits (e.g. on its plan activity).
assignee: steve
label:
- feature
priority: high
task_status: done
---
Sprint 82, Evidence (ADR in COM-1198). Builds on COM-1209 (chain order); uses valid-until from COM-1200 and each evidence type's validity from COM-1217.

**Chain:** on the chain — API

## What people see

**Valid until:**
- Every piece of standing evidence has a valid-until date. It's the one given when it was added.
- If none was given, it's the end of the period it covers plus its evidence type's **Valid for** (12 months by default, set per type in Admin ▸ Rubrics ▸ Evidence types). Without a period, the type's validity counts from the day it was added.
- Changing a type's validity moves the date for every piece of evidence of that type that has no date of its own.
- Anyone who can manage the evidence, or the record it sits on, can change it.

**Status**, shown wherever evidence appears — the register, By core control, By framework, beside each file on the assessment card and the control's page, and in every count:
- **Current**;
- **Due soon** (amber): within 30 days of its valid-until date;
- **Out of date** (red): past it.

**What never goes out of date:**
- Evidence from finished work: a done plan activity, a closed incident or data subject request. It records something that happened. *(My call.)*
- Policies follow their own review dates, as today.

**To-dos:**
- An Actions to-do 30 days before, and again on the day, for the person who added the evidence and the owner of the control's assessment.
- "Replace" on the to-do goes straight to uploading a new version (COM-1211).

**It only warns.** It never changes a control's status, maturity or gaps, the same rule as Evidence of operation.

**Existing evidence** has no date of its own, so it follows its type's validity from the day it was added. With the 12-month defaults, anything older than a year shows Out of date from day one, which is honest about where things stand. *(My call — Steve to confirm.)*

**Filters:** status on the register; "only out of date" on By core control and By framework.

## Notes (technical)

- Status is derived when read, not stored, so a change to a type's `valid_months` takes effect at once.
- A new Actions source (ADR 0055: declare a source, don't write a notify()), using the existing lead-window settings.

**Done when:**
- a file with valid-until in 20 days shows amber and gives its owner a to-do;
- one past its date shows red and the "only out of date" filter finds its control;
- raising a type's validity turns its undated evidence back to Current;
- a closed incident's file never warns.
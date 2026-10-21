---
id: 01M5G0XHFREVF80S514XTW0HTY
created: 2026-10-21T20:02:23.352232Z
updated: 2026-10-21T20:04:31.589467Z
type: task
title: Evidence warns when it's out of date — amber a month before its valid-until date, red after, a to-do for whoever looks after it, and the controls with out-of-date evidence easy to find
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1210
sprint: sno3i7m
assignee: steve
label:
- feature
priority: high
task_status: todo
---
Sprint 82, Evidence (ADR in COM-1198). Builds on COM-1209 (chain order); uses valid-until from COM-1200.

**Chain:** on the chain — API

## What people see

**Valid until:**
- Every piece of standing evidence has a valid-until date. It's the one given when it was added; or, if none was given, 12 months after the end of the period it covers; or, without a period, 12 months after it was added.
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

**Existing evidence** gets valid-until 12 months after it was added. Anything older than a year shows Out of date from day one, which is honest about where things stand. *(My call — Steve to confirm.)*

**Filters:** status on the register; "only out of date" on By core control and By framework.

## Notes (technical)

- Status is derived when read, not stored. A new Actions source (ADR 0055: declare a source, don't write a notify()), using the existing lead-window settings.
- Backfill of the default valid-until belongs in COM-1200's data migration if it hasn't shipped yet; otherwise here.

**Done when:**
- a file with valid-until in 20 days shows amber and gives its owner a to-do;
- one past its date shows red and the "only out of date" filter finds its control;
- a closed incident's file never warns.
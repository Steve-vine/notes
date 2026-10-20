---
id: 01M5B0JM7T3BT1PQ14EP58BZJD
created: 2026-10-19T21:20:13.562206Z
updated: 2026-10-20T03:53:53.029034Z
type: task
title: A Compliance tab shows how well requests are answered — open, due this week, overdue, on time over 12 months, by type and by law, refusals and extensions, the CCPA annual figures — and exports the request, disclosure and retention logs for an auditor
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1144
sprint: ss8348q
blocked_by:
- 01M5B0J85FY7F0GQR8BDD9P3EZ
comments:
- id: 01M5BQ3DG8EGT5TYR1XJDXXBN9
  author: Steve Vine
  at: 2026-10-20T03:53:52.392762Z
  text: |-
    Done — merged (PR #1139).

    - Data Subject Requests has a **Compliance** tab, between Disclosures and Settings.
    - Four figures across the top: **Open**, **Due in 7 days**, **Overdue** and **Answered on time** (last 12 months, e.g. "37 of 40"). Open and Overdue link to the register.
    - **By type** and **By law** tables for a period (last 12 months by default, this year, last year, or custom; kept in the address): received, completed, partly, refused, withdrawn, on time %, median days, extended, plus "N still open".
    - **Refusal reasons** with how often each was used; **Complaints**: received, acknowledged in time, and their themes.
    - **CCPA annual figures** for last year (know, delete, correct, opt out × received, complied in whole or part, denied, median days) — only for a company that uses CCPA.
    - **Requests per month over 24 months**, stacked by type (checked in a real browser, light and dark, and at phone width).
    - An **Export** menu builds: request log, disclosure log, refusals and retention log (CSV or PDF), and the letter templates (PDF: standard wording plus the company's own). Every export is recorded in Activity; only the person who made it can download it, for 7 days.
    - Restricted requests count as numbers only; requests logged in error are left out of every figure.

    My calls: in exports, a restricted request is in full only for someone named on it (stricter than on screen, as the task asks); a request falls in a period by the day it was received, and each type counts its own decision (access granted + erasure refused counts once in each); "Identity not confirmed" counts as refused (and as denied in the CCPA figures); CCPA "requests to know" covers access and portability; requests passed to a customer are counted as received but in no outcome column; the request log shows the person's name only, not contact details. The retention log export fills in once Retention (COM-1143) lands.
assignee: steve
label:
- feature
priority: medium
task_status: review
---
Sprint 79, Data Privacy (ADR in COM-1129). The audit evidence asks for "request logs, templates, sample fulfilled requests, disclosure records, denial records and retention logs".

## What people see

**Compliance** tab (per company):

- **Four figures**: Open · Due in 7 days · Overdue · Answered on time (last 12 months, %).
- **By type** table: type, received, completed, partly, refused, withdrawn, on time %, median days, extended. Last 12 months by default; a period picker (12 months, this year, last year, custom), kept in the URL.
- **By law**: the same columns, grouped by law.
- **Refusal reasons**: how often each was used.
- **Complaints**: received, acknowledged in time, themes (the reasons and types they concerned). This is the "monitored for patterns" that PDH.17 asks for.
- **CCPA annual figures** (shown when the company uses CCPA): for the previous calendar year, requests to know, delete, correct and opt out, each received, complied with in whole or part, and denied, with the median days to respond. This is the §7102 disclosure format.
- **Trend**: requests per month over 24 months, stacked by type.

**Exports** (CSV and PDF, for the selected period):

- **Request log**: every request with number, dates, type, law, outcome, reasons, on time or late. Personal details are included only for those who can see them; restricted requests are redacted unless the exporter is named on them.
- **Disclosure log**: authorised and unauthorised.
- **Refusals**: the denial records, with reasons.
- **Retention log**.
- **Letter templates**: the current standard and company wording, as PDF.

## Rules

- Counts include restricted requests (as numbers only); details follow the restricted rule.
- Every export is logged in the activity log (who, what, when).

## Notes (technical)

- Read-only aggregate endpoints. Charts follow the Mantine charts recipe (version pin; a many-series chart needs a real-browser look).
- PDF exports through the existing renderer.

**Done when:** the tab shows the figures and tables for a period; each export downloads and respects restricted redaction; CCPA figures show only where CCPA is used.
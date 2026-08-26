---
id: 01M0Z9EJBDXSW1B2J35BTP4F46
created: 2026-08-26T15:01:37.261577Z
updated: 2026-08-26T15:02:14.171195Z
type: task
title: Coverage tells the truth about partial cover, everywhere it is shown
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 429
sprint: s8cjs5n
assignee: steve
company:
- moneypenny
label:
- feature
priority: high
task_status: backlog
---
The schema work gives coverage three states instead of two. This makes every
place that reports coverage use them, so a partly-covered requirement stops
reading as a covered one.

Today the answer to "how are we doing against ISO" is one number derived from a
count of mappings. After this sprint it should be a number you could defend in
an audit, next to the working that produced it.

## What changes for the reader

**Framework coverage** shows fully covered, partly covered, not covered, and not
applicable — four bars, not one percentage. The headline figure counts fully
covered against applicable requirements, and says so.

**A requirement's page** shows the Core controls carrying it, each with its
relationship and strength, and — where it is only partly covered — what is
missing. That last part is the whole point: a partial requirement is a work item,
not a rounding error.

**The gap list** separates "no control defined" from "control defined, not
implemented". They are completely different problems with completely different
owners, and today they are the same row.

**The Statement of Applicability** gains the exclusion justification column and
the ISMS/Annex A split.

**Auto-fail requirements** (Cyber Essentials Danzell) are marked wherever they
appear. An unmet auto-fail is not a gap to schedule.

## Implementation

- Depends on the mapping relationship, applicability and crosswalk tasks.
- One coverage function, called by the dashboard, the framework page, the gap
  list, the SoA export and the reporting exports (ADR 0024). The rule must not
  be reimplemented per caller — it is already close to that today.
- Historic reports must not silently change meaning. A report generated before
  this lands said "72% covered" under the old rule; either re-render from live
  data with a note, or stamp exports with the rule version. Decide and say which.
- The dashboard number will drop noticeably. Put a short explanation next to it
  on first view rather than letting people discover it as a regression.

Tests: the four states sum to the applicable requirement count; the headline
percentage matches fully-covered over applicable; the gap list distinguishes
undefined from unimplemented; the SoA renders exclusions.

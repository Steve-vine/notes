---
id: 01M0Z9EJBDXSW1B2J35BTP4F46
created: 2026-08-26T15:01:37.261577Z
updated: 2026-08-27T02:49:49.85096Z
type: task
title: Coverage tells the truth about partial cover, everywhere it is shown
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 429
sprint: s8cjs5n
blocked_by:
- 01M0Z95RFQ9FFZ3YAYPMTP7NAC
- 01M0Z96370R231D1A9PTH5CP5B
- 01M0Z9E0XKTK6356G40449BC5T
comments:
- id: 01M10HZB0T12T07E639S6H4A3X
  author: Steve Vine
  at: 2026-08-27T02:49:49.85081Z
  text: |-
    Done — PR #436.

    The specific lie is gone. A requirement whose one mapped control does part of the job used to read "Met" the moment that control was implemented — the work needed to close it was invisible, because the number said it was closed.

    Cover and posture are now two answers, side by side and never multiplied. Cover asks whether the Core library satisfies the requirement at all; that is the same answer for every company, and when it is short no amount of implementation work will fix it. Posture asks whether this company has implemented the controls carrying it.

    The headline is two cards — a four-band bar for cover (fully, partly, not covered, not applicable) over the whole standard with the denominator written out, and the ring for posture, now named as the second question rather than the only one. The requirement table gains a Cover column, and a partly covered row says why it is short rather than leaving the reader to work it out.

    Each contributing control now shows how far it goes and how confident the mapping is. Without that, a control that satisfies a requirement and one that contributes a corner of it looked identical on the row.

    The gap split is two lists: "no control defined" and "control defined, not implemented". Different problems, different owners, and they were the same row.

    On historic reports — nothing is persisted, so there is nothing stored to re-render. What exists is PDFs already on people's disks, and a "72% covered" from before this sprint does not mean what one from after it means. The decision is to stamp the rule on the face of the report: every coverage export now carries "Coverage rule: ADR 0056", in the PDF subtitle and in a CSV preamble.

    Two items in the brief had already landed with earlier tasks and are verified rather than rebuilt here: the SoA's exclusion column and ISMS/Annex A split, and the single coverage function every caller shares.
assignee: steve
company:
- moneypenny
label:
- feature
priority: high
task_status: active
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

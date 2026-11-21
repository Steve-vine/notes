---
id: 01M7ZN74NA0RN5N5RA0R5HX1MF
created: 2026-11-21T18:17:09.546143Z
updated: 2026-11-21T19:15:43.597458Z
type: task
title: A control's summary box counts every out-of-date piece on its Evidence tab, including plan evidence
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2085
sprint: s9hexqn
comments:
- id: 01M7ZRJ9ZD0X80BHPKTZ6MSVJS
  author: Steve Vine
  at: 2026-11-21T19:15:41.165875Z
  text: |-
    Done and merged to main (PR #2069). No migration. One small API field change; the generated types are regenerated.

    What changes:
    - The "out of date" and "due soon" pills in a control's summary box now count every piece its Evidence tab lists as Out of date or Due soon, wherever the piece is held: a plan entry, an incident, a certificate, or added straight on the control. RIM.9 went from "2 links · 8 files" with no pill to the same line with "1 out of date" (EVD-94 on SAP-91).
    - A control whose evidence is all in date shows no pill.
    - On the Assessment screen, each piece's status now comes from the same place as the Evidence tab. So a plan piece is dated from the end of the plan entry's due window there too.
    - Being out of date still only warns.

    The box now takes each piece's status from the evidence register's own rule, so there's no second rule to drift.

    Tests: a plan piece, a piece added straight on the control, and a control with only in-date evidence, on the server and on the Control screen. While CI ran, I also made a flaky Collection card test wait for its button before clicking it.

    Calls for you to overturn:
    - The "links · files" counts are unchanged. They still count only what's on the assessment itself, not everything on the Evidence tab.
    - Someone who can't see a source isn't counted for it. For example, without Vulnerabilities access, a vulnerability's file doesn't add to their pill.
assignee: steve
label:
- bug
priority: high
task_status: review
---
Found by the COM-2075 pre-UAT check (staging 816933877, 21 Nov).

## The problem
- On RIM.9's Control screen, the summary box's Evidence line reads "2 links · 8 files", with no out-of-date pill.
- But the Evidence tab and the Assessment screen both list EVD-94, a file on plan entry SAP-91, as Out of date.
- The box counts only evidence added straight on the control. Before COM-2075, plan evidence never went out of date, so this didn't matter. Now a control can look clean in its summary while one of its pieces is out of date, which defeats the point of COM-2075.

## What people see
- The summary box's "out of date" and "due soon" pills count every piece the control's Evidence tab lists as Out of date or Due soon. That includes pieces linked from elsewhere: a plan entry, an incident or an audit request.
- Where the box links to the Evidence tab, it still does.
- The box's other counts stay as they are unless they're simple to align. If they're changed to count everything on the Evidence tab, say so in the PR (a call for Steve).
- Being out of date still only warns.

## Done when
- With EVD-94 (out of date, on SAP-91) linked to RIM.9, RIM.9's summary box shows "1 out of date", matching the Evidence tab.
- A control with only in-date evidence shows no pill.
- Tests cover a plan piece and a piece added straight on the control.

On the chain or independent: independent, unless an API field changes. If it does, regenerate the schema.
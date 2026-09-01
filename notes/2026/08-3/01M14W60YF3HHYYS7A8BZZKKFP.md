---
id: 01M14W60YF3HHYYS7A8BZZKKFP
created: 2026-08-28T19:05:12.399125Z
updated: 2026-09-01T13:55:52.381596Z
type: task
title: 'Run history: what the answer was in March'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 494
sprint: s42ntc9
blocked_by:
- 01M14W44PF9GB1B05NCE4X0H9A
comments:
- id: 01M16N93FYTY2DVHMKS4XAAYMP
  author: Steve Vine
  at: 2026-08-29T11:43:02.142452Z
  text: |-
    Done and merged to main — PR #501, migration 0146_report_runs.

    Every run keeps a record: when, who or what ran it, the company, the row count, whether the cap truncated it, the definition exactly as it was worded at the time, and the output. The History panel itself landed with the report's page in COM-490, since that is the page the task put it on.

    The snapshot is the whole point, and it is carried by duplicating the definition columns onto the run rather than joining back. There is a test that edits the report afterwards and asserts the historical run still says what it asked. The summary sentence is frozen with the rest rather than re-derived on read — re-deriving would consult today's catalogue for its labels, and a field renamed since would silently reword a historical run. `definition_id` is nullable with SET NULL so a run outlives its report: deleting a report must not destroy the evidence of what it once said.

    **One decision the task did not settle: what counts as a run.** A download is a run and is recorded; the paged on-screen preview is not, because recording one per page flick would bury the runs somebody actually took a copy of. That makes `/download` a GET that writes, which is a wart and a deliberate one — the alternative is two round trips for every browser download and the same bytes in storage under two stories. Taking a copy is the thing worth remembering; flicking through pages is not.

    The record is committed **before** the file is written, so a storage failure costs the file and never the record — *that the report ran, and what it said* is the part with audit value. Test breaks `Storage.put` and asserts the run survives with `has_output: false`. Serving a historical download streams the stored file and never re-runs the definition; the test proves it by flipping a user's enabled flag after the run.

    Retention defaults to keeping everything (`REPORT_OUTPUT_RETENTION_DAYS=0`) as the task asked. When a window is set, the sweep drops the **file** and keeps the **record** — different facts with different lifetimes, and `has_output` stops the panel offering a download that 404s.

    `Storage` gained a `delete` method; it went without one because attachments and content files are governance records that are never deleted.

    `ReportRunStatus.failed` and `record_failure()` land here unused — they are what COM-495 needs, since a schedule that quietly stopped cannot be visible in the library unless the failure is a row.
assignee: steve
label:
- feature
priority: medium
task_status: done
---
ADR 0062 §5, second half. A report whose answer cannot be reproduced later is a query, not an audit artifact.

Every run — ad-hoc or scheduled — keeps a record: when it ran, who or what ran it, the company it was run for, the row count, whether it was truncated, **the definition exactly as it was worded at the time**, and the output.

The snapshot is the ADR 0032 §4 pattern applied to a report: the definition may be edited freely afterwards, and no edit reaches a run that has already happened. A history that re-renders old runs through today's definition would show the wrong answer with yesterday's date on it, which is worse than keeping nothing.

Output goes to the existing file storage; retention is a setting, defaulting to keeping everything, because *how long we kept it* is itself an audit question and guessing low is the expensive mistake.

Surface it as a **History** panel on the report's page: the runs, with the definition of the day readable and the file downloadable.
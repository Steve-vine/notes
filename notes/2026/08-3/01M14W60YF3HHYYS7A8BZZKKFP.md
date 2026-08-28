---
id: 01M14W60YF3HHYYS7A8BZZKKFP
created: 2026-08-28T19:05:12.399125Z
updated: 2026-08-28T19:06:41.885556Z
type: task
title: 'Run history: what the answer was in March'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 494
sprint: s42ntc9
blocked_by:
- 01M14W44PF9GB1B05NCE4X0H9A
assignee: steve
company: null
label:
- feature
priority: medium
task_status: todo
---
ADR 0062 §5, second half. A report whose answer cannot be reproduced later is a query, not an audit artifact.

Every run — ad-hoc or scheduled — keeps a record: when it ran, who or what ran it, the company it was run for, the row count, whether it was truncated, **the definition exactly as it was worded at the time**, and the output.

The snapshot is the ADR 0032 §4 pattern applied to a report: the definition may be edited freely afterwards, and no edit reaches a run that has already happened. A history that re-renders old runs through today's definition would show the wrong answer with yesterday's date on it, which is worse than keeping nothing.

Output goes to the existing file storage; retention is a setting, defaulting to keeping everything, because *how long we kept it* is itself an audit question and guessing low is the expensive mistake.

Surface it as a **History** panel on the report's page: the runs, with the definition of the day readable and the file downloadable.
---
id: 01M77MWJXKT8ZQYER1X7QPM4KF
created: 2026-11-12T10:29:37.331696Z
updated: 2026-11-12T10:29:39.393034Z
type: task
title: A done SAP entry's name can be corrected, with a reason, the old name kept beside the record
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1750
sprint: spsp226
assignee: steve
label:
- improvement
priority: low
task_status: todo
---
Steve, testing on staging (2026-11-12).

**Today:** a done SAP entry is frozen (ADR 0115 §5). **Correct** covers only the outcome, the completion date, and an exercise's result and recovery times. A done entry with the wrong name can't be put right.

**What it should do:** the name joins what **Correct** can change on a done entry.
- It's the same correction as today: a reason is required, and the correction is kept beside the record with the name before and after, who made it and when.
- The new name shows everywhere the entry is named: the plan, coverage, Evidence of operation, its evidence in Audit ▸ Evidence, exports, and the owner's portal. Audit packs already built keep the name they were built with.
- Only the people who can correct a done entry today can correct its name.
- Correcting the name changes only this entry. Other entries in its repeating series keep their names, as other corrections already work.
- Cancelled entries stay as they are: no name correction.
- Polaris's correct-entry tool (MCP) takes the name too.

**Done when:**
- on a done entry, Correct → change the name → give a reason → the new name shows on the entry, the plan and its evidence;
- the corrections list shows the name's before and after, with the reason;
- a Correct with the same name and nothing else changed still says "Nothing to correct";
- someone without the right to correct can't change the name;
- there are no errors in the browser console.

Amend ADR 0115 §5 (what a correction may change). The API change puts this on the chain: `SapCorrectIn` gains `title`, the correction keeps it before and after, and the OpenAPI and `schema.d.ts` are regenerated.
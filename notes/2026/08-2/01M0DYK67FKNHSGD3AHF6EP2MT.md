---
id: 01M0DYK67FKNHSGD3AHF6EP2MT
created: 2026-08-19T21:24:49.007762Z
updated: 2026-08-20T08:50:17.594524Z
type: task
title: Group membership surfaces count only direct members — nested groups and their members are invisible
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 300
order: 1.0
sprint: sar11t4
blocked_by:
- 01M0E0YHDQEF56K51BVVG79MEK
comments:
- id: 01M0E1070S792PH0RBZ6KZRRZR
  author: Steve Vine
  at: 2026-08-19T22:06:52.952901Z
  text: 'Moved from the Access Control sprint into the new Access Graph sprint (planned 2026-08-19): the graph endpoint task (COM-303, now a blocker) builds the shared recursive expansion helper this fix consumes. Land option 1 (read-time expansion over the mirror''s direct edges) on top of that helper, keeping this task''s own scope — the member count, the group modal''s direct-vs-inherited presentation, and the recert snapshot. ADR 0048 records the shared-helper decision.'
assignee: steve
label:
- bug
priority: medium
task_status: active
---
Smoke finding from Sprint 34 (2026-08-19, surfaced by the new COM-270 Members column, but the gap is mirror-wide).

The View Groups member count, the group modal's Members panel, and everything else that reads `directory_group_members` show **directly added users only**. A group whose membership arrives through a nested group shows neither the nested group nor its members — the count reads low, and the effective membership is invisible.

Mechanism: the mirror sync (COM-237/252) stores Graph's `/groups/{id}/members` — direct members. Member ids that are themselves groups land in `directory_group_nested_members` (the group→group edge), but nothing expands them: `member_counts()` and the members endpoint count/list `directory_group_members` rows alone.

This is more than a display nit — the same direct-only rows feed:

* **Recert v2 snapshots** (`_snapshot_items`, COM-282): a review of a group with nested membership never puts the nested members in front of the owners — the attestation silently under-covers.
* **JML mover/leaver diffs and out-of-band membership detection** (managed groups, ADR 0045 §4/§7) — though managed groups are constrained to plain assigned security groups, those can still contain nested groups.

Fix options, in rough order of preference:

1. **Expand transitively at read time** — a recursive walk over `directory_group_nested_members` + `directory_group_members` (deduplicated per person), used by the count, the modal panel (perhaps as "N direct + M via nested groups"), and the recert snapshot. No sync change; the mirror already holds both edges.
2. **Mirror Graph's `/transitiveMembers` per group** alongside direct members — heavier crawl (COM-275's cost lesson applies: measure before widening), but makes "effective member" a first-class stored fact.

Whichever lands, decide the display contract explicitly: does the Members column mean direct or effective? If effective, the modal should still distinguish direct vs inherited-via-nested so a reviewer knows what a removal would actually touch (removing a nested member means editing the *nested* group, not the reviewed one — the recert removal path must not pretend otherwise).

Refs: COM-270 (the column that surfaced this), COM-237/252 (mirror crawl), COM-282 (snapshot reads), `tasks/directory_sync.py` (`_reconcile_nested_members`), `api/v1/directory.py` (`member_counts`, `group_members`), ADR 0045 §3/§8, ADR 0047 §3.
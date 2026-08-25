---
id: 01M0PYHR077WQBVZ31JC9H975C
created: 2026-08-23T09:17:11.559007Z
updated: 2026-08-25T18:43:05.962229Z
type: task
title: Vendor history says what changed — field-level diffs on Updated entries
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 382
sprint: sbph5q5
comments:
- id: 01M0Q4XMMWHANJPT5JFZQNS07Q
  author: Steve Vine
  at: 2026-08-23T11:08:32.796764Z
  text: |-
    Done — PR #384, merged to main as 8bbdbbb.

    `core/vendor_history.py` diffs consecutive snapshots and composes the lines on read. Formatting as asked: enums by label, units on the figure (`Review frequency: 6 months → 12 months`), long text as "updated" rather than two paragraphs, `set to` / `cleared` for the null edges. Owners resolve to people, with "an account since removed" for an id the directory no longer holds. One thing that fell out of writing it: only enums are re-cased — capitalising every value turns a website into `Https://…`.

    No money or date columns exist in `VENDOR_SNAPSHOT_FIELDS`, so those formatting rules had nothing to bite on. `updated_by` and the timestamps are not in the snapshot either, so the noisy-column exclusion was already true by construction.

    `RevisionsCard` becomes `# / When / Action / What changed`, with the lines as indented child rows in the `[data-group-row]` pattern. The old columns of per-snapshot headline fields answered "what did it say then?" but never "what moved?", which is the question the tab is for.

    Two things worth your judgement:

    - **The no-change revision.** You asked it to say what drove it "where the writer knows". No writer records a reason today — nothing passes one to `write_vendor_revision` — so rather than guess, it says "No vendor field changed — recorded alongside a change to something the snapshot does not cover." If you want the real reason there, that is a separate change: the writers would have to start passing one.
    - **Where it lives.** The note described the Date/Action/By table, which is the generic admin-only `ActivityHistory` shared with risks and decisions. I put the diff on the vendor's own revision axis instead, since that is where the snapshots are, and left `ActivityHistory` alone rather than change a component two other pages depend on.

    `action` and `changes` are required in the contract, not defaulted — every revision has an answer, and a default would make every client guard a field that is always sent. Both callers, internal and portal, read the same composed lines.
assignee: steve
company: null
label:
- improvement
priority: medium
task_status: done
---
The vendor History tab shows Date / Action / By — but an "Updated" row doesn't say what was updated. The revisions are full snapshots (`write_vendor_revision`), so the answer is already stored; it just isn't being read.

- [ ] **Server-side diff between consecutive revisions**: for each revision, compare against its predecessor and emit changed fields as display lines — field label, old → new ("Criticality: Medium → High", "Review frequency: 6 → 12 months"). The first revision is "Created" with no diff. Compose on read (the snapshots are the source of truth; storing diffs would be a second copy that can disagree).
- [ ] Formatting by field type: enums by label, money as elsewhere, dates as elsewhere, long text (notes/description) as "updated" rather than inlining two paragraphs; null → value reads "set", value → null reads "cleared".
- [ ] A revision with **no column change** (written for a posture side-effect or similar) should say what drove it where the writer knows (state flips from COM-363 etc.) rather than showing an empty "Updated".
- [ ] UI: the diff lines render under each history row — the indented child format (the register's parent/child pattern, as COM-376 uses for request summaries) so the table stays scannable.
- [ ] Exclude noisy/immaterial columns from the diff (`updated_by`, timestamps — the row already shows By and Date).
- [ ] Tests: single-field and multi-field diffs; enum/money/date formatting; set/cleared; long-text summarised; first revision; no-change revision wording.
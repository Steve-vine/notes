---
id: 01M0PYHR077WQBVZ31JC9H975C
created: 2026-08-23T09:17:11.559007Z
updated: 2026-08-23T09:17:11.559007Z
type: task
title: Vendor history says what changed — field-level diffs on Updated entries
label: improvement
assignee: steve
priority: medium
task_status: backlog
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 382
---
The vendor History tab shows Date / Action / By — but an "Updated" row doesn't say what was updated. The revisions are full snapshots (`write_vendor_revision`), so the answer is already stored; it just isn't being read.

- [ ] **Server-side diff between consecutive revisions**: for each revision, compare against its predecessor and emit changed fields as display lines — field label, old → new ("Criticality: Medium → High", "Review frequency: 6 → 12 months"). The first revision is "Created" with no diff. Compose on read (the snapshots are the source of truth; storing diffs would be a second copy that can disagree).
- [ ] Formatting by field type: enums by label, money as elsewhere, dates as elsewhere, long text (notes/description) as "updated" rather than inlining two paragraphs; null → value reads "set", value → null reads "cleared".
- [ ] A revision with **no column change** (written for a posture side-effect or similar) should say what drove it where the writer knows (state flips from COM-363 etc.) rather than showing an empty "Updated".
- [ ] UI: the diff lines render under each history row — the indented child format (the register's parent/child pattern, as COM-376 uses for request summaries) so the table stays scannable.
- [ ] Exclude noisy/immaterial columns from the diff (`updated_by`, timestamps — the row already shows By and Date).
- [ ] Tests: single-field and multi-field diffs; enum/money/date formatting; set/cleared; long-text summarised; first revision; no-change revision wording.
---
id: 01M23RHYVPSNFP3NT2F7GT8W2D
created: 2026-09-09T18:58:16.566658Z
updated: 2026-09-09T19:12:17.925949Z
type: task
title: Notes on the timeline — a person marks what happened, beside the events Compass derives
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 640
sprint: srtvjyn
blocked_by:
- 01M23RHPNTNY1ZNJCMPCF9XB7D
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
The derived events explain the jumps Compass caused. The ones it did not — "Q3 assessment campaign", "external audit", "new CISO" — need somebody to write them down, and the Timeline is where they belong.

- `posture_annotations`: `company_id`, `on` (Date), `title` (short, the marker label), `note` (optional, longer), actor. Audited (it is a governance statement about the company, so ADR 0023's allowlist gains it). Soft-delete.
- `POST/PATCH/DELETE /api/v1/posture-annotations`, gated `require_posture_assess` — recording what happened to the posture is assessment work, and it avoids a permission for one small table. The timeline read API's `events` list gains `kind = note` entries from it; the page cannot tell derived from authored except by the kind.
- On the page: an "Add note" affordance in the annotations legend row for those who hold the permission; a small dialog (date, title, note). The Timeline stays read-only for everyone else — this is the one write, and it is about the timeline rather than the posture.
- Tests: the read API merges derived and authored events in date order; the write gate.

Deliberately small. If notes want categories or colours, that is a follow-up once someone has written ten.
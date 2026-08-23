---
id: 01M0PSF2H1Q2W5WMPGQDXTQMAB
created: 2026-08-23T07:48:21.153249Z
updated: 2026-08-23T07:48:24.542278Z
type: task
title: Portal annual cost loses its inline Update — amendments are the one path
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 374
sprint: sbph5q5
assignee: steve
label:
- improvement
priority: medium
task_status: todo
---
COM-319 gave owners an inline Add/Update on the portal's Annual Cost row — a conditional direct write (straight through under the thresholds, an `amend_engagement` request over them). Decided: remove it. **Request an amendment is the single way an owner changes the cost**, like every other rule-relevant engagement field.

- [ ] Frontend: remove the portal-side inline edit of annual cost from `EngagementsCard` (the Add/Update affordance and its threshold-explanation states). The figure stays displayed; the amendment button beside the engagement is the change path.
- [ ] Backend: retire the narrow `PATCH /portal/vendors/{id}/engagements/{id}` cost route — with no UI calling it, an owner-writable rule-relevant field with no surface is attack area, not convenience. Its threshold logic (project + `required_area_ids`) predates it and stays, since amendments are what use it.
- [ ] ADR 0040 trail: the amendment that recorded this as "the fifth owner-gated write — a new kind, conditional because the rules read it" gets a follow-up amendment (append-only): the fifth write is withdrawn, the kind it named turned out to be better served by the existing amendment flow. The tally goes back to four.
- [ ] The revision + activity-log line COM-319 added for cost changes moves with the writer: amendments already record what the approvers judged, verify the applied amendment still logs the old → new figure.
- [ ] Tests: portal payload/UI shows no edit affordance for owners; the retired route is gone (405/404); an amend_engagement request remains the working path for a cost change end-to-end.
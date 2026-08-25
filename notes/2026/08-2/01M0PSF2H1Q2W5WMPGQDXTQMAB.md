---
id: 01M0PSF2H1Q2W5WMPGQDXTQMAB
created: 2026-08-23T07:48:21.153249Z
updated: 2026-08-25T18:43:23.578465Z
type: task
title: Portal annual cost loses its inline Update — amendments are the one path
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 374
sprint: sbph5q5
comments:
- id: 01M0Q3XM2BF00W33MZ77W5NG0J
  author: Steve Vine
  at: 2026-08-23T10:51:03.627029Z
  text: |-
    Done — PR #383, merged to main as 87c8ba3.

    The inline Add/Update is gone from `EngagementsCard`; the figure stays displayed as a read like every other engagement field, and the amendment button beside the engagement is the change path. `PATCH /portal/vendors/{id}/engagements/{id}` is retired with its schemas and its private helpers; `as_projected` + `required_area_ids` stay untouched, since amendments are what use them.

    On the audit bullet — you asked me to verify the applied amendment still logs old → new. **It did not log anything.** `apply_amendment` returned a bool, and `vendor_engagements` is not an audited table, so an approved amendment moved the same figure with no record of what it had been. It now returns `{field: (was, now)}` and an approved amendment writes one `ActivityLog` line carrying every before → after. So the line did not just move — this closes a gap COM-319's own reasoning had left open on the other path.

    ADR 0040 has the follow-up amendment: the fifth write is withdrawn, the tally is back to four, and it records that nothing in COM-319's reasoning was wrong — the objection is surface, not correctness.

    Tests: the retired route answers 404/405 and the portal offers no edit affordance; an `amend_engagement` request is the working path end to end, finishing on the activity line. One incidental fix — `_cost_rule` now returns the approver client it creates, because signing in again with the same address is a unique violation rather than a second session.
assignee: steve
company: null
label:
- improvement
priority: medium
task_status: done
---
COM-319 gave owners an inline Add/Update on the portal's Annual Cost row — a conditional direct write (straight through under the thresholds, an `amend_engagement` request over them). Decided: remove it. **Request an amendment is the single way an owner changes the cost**, like every other rule-relevant engagement field.

- [ ] Frontend: remove the portal-side inline edit of annual cost from `EngagementsCard` (the Add/Update affordance and its threshold-explanation states). The figure stays displayed; the amendment button beside the engagement is the change path.
- [ ] Backend: retire the narrow `PATCH /portal/vendors/{id}/engagements/{id}` cost route — with no UI calling it, an owner-writable rule-relevant field with no surface is attack area, not convenience. Its threshold logic (project + `required_area_ids`) predates it and stays, since amendments are what use it.
- [ ] ADR 0040 trail: the amendment that recorded this as "the fifth owner-gated write — a new kind, conditional because the rules read it" gets a follow-up amendment (append-only): the fifth write is withdrawn, the kind it named turned out to be better served by the existing amendment flow. The tally goes back to four.
- [ ] The revision + activity-log line COM-319 added for cost changes moves with the writer: amendments already record what the approvers judged, verify the applied amendment still logs the old → new figure.
- [ ] Tests: portal payload/UI shows no edit affordance for owners; the retired route is gone (405/404); an amend_engagement request remains the working path for a cost change end-to-end.
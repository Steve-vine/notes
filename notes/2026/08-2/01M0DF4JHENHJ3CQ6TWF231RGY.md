---
id: 01M0DF4JHENHJ3CQ6TWF231RGY
created: 2026-08-19T16:54:41.454551Z
updated: 2026-08-19T22:18:15.796675Z
type: task
title: Edit Request — re-open the original submission, and re-derive which approvals it needs
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 297
sprint: sbph5q5
blocked_by:
- 01M0DF2TEXS5KWVE6YJVCKM60F
- 01M0DF3B1KS8MPR6BK1J5MAQNV
assignee: steve
label:
- feature
priority: medium
task_status: active
---
"Answer the question" often means "I filled the form in wrong". Today the requester cannot change a single thing they submitted — `resubmit` accepts no body, and there is no PATCH route on the request at all. This is greenfield, not a widening.

**Where the original answers actually live**, which is what makes this awkward:

| Section | Landed in | Editable today |
|---|---|---|
| name / website / description | a **live `Vendor` row**, created at submit | no |
| scope / criticality / data types / entities / residency / access / sub-processors | a **live `VendorEngagement` row**, status `proposed` | no |
| contacts | `VendorContact` rows | yes, separately, owner-gated (COM-221) |
| justification | `vendor_onboarding_requests.justification` | no |
| proposed_* (amend kind) | request columns | no |

- [ ] **Two write paths, because the kinds differ.** `new_vendor` / `new_engagement` edit **live rows the register is already showing**; `amend_engagement` edits the request's `proposed_*` columns. One endpoint may serve both, but the difference must be explicit, not discovered.
- [ ] **Re-run the approval fan-out.** This is the one that matters: the required areas are derived from the projected engagement, and an edit can change which areas are required — lowering criticality or dropping a data type could otherwise **dodge an approval area that had already been fanned out**. Re-evaluate on every edit; add newly-required areas; decide deliberately what happens to an area that is no longer required *and has already approved*. Fan-out currently happens only at submission.
- [ ] **Gate it to the info-requested state** and to the requester or an owner, mirroring `resubmit`'s guards (403 for anyone else, 409 outside the state). An edit is not a general-purpose back door into an approved vendor.
- [ ] Editing recomputes the vendor's criticality rollup, as submission does.
- [ ] Editing reopens the loop like a response does (COM-295): approvals to `updated`, approvers re-notified — and the approver needs to see **that the form changed**, not just that something happened. The `AmendmentDiff` component is the nearest existing answer; whether it can serve here is worth checking before inventing a second one.
- [ ] Frontend: an Edit Request modal pre-filled from the live rows, reusing `RequestVendorModal` / `RequestEngagementModal`'s field set rather than a third copy — those two are already deliberately kept identical.
- [ ] **Note for the record**: COM-183 claims an "Edit & resubmit modal pre-filled from the raw stored `answer_json`" shipped. It did not — there is no such component, and nothing has ever written a `VendorFormAnswer` for a request. That claim is why this gap went unnoticed.
- [ ] Tests: each kind's fields round-trip; an edit that raises criticality adds the newly-required area; an edit cannot be made outside `info_requested`; a non-requester non-owner gets 403; the criticality rollup follows.
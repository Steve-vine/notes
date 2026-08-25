---
id: 01M0DF4JHENHJ3CQ6TWF231RGY
created: 2026-08-19T16:54:41.454551Z
updated: 2026-08-25T18:43:28.69435Z
type: task
title: Edit Request — re-open the original submission, and re-derive which approvals it needs
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 297
sprint: sbph5q5
blocked_by:
- 01M0DF2TEXS5KWVE6YJVCKM60F
- 01M0DF3B1KS8MPR6BK1J5MAQNV
comments:
- id: 01M0E5SF56HAF655RME5S9KQ2W
  author: Steve Vine
  at: 2026-08-19T23:30:34.790477Z
  text: |-
    Shipped in PR #292.

    **Two write paths, explicit rather than discovered.** `new_vendor` / `new_engagement` edit the live `Vendor` and `proposed` engagement rows the register is already showing; `amend_engagement` edits the request's own `proposed_*` columns. Sending the wrong half for the kind is a 422, not a silent no-op. `_proposed_columns()` now takes the amendment payload rather than the whole create body, so submission and the edit share one mapping.

    **Re-running the fan-out is the load-bearing part.** `refan_out_approvals()` re-evaluates on every edit. What goes is deliberately **not symmetric**: an area no longer required that has *not* decided is removed (it would block the request forever); one that has *already approved* stays (deleting it would destroy the record of a decision somebody made, and a surplus approval is harmless where a missing one is not).

    **One deliberate departure from the task, worth knowing about:** it said to gate the edit to `info_requested`, but `updated` did not exist when it was written — COM-294 added it earlier this sprint — and after an edit the request *is* `updated`, so that gate would refuse a second edit. Both statuses mean "queried and not yet re-decided", which is the property the gate is for. `respond` keeps the narrower gate: it answers an outstanding question, and once answered there is none. Both are named constants (`_ANSWERABLE`, `_EDITABLE`) with the reasoning beside them.

    Frontend: `EngagementFields` extracts the field set the two request forms were keeping identical **by hand** (there is a comment asking the next person to keep it that way) — a third hand-maintained copy is more than that convention survives. `EditRequestModal` seeds it from wherever the kind's answers live, including that a null proposal field means "unchanged", so the engagement's value is what was being proposed to keep.

    **Two `autoflush=False` traps**, both caught by tests and now commented: the criticality rollup needs an explicit `db.flush()` to see the edited engagement (submission gets one free from `_new_engagement`'s INSERT), and the outstanding-questions lookup reads loaded objects rather than re-querying.

    Confirmed for the record: COM-183's claim that an "Edit & resubmit modal pre-filled from the raw stored `answer_json`" shipped is **false** — no such component exists, and nothing has ever written a `VendorFormAnswer` for a request.
assignee: steve
company: null
label:
- feature
priority: medium
task_status: done
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
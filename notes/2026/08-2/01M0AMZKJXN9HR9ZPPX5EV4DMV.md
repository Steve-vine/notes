---
id: 01M0AMZKJXN9HR9ZPPX5EV4DMV
created: 2026-08-18T14:39:06.845547Z
updated: 2026-08-18T14:39:06.845547Z
type: task
title: Approval & validation — full object details inline, editable before approving or validating
label: feature
task_status: todo
assignee: steve
priority: medium
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 260
---
Today the approval queue (COM-240) shows a request summary/diff, and validation shows what was provisioned with amendment behind a separate pre-filled form. Both pages should put the **full object in front of the person deciding, editable in place**.

* **Approval page (standard requests — user and group creates especially):** render every field that execution will send to Graph — joiner: UPN, display name, usage location, business role(s) and the resolved group adds, per subject in a batch; group create: name, description, owners, role attachment. The approver can **edit these details before approving** — fixing a typo'd UPN or a woolly description at the gate instead of bouncing the request back.
  * **Maker-checker semantics:** an approver edit is recorded on the request as a visible original→approved diff (who changed what, when) — the requester's submission is never overwritten silently, and the activity log carries the edit. Two people have still shaped and seen the final object: the trail just shows the approver's hand honestly. Requester sees the modified values on the executed request (their History view), not a surprise in the tenant.
  * Execution consumes the **approved** values; batch subjects editable independently.
* **Validation page (expedited + out-of-band items):** same presentation — the full provisioned object as it actually stands (from the mirror/Graph, not just the request), **amendable inline before validating**. Semantics unchanged from COM-239/240: the amendment executes as the linked corrective request through the one write path, then the validation closes the pair — this task moves that flow *into* the page (edit the fields → "Amend & validate" applies + validates in sequence) rather than detouring through a separate form.
* Shared field-editor components between the two pages — same object kinds, same fields, two gates; validation constraints identical to the raise forms (COM-240) so a gate edit can't produce what a request couldn't.
* Backend: approval-time edit endpoint(s) storing the diff on the request (COM-239's entity grows an approved-values/edit-record shape), 422s matching the raise validation, and the executor reading approved values. All still audited.

Refs: COM-239 (request entity + write path), COM-240 (the two pages), COM-244 (out-of-band items on the validation page), ADR 0045 (maker-checker model — the edit-at-the-gate recording keeps its spirit).
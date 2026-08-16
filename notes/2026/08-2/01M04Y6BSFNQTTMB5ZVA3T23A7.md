---
id: 01M04Y6BSFNQTTMB5ZVA3T23A7
created: 2026-08-16T09:24:38.831139Z
updated: 2026-08-16T09:24:47.697417Z
type: task
title: 'Requests tab restructure: single grouped list — request rows with approval sub-rows'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 223
sprint: sbph5q5
assignee: steve
label:
- improvement
priority: medium
task_status: todo
---
Follow-up to COM-216 (2026-08-16): collapse the tab's two tables into one grouped list. The separate requests table goes; the Approvals list becomes the whole tab, grouped by request:

```
[Vendor Name]  [New Vendor]  [Status]  [Date Submitted]  [Submitted by]
    [Area]  [Approver]  [Status]  [Date Approved]  (Review)
    [Area]  [Approver]  [Status]  [Date Approved]  (Review)
```

- [ ] **Parent row = the request**: vendor (linked), kind, derived status pill, submitted date, **submitted by** (requester's name — add to the request payload or resolve via the COM-215 directory).
- [ ] **Sub-row per required approval**: area, **approver** (decided → the decider's name; pending → the area's eligible approver names), status pill, decided date, and a **(Review)** button.
- [ ] **(Review) is a placeholder** — behaviour to be specified (Steve, next); wire it to open the existing request detail modal for now so the row isn't a dead end.
- [ ] Inline Approve (COM-216) stays on pending sub-rows where the user is an approver until Review's definition lands — expected to be absorbed by it.
- [ ] A request whose rules required no areas shows its parent row with a single "no approvals required" sub-line (that's the auto-approve case — don't render it as silently area-less).
- [ ] Keep the COM-216 filters, now over the grouped list: status view (Open default / Approved / Rejected / All), kind, "mine to approve" (shows only requests with a sub-row pending my decision).
- [ ] Row colouring: parent rows highlighted, sub-rows page colour — same scheme as the portal register (COM-217).
- [ ] Backend: extend the COM-216 approvals/requests payloads as needed (submitted-by, eligible approver names) rather than N+1 lookups. OpenAPI regenerated.
- [ ] Tests: grouping, both approver renderings (pending vs decided), no-areas sub-line, filters, colouring.
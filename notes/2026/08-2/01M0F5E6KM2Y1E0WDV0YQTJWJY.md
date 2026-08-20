---
id: 01M0F5E6KM2Y1E0WDV0YQTJWJY
created: 2026-08-20T08:43:40.020894Z
updated: 2026-08-20T08:43:45.339731Z
type: task
title: '''Request a new vendor'' on all three portal tabs — reversing COM-211''s one-place rule'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 310
sprint: sbph5q5
assignee: steve
label:
- improvement
priority: medium
task_status: todo
---
The button sits on **All Vendors** only. Put it on **My Vendors** and **My requests** too, so an employee can ask for a supplier from wherever they happen to be in the portal.

**This deliberately reverses COM-211**, and the code argues against it in three places — so the change is to the reasoning as much as to the markup, and those comments must be rewritten rather than left contradicting the behaviour:

- `PortalVendorsPage.tsx` docstring: *"the button belongs beside the register rather than on My requests, which is purely the tracking view"*
- the inline comment at the button: *"Asking belongs on All Vendors… My Vendors is the follow-along view; its empty state points back rather than duplicating the button"*
- `PortalRequestsPage.tsx` docstring: *"Purely the tracking view (COM-211): raising a request happens on the Vendors page, where the register is"*

COM-211's argument was that not finding a supplier is the moment you want to ask for one, so the button belongs where you were looking. That is still true — it just is not a reason to *withhold* it from the two other places a portal user spends their time, both of which are one click away and neither of which offers any route to asking except going back.

- [ ] **My Vendors** is nearly free: it renders the same `PortalRegister` component with `mine`, and the button is gated `{!mine && …}`. Drop the gate.
- [ ] **My requests** needs the button and `RequestVendorModal` wired in — that page imports neither today.
- [ ] **Two empty states currently point elsewhere** and stop making sense once the button is on the page: My Vendors says *"start on the All Vendors tab"*, My requests says *"Request one from the Vendors page."* Both should offer the action instead of directing to it.
- [ ] **An existing test asserts the absence** — `PortalRequestsPage.test.tsx`, *"is purely the tracking view — raising a request lives on Vendors"*, citing COM-211. It has to be replaced by its opposite, not quietly deleted, so the record shows the rule was changed on purpose.
- [ ] The button is already permission-gated by what renders it; keep `canSubmitVendorRequest` governing all three, so a reader who cannot ask does not see it three times instead of once.
- [ ] Tests: the button appears and opens the modal on all three tabs; a submission from My requests posts to the portal route and lands in the list; a user without `canSubmitVendorRequest` sees it nowhere.

One thing worth a moment's thought before building it: three buttons that open the same modal is three places to keep consistent. If the portal grows a fourth tab this becomes a shell-level affordance — a single action in the portal header, always available — rather than something each page mounts. Not this task, but it is the direction this points.

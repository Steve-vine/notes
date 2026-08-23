---
id: 01M0PTWDCPC75MRCY0CKKYXMSC
created: 2026-08-23T08:13:06.838299Z
updated: 2026-08-23T08:13:12.398304Z
type: task
title: Requests tab header aligns with its neighbours — button inline with the title
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 379
sprint: sbph5q5
assignee: steve
label:
- improvement
priority: medium
task_status: todo
---
On the user portal's Requests tab the **Request a new vendor** button sits below the title (`PortalRequestsPage.tsx:92` title, `:145` a separate `Group justify="flex-end"`); on the Register and My Vendors tabs it is inline with the title (`PortalVendorsPage.tsx:122`: `Group justify="space-between" align="flex-end"` — title left, button right). Make Requests match.

- [ ] `PortalRequestsPage.tsx`: merge the title and button into the same header pattern as `PortalVendorsPage` — `<Group justify="space-between" align="flex-end">` with the `<Title order={2}>` left and the button right; drop the standalone button Group.
- [ ] Both title sites (`:83` and `:92` — the empty and populated states) get the same header so the button doesn't jump between states; the button keeps its `canSubmit` gating.
- [ ] Coordinates with COM-377 (title text becomes "My requests") and COM-378 (descriptor removal) — whichever lands last, the header is one `Group`, one title, one button.
- [ ] Test: button and title render in the same header group on both states.
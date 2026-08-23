---
id: 01M0PTWDCPC75MRCY0CKKYXMSC
created: 2026-08-23T08:13:06.838299Z
updated: 2026-08-23T10:32:16.425947Z
type: task
title: Requests tab header aligns with its neighbours — button inline with the title
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 379
sprint: sbph5q5
comments:
- id: 01M0Q2V6P4MK7X7AXJZ4RTRJEG
  author: Steve Vine
  at: 2026-08-23T10:32:15.81214Z
  text: |-
    Done — PR #382, merged to main as d9985a8.

    The Requests header is now the Register/My Vendors header: one `Group justify="space-between" align="flex-end"`, title left, **Request a new vendor** right, `canSubmit` gating kept. The standalone `Group justify="flex-end"` is gone.

    Because the action became page-level, `RequestsSection` took over the button, the `RequestVendorModal` and its state, and `MyRequests` takes an `onRequest` callback so the empty state keeps its own call to action — the register does the same (COM-310), so the pair of affordances stays consistent across the three tabs.

    One deviation from the note worth flagging: it asked for the same header at **both** title sites, including the no-company state at `:83`. I left that one as `PortalVendorsPage` has it — title and prompt, no button — because there is no company to raise a request against there, so a button would be broken rather than consistent. "Doesn't jump between states" is satisfied by the populated page, where the header is identical whether the list is empty or full.

    Landed after COM-377 and COM-378, so the header is one Group, one title, one button, as the note asked. Tests cover both states.
assignee: steve
label:
- improvement
priority: medium
task_status: review
---
On the user portal's Requests tab the **Request a new vendor** button sits below the title (`PortalRequestsPage.tsx:92` title, `:145` a separate `Group justify="flex-end"`); on the Register and My Vendors tabs it is inline with the title (`PortalVendorsPage.tsx:122`: `Group justify="space-between" align="flex-end"` — title left, button right). Make Requests match.

- [ ] `PortalRequestsPage.tsx`: merge the title and button into the same header pattern as `PortalVendorsPage` — `<Group justify="space-between" align="flex-end">` with the `<Title order={2}>` left and the button right; drop the standalone button Group.
- [ ] Both title sites (`:83` and `:92` — the empty and populated states) get the same header so the button doesn't jump between states; the button keeps its `canSubmit` gating.
- [ ] Coordinates with COM-377 (title text becomes "My requests") and COM-378 (descriptor removal) — whichever lands last, the header is one `Group`, one title, one button.
- [ ] Test: button and title render in the same header group on both states.
---
id: 01M0ZE2K8Y5BZ252FQJASFGAAR
created: 2026-08-26T16:22:27.870903Z
updated: 2026-08-26T16:25:41.289114Z
type: task
title: The portal's Actions and Notifications pages sit inside the Vendors module, and one reader cannot open them at all
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 432
sprint: sbph5q5
assignee: steve
company:
- moneypenny
label:
- bug
priority: high
task_status: active
---
Follow-up to COM-411 and COM-412. Both pages were added in the wrong place in the portal's route tree, which shows up two ways — one cosmetic, one not.

## What the reader sees

**The vendor tab bar appears above them.** Open Actions or Notifications in the portal and you get Register / My Vendors / My requests across the top, as though you were somewhere inside Vendor Management. Neither page belongs to that module: Actions is everything asked of you across every module, and Notifications is everything that has happened.

**A recertification reviewer cannot open either page.** This is the serious half and it has not been seen yet, because it needs an account holding `recertifier` and nothing else. The sidebar shows both entries — they are deliberately ungated — and clicking either one lands on the portal's "you need Portal vendor access" refusal.

That is precisely backwards. ADR 0055 §5 exists *for* recertification reviewers and vendor owners: they hold no module role between them, which is why the internal queue never reached them. Building them a page and then gating it on the vendor register repeats the mistake one screen further on.

## Implementation

`App.tsx`. Both routes were nested inside `<Route element={<PortalVendorsSection />}>`, which is what renders the tab bar, and that block sits inside `<RequireSection section="Portal" />`, which reads `canReadPortalVendors` — a permission the recertifier is **deliberately** excluded from (ADR 0047 §6; the comment on `canReadPortalVendors` says so).

They should sit where `portal/recertifications` sits: inside `PortalProtectedLayout`, outside both the vendors layout route and `RequireSection`. That file already carries the reasoning for why recertification is outside the gate — the same argument covers these two, and is worth pointing at rather than restating.

Nothing changes server-side. `GET /portal/actions` is `require_portal_read`, which *does* admit a recertifier, and the rows are scoped to the caller. The bug is entirely in which shell the route is nested in.

## Tests

`PortalRouting.test.tsx` is the right home. A `recertifier`-only account reaches `/portal/actions` and `/portal/notifications` and is not bounced; neither page renders the Register / My Vendors / My requests tabs; a `vendor_user` still gets the tab bar on `/portal/vendors` and still does not on Actions.

Worth adding the recertifier case to whatever asserts the portal nav, too — the entry being ungated while the route was gated is exactly the gap that let this through.
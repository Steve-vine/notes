---
id: 01M0ZE2K8Y5BZ252FQJASFGAAR
created: 2026-08-26T16:22:27.870903Z
updated: 2026-08-26T18:28:12.254547Z
type: task
title: The portal's Actions and Notifications pages sit inside the Vendors module, and one reader cannot open them at all
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 432
sprint: sbph5q5
comments:
- id: 01M0ZK0PSZEQY640E5W5Z9B310
  author: Steve Vine
  at: 2026-08-26T17:48:48.831631Z
  text: |-
    Done — PR #417, merged to main.

    Both routes moved out of the Vendors module: the tab bar is gone from Actions and Notifications, and a recertification reviewer can now open them at all.

    The gate half was the one that mattered. `RequireSection section="Portal"` reads the *vendor* permission, which a recertifier is deliberately excluded from — so they saw both sidebar entries and got refused on clicking either. They're now ungated for the same reason Recertifications is: the API is the boundary. `/portal/actions` returns only rows assigned to the caller and the feed is self-scoped, so an account with nothing of its own gets an empty list rather than a refusal.

    I confirmed the three new tests fail against the old routing before keeping them — a test that passes either way is worth nothing. The fourth checks the other direction: `/portal/vendors` still draws its tab bar, so moving those two routes out didn't take it from the pages it belongs to.

    One thing fixed in passing. `expectNoInternalNav` is the assertion behind the portal's "never renders the internal navigation" guarantee, and it still listed Library and Company — which COM-413 renamed to Playbook and Posture. Two of its six checks had quietly stopped guarding anything. A tripwire naming labels that no longer exist always passes, which is the worst state for one to be in.
assignee: steve
company:
- moneypenny
label:
- bug
priority: high
task_status: done
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
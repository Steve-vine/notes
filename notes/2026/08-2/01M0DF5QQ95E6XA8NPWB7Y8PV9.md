---
id: 01M0DF5QQ95E6XA8NPWB7Y8PV9
created: 2026-08-19T16:55:19.529552Z
updated: 2026-09-01T13:55:51.362556Z
type: task
title: The transcript box on the vendor record — permanent, and owner-gated on the portal
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 299
sprint: sbph5q5
blocked_by:
- 01M0DF3B1KS8MPR6BK1J5MAQNV
comments:
- id: 01M0E5TEKDD900H07F68FTM33D
  author: Steve Vine
  at: 2026-08-19T23:31:06.989166Z
  text: |-
    Shipped in PR #294 — the last task of the sprint.

    `TranscriptCard`, last in the card stack, spanning every request the vendor has had, grouped by request (kind + date), messages oldest-first with author and timestamp. Read-only on both surfaces: asking happens where deciding happens (`ReviewModal`), answering in Progress (COM-298) — a third place to type would be a third place for the conversation to diverge. A vendor nobody ever queried renders nothing rather than an empty box; a message whose author's account is gone reads as "a departed colleague".

    **Portal: owners only, enforced at the route.** The `PortalContactsCard` idiom with the difference that matters — ownership gates *visibility*, not editability. A non-owner sees no card, and `GET /api/v1/portal/vendors/{id}/messages` answers them 403; hiding it in the browser alone would be an access rule a page-source read defeats. My Vendors lands on the same page as All Vendors, so the gate is what separates them, not the route.

    **Recorded as an ADR 0040 amendment** (`decisions/0040-vendor-portal.md`). The three previous amendments all let an owner *write* something narrow; this is the first that *withholds* part of the record from a portal reader. The reasoning: everything else on that page is published to every employee, which is the point of the register, but correspondence names who doubted what and belongs to the people accountable for the supplier. The amendment also states the consequence — a portal user's view is no longer "the internal record minus the buttons"; it is that, minus the correspondence, plus three owner-gated writes, and anything added to the page from here has to say which it is.
assignee: steve
label:
- feature
priority: medium
task_status: done
---
Follows COM-295. The exchange outlives the request it happened in: why a vendor was queried, what was answered, and by whom is exactly what someone asks a year later at review time. A box at the **bottom of the vendor record**, spanning every request that vendor has had.

- [ ] **Internal vendor detail page** — a Transcript card last in the card stack, grouped by request (kind + date), messages oldest-first with author and timestamp. Read-only: it is a record, not a second composer. Asking happens where deciding happens (`ReviewModal`); answering happens in Progress (COM-298).
- [ ] **Portal vendor record, owners only** — the `PortalContactsCard` idiom (`canEdit={useIsVendorOwner(vendor)}`), except here ownership gates *visibility*, not editability: a non-owner employee sees no card at all. Reached from **My Vendors**, which lands on the same `PortalVendorDetailPage` as All Vendors — so the gate is what separates them, not the route.
- [ ] **Record it as an ADR 0040 amendment.** That page's docstring already enumerates its three sanctioned exceptions to "the whole record renders read-only" (Requests, Ownership, Contacts). This is a fourth, and the first that **hides** something from a portal reader rather than letting an owner write. Do not let it land as an undocumented access rule.
- [ ] A message from a **deleted account** renders as a departed user — the author FK is `SET NULL`.
- [ ] Empty state: a vendor that was never queried shows no card rather than an empty box.
- [ ] Tests: an owner sees the card on the portal and a non-owner does not; the internal card renders for managers; grouping across two requests on one vendor; the departed-author rendering.
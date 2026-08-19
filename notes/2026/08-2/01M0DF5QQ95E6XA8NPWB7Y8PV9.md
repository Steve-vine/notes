---
id: 01M0DF5QQ95E6XA8NPWB7Y8PV9
created: 2026-08-19T16:55:19.529552Z
updated: 2026-08-19T16:55:19.529552Z
type: task
title: The transcript box on the vendor record — permanent, and owner-gated on the portal
task_status: todo
assignee: steve
label: feature
priority: medium
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 299
---
Follows COM-295. The exchange outlives the request it happened in: why a vendor was queried, what was answered, and by whom is exactly what someone asks a year later at review time. A box at the **bottom of the vendor record**, spanning every request that vendor has had.

- [ ] **Internal vendor detail page** — a Transcript card last in the card stack, grouped by request (kind + date), messages oldest-first with author and timestamp. Read-only: it is a record, not a second composer. Asking happens where deciding happens (`ReviewModal`); answering happens in Progress (COM-298).
- [ ] **Portal vendor record, owners only** — the `PortalContactsCard` idiom (`canEdit={useIsVendorOwner(vendor)}`), except here ownership gates *visibility*, not editability: a non-owner employee sees no card at all. Reached from **My Vendors**, which lands on the same `PortalVendorDetailPage` as All Vendors — so the gate is what separates them, not the route.
- [ ] **Record it as an ADR 0040 amendment.** That page's docstring already enumerates its three sanctioned exceptions to "the whole record renders read-only" (Requests, Ownership, Contacts). This is a fourth, and the first that **hides** something from a portal reader rather than letting an owner write. Do not let it land as an undocumented access rule.
- [ ] A message from a **deleted account** renders as a departed user — the author FK is `SET NULL`.
- [ ] Empty state: a vendor that was never queried shows no card rather than an empty box.
- [ ] Tests: an owner sees the card on the portal and a non-owner does not; the internal card renders for managers; grouping across two requests on one vendor; the departed-author rendering.
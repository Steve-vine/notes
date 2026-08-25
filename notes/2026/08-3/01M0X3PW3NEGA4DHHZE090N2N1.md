---
id: 01M0X3PW3NEGA4DHHZE090N2N1
created: 2026-08-25T18:42:49.077873Z
updated: 2026-08-25T19:18:15.678887Z
type: task
title: A vendor's page reads the same in the portal as it does internally
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 406
sprint: sbph5q5
assignee: steve
company:
- moneypenny
label:
- improvement
priority: medium
task_status: active
---
The same vendor, opened from the portal and opened internally, is laid out
two different ways. It should be one page people learn once.

## What changes for the reader

On the portal vendor page:

- **Owners move into Details.** Who owns this vendor is one of the facts about
  it, not a separate box below. The standalone "Ownership" card goes; its two
  controls — adding colleagues as additional owners, and handing the vendor
  over — move inside Details, still shown only to an owner (COM-222 is
  unchanged in who may do it, only in where the control sits).
- **Contacts come straight after Details**, then **Engagements**, then
  **Assurance**, then **Flags**, then **Linked risks** — the internal order
  (COM-384): who we deal with and what we buy, then how well we're covered for
  it, then the judgements on it.
- **Assessments get their own tab**, between Details and Reviews, exactly as
  internally (COM-355). One home, not two — the card leaves the Details stack
  rather than appearing in both.

Reviews and History are already the same on both and don't move.

## Deliberately still different

Three things stay portal-only and are not part of this alignment:

- No **Danger zone** — purging a vendor is an internal, admin-only act (COM-350).
- **Transcript** is owner-only here and hidden from everyone else (COM-299).
- **Contacts** and **Engagements** are writable by an owner from the portal
  (COM-221, COM-288); internally they follow `canWriteVendors`.

Everything else on the portal page stays read-only.

## Implementation

`app/frontend/src/pages/PortalVendorDetailPage.tsx`:

- Add `assessments` to `useTabParam` and to the tab list, in the position
  `VendorDetailPage` uses; move `<AssessmentsCard vendor canEdit={false} />`
  into that panel.
- Reorder the Details panel to: `LifecycleCard`, `DetailsCard`,
  `PortalContactsCard`, `EngagementsCard` (portal), `AssuranceCard`,
  `FlagsCard`, `LinkedRisksCard`, `PortalTranscriptCard`.
- Drop `<OwnershipCard>` and its import.

`app/frontend/src/vendors/detail/cards.tsx`:

- `DetailsCard` already resolves and renders the owner name for both surfaces.
  Fold the additional-owners `MultiSelect` and the transfer-ownership `Select`
  from `OwnershipCard` into it, gated as they are now (`useIsVendorOwner` for
  the first, main-owner-only for the second) — so an internal reader, who is
  neither, sees the card exactly as it renders today.
- Retire `OwnershipCard` once nothing imports it.

Update `PortalVendorDetailPage.test.tsx` (tab set, card order, assessments no
longer on the Details tab) and any `OwnershipCard` tests that move with the
controls. No API change — the portal already serves everything both layouts
read.

Note that the page docstring lists the four cards that depart from ADR 0040's
read-only rule; the ownership one now names Details rather than a card of its
own.

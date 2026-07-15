---
id: 01KXK82WEMNSKKTEVRYG9N4FAP
created: 2026-07-15T15:59:47.156809497Z
updated: 2026-07-15T16:00:11.751593272Z
type: task
title: 'Frontend: Vendors section + register page'
assignee: steve
priority: medium
task_status: backlog
label:
- brief
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 171
sprint: s1lenxu
---
The new Vendors sidebar section and the vendor register (list) page, modelled on `RisksPage.tsx` (ADR 0039 §9).

- [ ] `nav.ts`: add `'Vendors'` to `NavSection`/`NAV_SECTIONS` (between Company and Admin) + a Vendors `NavItem` (`/vendors`, IconBuildingStore or similar).
- [ ] Routes in `App.tsx`: `/vendors` + `/vendors/:id` gated by `RequireSection` on the vendor permissions; add paths to the Placeholder exclusion list.
- [ ] `src/vendors/hooks.ts` (react-query v5, the `risk/hooks.ts` conventions: company-scoped query keys, mutations invalidate + `meta.successMessage`).
- [ ] `VendorsPage.tsx`: table (name, state, compliance status, criticality, flags, owner), filters (state/status/criticality/flag), "New vendor" modal gated on canWriteVendors, row links to detail; no-company guard.
- [ ] `statusColors.ts`: keys for the five states + four compliance statuses; reuse `StatusPill`.
- [ ] `npm run generate:api`; type aliases in `src/api/client.ts` (`Vendor`, `VendorCreate`, `VendorUpdate`, `VendorFlag`).
- [ ] Vitest: list renders with pills/links, create POST body captured, action hidden from read-only roles.

Branch `feature/com-<id>-vendors-list-ui`. Ref: ADR 0039 §9, ADR 0017.
---
id: 01KXK82WEMNSKKTEVRYG9N4FAP
created: 2026-07-15T15:59:47.156809497Z
updated: 2026-07-15T21:21:15.062150182Z
type: task
title: 'Frontend: Vendors section + register page'
assignee: steve
priority: medium
task_status: review
label:
- brief
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 171
blocked_by:
- 01KXK82G1Z8AX0CJQ5JRCHA9PB
sprint: s1lenxu
---
The new Vendors sidebar section and the vendor register (list) page, modelled on `RisksPage.tsx` (ADR 0039 §9).

- [x] `nav.ts`: `'Vendors'` added to `NavSection`/`NAV_SECTIONS` (between Company and Admin) + a Vendors `NavItem` (`/vendors`, IconBuildingStore); `AppLayout` shows the section on `canReadVendors`.
- [x] Routes in `App.tsx`: `/vendors` + `/vendors/:id` gated by `RequireSection section="Vendors"` (new gate on `canReadVendors`); `/vendors` added to the Placeholder exclusion list (`/vendors/:id` stays a Placeholder until COM-172).
- [x] `src/vendors/hooks.ts` (react-query v5, the `risk/hooks.ts` conventions): `useVendors` (company-scoped keys + state/status/criticality/flag filters), `useVendor`, `useCreateVendor` (`meta.successMessage`), `useUpdateVendor`, `useVendorFlags`.
- [x] `VendorsPage.tsx`: table (name, state, compliance status, criticality, flags, owner), filters (state/status/criticality/flag), "New vendor" modal gated on `canWriteVendors`, row links to detail; no-company guard; empty state.
- [x] `statusColors.ts`: keys for the five states + four compliance statuses; `StatusPill` reused (criticality reuses the risk-band colours).
- [x] API types regenerated (offline OpenAPI dump); aliases in `src/api/client.ts` (`Vendor`, `VendorCreate`, `VendorUpdate`, `VendorRevision`, `VendorFlag` + flag Create/Update).
- [x] Vitest: list renders with pills/flag badge/links, create POST body captured, action hidden from read-only roles, company-scoped query (4 tests; suite 164 green).

Branch `feature/com-171-vendors-list-ui`, PR #162. Ref: ADR 0039 §9, ADR 0017.
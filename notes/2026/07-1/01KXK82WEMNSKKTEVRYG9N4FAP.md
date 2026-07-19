---
id: 01KXK82WEMNSKKTEVRYG9N4FAP
created: 2026-07-15T15:59:47.156809497Z
updated: 2026-07-15T21:30:55.074068733Z
type: task
title: 'Frontend: Vendors section + register page'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 171
sprint: s1lenxu
blocked_by:
- 01KXK82G1Z8AX0CJQ5JRCHA9PB
comments:
- id: 01KXKTFYFF6WR2CF28Q5BZRVMM
  author: Steve Vine
  at: 2026-07-15T21:21:29.583033099Z
  text: |-
    Build complete on feature/com-171-vendors-list-ui; PR #162 open against main, branch merged to staging.

    **What was done**
    - Vendors becomes the fourth gated sidebar section: nav entry (IconBuildingStore), AppLayout visibility + RequireSection route guard both keyed on canReadVendors, /vendors register route (+/vendors/:id placeholder until COM-172).
    - vendors/hooks.ts with the risk-hooks conventions; VendorsPage with the four filters, StatusPill lifecycle/compliance/criticality, flag badges in the flag's own colour, owner column, New-vendor modal gated on canWriteVendors.
    - statusColors gains the five state + four compliance keys; schema.d.ts regenerated offline (the create_app().openapi() dump — note: strip the structured-logging lines before feeding it to openapi-typescript); client.ts type aliases added.
    - 4 Vitest tests; full suite 164 green; tsc/ESLint/Prettier/production build all pass.

    **Problems encountered**
    - `tsc -b` (build) caught that AppLayout's sectionVisible map needed the new Vendors key — plain `tsc --noEmit` had passed because Vitest/dev don't project-build; fixed and covered by the build gate.
    - jsdom can't open Mantine Select dropdowns (no existing test does), so the filter test asserts the company-scoped query instead of driving the dropdown; list assertions are scoped to the table because Mantine renders option nodes that share label text.

    **Decisions made on the fly**
    - /vendors/:id routes to a Placeholder ("arriving next brief") so register row links work today and COM-172 swaps the element in place.
    - VendorRevision + flag Create/Update aliases exported now so COM-172 needs no client.ts churn.
- id: 01KXKV16Q2100NH3SKCSYFA5K9
  author: Steve Vine
  at: 2026-07-15T21:30:55.073930393Z
  text: 'Released: PR #162 squash-merged to main as c7f0518 (COM-171: Vendors section + register page). Main-push CI (test suite + production deploy) triggered; feature branch deleted. Marking Done.'
assignee: steve
label:
- brief
priority: medium
task_status: done
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
---
id: 01KZKCYFXWJKTCWP0JED5RA3E9
created: 2026-08-09T13:56:09.788039Z
updated: 2026-08-09T13:56:35.0228Z
type: task
title: Portal shell + read-only register & vendor detail
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 194
sprint: sw3i5is
blocked_by:
- 01KZKCXK0QJYJBDT7JQBMKN37J
assignee: steve
priority: medium
task_status: todo
---
The portal's front end: a separate shell at `/portal/*` with a read-only vendor register and vendor detail. ADR 0040.

---

## Agreed work (planned with Claude, 2026-08-09)

**Scoping decisions (Steve):**
- **Separate shell**, not a fifth sidebar section — header only (compass mark, "Vendor Portal", `CompanySwitcher`, `NotificationBell`, `UserMenu`), tabs Vendors / My requests. No `NAV_ITEMS`, no global search box.
- A portal-only user lands on `/portal`, never `/dashboard`; internal users reach the portal by URL.
- **History = revisions only.** `ActivityHistory` already renders nothing for non-admins, so the tab needs no change beyond showing `vendor_revisions`.
- Detail shows lifecycle, details, assurance, certifications, flags, engagements, reviews, revisions. **No** Assessments card, **no** Linked Risks card, **no** review Actions.

**Checklist:**
- [ ] `components/PortalLayout.tsx` — the minimal AppShell above.
- [ ] `App.tsx` — `/portal` + `/portal/vendors/:id` under `RequireSection section="Portal"`; the index redirect resolves to `/portal` when the user's only capability is portal access.
- [ ] `auth/hooks.ts` — `permissionsFor` gains `canAccessPortal`; `auth/RequireSection.tsx` gains a `Portal` entry with a sensible refusal message.
- [ ] `admin/UsersSection.tsx` — add `{ value: 'vendor_portal', label: 'Vendor Portal' }` to the role picker (line ~26).
- [ ] **Reuse over duplication**: `VendorDetailPage.tsx` is 1488 lines of card components. Extract the read-only bodies (Lifecycle, Details, Assurance, Certifications, Flags, Engagements, Reviews, Revisions) into `vendors/detail/` taking a `canEdit` prop — the internal page passes `canEdit={canWriteVendors}`, the portal passes `false`. `AssuranceCard.tsx` / `AssessmentsCard.tsx` already have this shape; follow it.
- [ ] `pages/PortalVendorsPage.tsx` — register with the same filters and `StatusPill`s as `VendorsPage`, reading `/api/v1/portal/vendors`.
- [ ] `pages/PortalVendorDetailPage.tsx` — Details / Reviews / History tabs, all read-only.
- [ ] Regenerate `schema.d.ts` (strip stdout log lines before piping to `openapi-typescript`).
- [ ] Tests: `permissionsFor` for the new role, the `RequireSection Portal` gate, the landing redirect, and the detail cards rendering no edit affordances when `canEdit={false}`.
- [ ] PR to main, merge branch to staging.

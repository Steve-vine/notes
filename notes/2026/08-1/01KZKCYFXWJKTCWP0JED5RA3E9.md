---
id: 01KZKCYFXWJKTCWP0JED5RA3E9
created: 2026-08-09T13:56:09.788039Z
updated: 2026-08-09T14:50:32.037285Z
type: task
title: Portal shell + read-only register & vendor detail
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 194
sprint: sw3i5is
blocked_by:
- 01KZKCXK0QJYJBDT7JQBMKN37J
assignee: steve
priority: medium
task_status: active
---
The portal's front end: a separate shell at `/portal/*` with a read-only vendor register and vendor detail. ADR 0040.

---

## Agreed work (planned with Claude, 2026-08-09)

**Scoping decisions (Steve):**
- **Separate shell**, not a fifth sidebar section — header only (compass mark, "Vendor Portal", `CompanySwitcher`, `NotificationBell`, `UserMenu`), tabs Vendors / My requests. No `NAV_ITEMS`, no global search box.
- A portal-only user lands on `/portal`, never `/dashboard`; internal users reach the portal by URL.
- **History = revisions only.** `ActivityHistory` already renders nothing for non-admins, so the tab needs no change beyond showing `vendor_revisions`.
- **The portal shows the whole vendor record, read-only** (revised 2026-08-09) — Details: lifecycle, details, assurance, certifications, flags, **assessments** (incl. answers viewer), engagements, **linked risks**. Reviews: review history + **review actions**. History: revisions. Nothing editable anywhere: no Add/Complete/Remove buttons, no link/unlink, no state transitions, no flag editing.

**Checklist:**
- [ ] `components/PortalLayout.tsx` — the minimal AppShell above.
- [ ] `App.tsx` — `/portal` + `/portal/vendors/:id` under `RequireSection section="Portal"`; the index redirect resolves to `/portal` when the user's only capability is portal access.
- [ ] `auth/hooks.ts` — `permissionsFor` gains `canAccessPortal`; `auth/RequireSection.tsx` gains a `Portal` entry with a sensible refusal message.
- [ ] `admin/UsersSection.tsx` — add `{ value: 'vendor_portal', label: 'Vendor Portal' }` to the role picker (line ~26).
- [ ] **Reuse over duplication**: `VendorDetailPage.tsx` is 1488 lines of card components. Extract the read-only bodies into `vendors/detail/` taking a `canEdit` prop — Lifecycle, Details, Assurance, Certifications, Flags, Engagements, Assessments, LinkedRisks, Reviews, Actions, Revisions. The internal page passes `canEdit={canWriteVendors}`, the portal passes `false`. `AssuranceCard.tsx` / `AssessmentsCard.tsx` already have this shape; `LinkedRisksCard` and `ActionsCard` are currently inline in `VendorDetailPage.tsx` and need lifting out.
- [ ] Audit each extracted card for `canEdit={false}`: `AssessmentsCard` must hide Add / Complete / Remove and keep the answers viewer; `LinkedRisksCard` must hide link/unlink and "create risk from finding" but keep the risk rows (and **not** deep-link to `/risks/:id`, which a portal user can't open — render the risk inline instead); `ActionsCard` must hide add/edit/delete and keep description, owner, due date and open/done.
- [ ] `pages/PortalVendorsPage.tsx` — register with the same filters and `StatusPill`s as `VendorsPage`, reading `/api/v1/portal/vendors`.
- [ ] `pages/PortalVendorDetailPage.tsx` — Details / Reviews / History tabs, all read-only.
- [ ] Regenerate `schema.d.ts` (strip stdout log lines before piping to `openapi-typescript`).
- [ ] Tests: `permissionsFor` for the new role, the `RequireSection Portal` gate, the landing redirect, and every extracted card rendering no edit affordances when `canEdit={false}` (assessments, linked risks and actions especially — they're the ones with the most buttons to suppress).
- [ ] PR to main, merge branch to staging.

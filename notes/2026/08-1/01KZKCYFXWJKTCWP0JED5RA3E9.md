---
id: 01KZKCYFXWJKTCWP0JED5RA3E9
created: 2026-08-09T13:56:09.788039Z
updated: 2026-08-09T15:15:18.356293Z
type: task
title: Portal shell + read-only register & vendor detail
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 194
sprint: sw3i5is
blocked_by:
- 01KZKCXK0QJYJBDT7JQBMKN37J
comments:
- id: 01KZKHFCGBBFWB3C0VNRH7TZEM
  author: Steve Vine
  at: 2026-08-09T15:15:17.643513Z
  text: |-
    Implemented — PR #186 (branch feature/com-194-portal-shell, stacked on #185).

    **What was done**
    - `components/PortalLayout.tsx` — header-only shell; `App.tsx` routes `/portal` + `/portal/vendors/:id` under `RequireSection section="Portal"`; `LandingRedirect` sends a portal-only account to `/portal`.
    - `permissionsFor` gains `canAccessPortal`; `vendor_portal` added to `canSubmitVendorRequest`; `RequireSection` gains `Portal`; `admin/UsersSection.tsx` gains the role option.
    - `pages/PortalVendorsPage.tsx` + `pages/PortalVendorDetailPage.tsx`.
    - **The extraction**: eleven cards moved out of `VendorDetailPage.tsx` (1488 → 166 lines) into `vendors/detail/cards.tsx`, imported by both pages. `schema.d.ts` regenerated offline.

    **Decisions made on the fly**
    - **A `VendorSourceProvider` context rather than a prop or duplicate hooks.** The two APIs serve identical payloads, so the only difference is the prefix — the read hooks resolve it from context and the shared cards need no changes at all. The surface is part of every query key, or a dual-role user would see one surface's cache on the other.
    - Split into `vendors/source.ts` + `vendors/VendorSourceProvider.tsx`, mirroring the existing `company/context.ts` + `CompanyProvider.tsx` split, to satisfy the fast-refresh lint rule the same way the codebase already does.
    - **`LinkedRisksCard` renders the risk title as text in the portal.** It linked to `/risks/:id`, which a portal user cannot open — the link would have sent them into a refusal.
    - `OnboardingRequests` now sends `kind: 'new_vendor'` explicitly. The server defaults it, but openapi-typescript emits `$ref`+default as required, and the call site should say which kind it is anyway.

    **A real bug found**
    `LandingRedirect` read permissions before the user query settled, so `roles` was `[]` and a **portal-only user was redirected to `/dashboard`** — the exact page the redirect exists to avoid — and stranded, because the redirect had already fired. It showed up as a flaky new test (1 failure in ~3 full runs) before I traced it. Now it waits for the roles, as `RequireSection` does.

    **Tests**: 22 new. They assert absence as much as presence — no edit affordances on any card, no `navigation` landmark in the portal at all, no search box, and **no call to `/api/v1/vendors`** from either portal page. Plus the permission matrix, including `canReadLibrary === false` with a pointer to ADR 0040 §1. Full suite 221 green across repeated runs after the redirect fix; eslint + tsc clean.

    **State**: PR #186 open against main, CI running.
assignee: steve
priority: medium
task_status: review
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

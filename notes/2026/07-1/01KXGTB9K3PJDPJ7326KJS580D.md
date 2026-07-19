---
id: 01KXGTB9K3PJDPJ7326KJS580D
created: 2026-07-14T17:21:13.827675902Z
updated: 2026-07-19T21:30:29.374962988Z
type: task
title: Frontend — role-aware section gating + multi-role user management
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 81
sprint: s29esb7
blocked_by:
- 01KXGTAFEERKCGH742VGRV7N9F
assignee: steve
task_status: done
priority: medium
---
Frontend for M17 — User permissions, consuming the new `me.roles` shape and section model from <issue id="bf248259-35c6-4b68-b432-90e760ec40e2" href="https://linear.app/stevevine/issue/DEV-589/backend-granular-multi-role-model-section-based-authorization-adr">DEV-589</issue>. Design decided in **ADR 0026** (project repo PR #7) — see §3 for the authoritative read/write capability matrix. **Depends on the backend brief.**

The API stays the enforcement boundary (it returns 401/403); the frontend mirrors it — hide sections/affordances a user can't use, never rely on the client for security.

- [ ] **Auth hook** (`auth/hooks.ts`): expose `roles: Role[]` plus capability helpers — `isAdmin`, `canReadLibrary` / `canWriteLibrary` (analyst|viewer / analyst, +admin), `canReadCompany` / `canWriteCompany` (assessor|viewer / assessor, +admin). Single place the UI reads from; mirrors the backend `User` capability helpers (ADR 0026 §4).
- [ ] **Nav gating** (`components/AppLayout.tsx`, `nav.ts`): show a section's items only if the user can **read** it — Overview always; Library iff `canReadLibrary`; Company iff `canReadCompany`; Admin iff `isAdmin` (existing filter). An Analyst-only user sees Overview + Library; an Assessor-only user sees Overview + Company; Viewer sees both (ADR 0026 §2–§3).
- [ ] **Route guards**: a user who deep-links to a section they can't read (e.g. Assessor-only → `/controls`) gets a friendly "no access" view, not a blank page or a raw 403 — mirror the existing `AdminPage`/`ActivityPage` "Admins only" pattern, generalised per section.
- [ ] **Replace per-page** `canEdit` **checks** (currently `role === 'admin' || role === 'editor'`) with the right section write capability:
  - Library → `canWriteLibrary`: `ContentPage`, `ContentDetailPage`, `DecisionsPage`, `DecisionDetailPage`, `FrameworkDetailPage`, `LinkedDecisions`, `ControlDetailPage`.
  - Company → `canWriteCompany`: `RisksPage`, `RiskDetailPage`, `AssessmentPanel`, and the Gaps/Actions/Assessments edit affordances.
- [ ] **Admin Users UI** (`admin/UsersSection.tsx`): replace the single-select `ROLE_OPTIONS` dropdown with a **multi-select** (Admin / Analyst / Assessor / Viewer), require ≥1; show each user's roles as pills in the table; keep the self-edit lockout (role field disabled for the current user). Update create/edit forms + the `UserCreate`/`UserUpdate` calls for a roles array.
- [ ] **Regenerate the OpenAPI client** (`api/schema.d.ts`) so `UserOut.roles` etc. flow through; fix the `User` type consumers.
- [ ] **Tests:** nav renders the right sections per role set (analyst→Library, assessor→Company, viewer→both, admin→all, assessor+viewer→both); deep-link to an unreadable section shows the no-access view; write affordances show/hide per section; Users multi-select round-trips; self-lockout still disables own role edit; `AdminPage`/`ActivityPage` admin-only guard intact.

Refs: **ADR 0026** (the decision — PR #7), 0017 (IA/sections), 0007 (superseded in part).

---
*Migrated from Linear [DEV-590](https://linear.app/stevevine/issue/DEV-590/frontend-role-aware-section-gating-multi-role-user-management) · created 2026-06-23 · completed 2026-06-23*
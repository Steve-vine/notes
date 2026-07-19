---
id: 01KXGTAFEERKCGH742VGRV7N9F
created: 2026-07-14T17:20:47.054317077Z
updated: 2026-07-19T21:30:28.324496479Z
type: task
title: Backend — granular multi-role model + section-based authorization (+ ADR)
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 80
sprint: s29esb7
assignee: steve
task_status: done
priority: medium
---
Backend for M17 — User permissions. Replace the single `role` (admin/editor/viewer, ADR 0007) with **granular, multi-valued roles** enforced by **app section**, gating **both reads and writes** per section. The design is decided in **ADR 0026** (project repo PR #7) — implement to it.

**Roles** (a user may hold more than one):

* **Admin** — unrestricted; everything (incl. existing admin-only: users, companies, activity, reference-data/rubric config).
* **Analyst** — read **+ write** the **Library** section: Domains, Controls, Content, Frameworks (+ crosswalk/mappings, coverage, SoA), Decisions.
* **Assessor** — read **+ write** the **Company** section: Assessments, Gaps, Actions, Risks (+ treatment plans, attachments), Reports.
* **Viewer** — read-only across **Library** and **Company**.
* Everyone authenticated gets the **Overview** section (Dashboard) + cross-cutting endpoints (search, notifications). **Reads are now section-gated** — an Analyst-only user can't read Company, an Assessor-only user can't read Library; reading both needs Viewer (or a second role). Combine roles to widen access (e.g. Assessor + Viewer = write Company, read Library).

Section ownership mirrors `nav.ts` (`NavSection` Overview/Library/Company/Admin, ADR 0017) — keep the API the single source of truth and let the frontend (<issue id="81b25c68-828d-427b-8b46-60a09334ace7" href="https://linear.app/stevevine/issue/DEV-590/frontend-role-aware-section-gating-multi-role-user-management">DEV-590</issue>) consume it. See ADR 0026 §3 for the authoritative read/write capability matrix.

- [X] **ADR 0026** — multi-role, section-based RBAC gating reads + writes; supersedes ADR 0007's AuthZ/roles bullet. Drafted in project repo PR #7 (merge before/with this brief).
- [ ] **Model:** add a `user_roles` **join table** — `(user_id FK, role user_role)`, unique `(user_id, role)` — extend the native `user_role` enum to `admin | analyst | assessor | viewer`, and **drop the single-value** `users.role` **column** (ADR 0026 §5; the enum-array alternative was considered and rejected).
- [ ] **Alembic migration** (next: 0019): create `user_roles`, backfill existing users — `admin→{admin}`, `editor→{analyst, assessor}` (old editor wrote both sections), `viewer→{viewer}` — then drop `users.role`. Re-seed the default admin with `{admin}` (ADR 0026 §6).
- [ ] **Auth helpers** (`core/auth.py`): replace `require_role(*roles)` with section guards — **reads**: `require_library_read` (analyst|viewer|admin), `require_company_read` (assessor|viewer|admin); **writes**: `require_library_write` (analyst|admin), `require_company_write` (assessor|admin); keep `require_admin`. Add `User` capability helpers (`can_read_library`, `can_write_library`, `can_read_company`, `can_write_company`, `is_admin`). Admin satisfies every guard.
- [ ] **Re-gate routers** by section — **GET reads now gated too** (today reads are open to any authenticated user):
  - Library (read + write): domains, controls, content, frameworks, mappings, decisions, coverage, soa.
  - Company (read + write): assessments, assessment_attachments, gaps, actions, risks, risk_treatments, risk_attachments, risk_overview, reports.
  - Open to any authenticated user: dashboard, notifications, tokens (own), auth/me.
  - Stays **admin-only**: users, companies, activity, maturity_levels, risk_rubric.
- [ ] **Cross-cutting search** (`search.py`): filter results to the sections the caller can read (drop Library hits for a Company-only user and vice-versa) so search can't leak unreadable content.
- [ ] **API schemas + users router:** `UserOut`/`me` return `roles: list[Role]`; `UserCreate`/`UserUpdate` accept a roles set (≥1). Preserve the self-lockout guard (an admin can't strip their own admin role/disable themselves).
- [ ] **CLI bootstrap:** update `cli.py create-admin` to assign `{admin}` under the new model.
- [ ] **Tests:** matrix coverage — analyst reads+writes Library, 403 on Company read+write; assessor the reverse; viewer 200 on all reads, 403 on all writes; admin all-access; multi-role union (assessor+viewer) writes Company + reads Library; search results filtered by readable section; editor→{analyst,assessor} backfill; self-lockout guard.

Backend brief first; the frontend brief (<issue id="81b25c68-828d-427b-8b46-60a09334ace7" href="https://linear.app/stevevine/issue/DEV-590/frontend-role-aware-section-gating-multi-role-user-management">DEV-590</issue>) depends on the new `me.roles` shape and the section guards. Refs: **ADR 0026** (the decision), 0007 (superseded in part), 0017 (IA/sections), 0021 (search), 0023 (activity log — admin-only preserved).

---
*Migrated from Linear [DEV-589](https://linear.app/stevevine/issue/DEV-589/backend-granular-multi-role-model-section-based-authorization-adr) · created 2026-06-23 · completed 2026-06-23*
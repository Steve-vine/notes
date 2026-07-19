---
id: 01KXGRBKQKCB9X0K03N3ZWR99V
created: 2026-07-14T16:46:27.05966016Z
updated: 2026-07-14T16:46:53.06788427Z
type: task
title: Frontend app shell
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 9
sprint: s7hkfxa
comments:
- id: 01KXGRC3SDPKPN0GSN6R0ZDFVE
  author: Steve Vine
  at: 2026-07-14T16:46:43.50162772Z
  text: |-
    [Migrated from Linear — Steve Vine, 2026-06-14 14:45 UTC]
    **Done building — moving to In Review.** PR: https://github.com/Steve-vine/compass/pull/8 (all 5 CI checks green). **This is the last M1 brief — merging it completes the walking skeleton.**

    ## What was done
    - **Stack** (your call): Mantine + TanStack Query + react-router + typed client from the OpenAPI schema (openapi-typescript → committed `src/api/schema.d.ts`, openapi-fetch).
    - **Auth**: `useCurrentUser`/`useLogin`/`useLogout`; `RequireAuth` guard; `LoginPage`; authed↔unauthed routing.
    - **App shell** (ADR 0017): left sidebar nav + top bar with the **global company switcher**, a disabled **search slot**, and a **user menu** (logout).
    - **CompanyProvider** loads `/api/v1/companies` and tracks the selected company (persisted).
    - Nav targets are placeholders until their M2+ briefs. Tests: login posts to the API; `RequireAuth` redirect/allow.

    ## Decisions on the fly
    - **`openapi-typescript` run via `npx`, not a dep** — it peer-requires TS 5 but the repo is on TS 6; the generated types are committed and CI never runs generation, so this avoids the conflict cleanly.
    - **`baseUrl: window.location.origin` + a lazy `fetch` wrapper** in the API client — keeps `Request` construction valid under jsdom and lets tests stub `fetch` (openapi-fetch otherwise binds the global at create time).
    - Split the company context/hook out of the provider file to satisfy the `react-refresh` lint rule.

    ## Verification
    - `lint` / `typecheck` / `format:check` / `test` / `build` green in CI and locally.
    - **End-to-end** through the Vite dev proxy against a real backend (Postgres + Redis): unauth `me`→401, login→200 (cookie), `me`→admin, `companies`→`[Default]`.

    ## Acceptance criteria
    - [x] React + TS + Vite app; dev server proxying `/api/*` to the backend
    - [x] Left sidebar + top bar (global company switcher, search slot, user menu)
    - [x] Routing + typed API client generated from the OpenAPI schema
    - [x] Login screen wired to the auth API; authed/unauthed routing
    - [x] Production build served via nginx (unchanged chart path from DEV-396)

    ## Out of scope
    Real screens behind the nav and functional global search → M2+.
- id: 01KXGRCD4BGSEWE3CRMHT00571
  author: Steve Vine
  at: 2026-07-14T16:46:53.067690341Z
  text: |-
    [Migrated from Linear — Steve Vine, 2026-06-14 15:02 UTC]
    **Merged + verified — Done.** Squash-merged as `a6c790c` ([PR #8](https://github.com/Steve-vine/compass/pull/8)); post-merge `release.yml` rebuilt + pushed the frontend + backend images — green.

    🎉 **This completes Milestone 1 — the walking skeleton.** All 8 M1 issues delivered: DEV-389, 396, 390, 391, 392, 393, 394, 395. The two surfaced follow-ups (DEV-416 Celery, DEV-417 email reset) have been moved to M2.
assignee: steve
label:
- brief
priority: medium
task_status: done
---
Build the React app shell per ADR 0003/0017.

- [ ] React + TS + Vite app; dev server proxying `/api/*` to the backend
- [ ] Left sidebar + top bar (global company switcher, search slot, user menu)
- [ ] Routing + typed API client generated from / aligned to the OpenAPI schema
- [ ] Login screen wired to the auth API; authed/unauthed routing
- [ ] Production build served via nginx (port 8080)

Depends on: Auth, Backend API scaffolding. Refs: ADR 0003, 0004, 0017.

---
*Migrated from Linear [DEV-395](https://linear.app/stevevine/issue/DEV-395/frontend-app-shell) · created 2026-06-13 · completed 2026-06-14*  
*Related to (Linear): DEV-389, DEV-417, DEV-416, DEV-396, DEV-394*
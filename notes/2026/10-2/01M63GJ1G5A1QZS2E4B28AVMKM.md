---
id: 01M63GJ1G5A1QZS2E4B28AVMKM
created: 2026-10-29T09:41:17.95798Z
updated: 2026-10-30T08:16:06.870623Z
type: task
title: Scripted browser journeys — a Playwright suite that signs in as each test account and checks every screen and tab in its menu opens without an error screen, a failed request or a blank page, and that each role sees only what it should; runnable by hand against staging
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1449
sprint: s5pn06h
blocked_by:
- 01M63GDH4MVVDEAH924825P8H5
comments:
- id: 01M653MEX8KGQ9G8JQS1BBR34P
  author: Steve Vine
  at: 2026-10-30T00:33:54.600461Z
  text: |-
    Built — PR #1467 (auto-merge on).

    - app/e2e/: Playwright 1.64.1, TypeScript strict, ESLint and Prettier as the frontend has them. The PR's frontend job lints and type-checks it; no new required check.
    - "Every screen opens": for each account (Admin B skipped, same role as A), the suite clicks every entry in the app's own menu and every tab. A screen fails on an error screen, "Not found", a heading over nothing, a failed API request, or a console or uncaught error. Each failing screen gets a screenshot, and the run keeps a trace.
    - Roles: the Viewer has no Raise gap / New risk / New vendor / New control, while Admin A does. Each role's menu has what it should. The portal-only account is turned away from the internal app. The vendor portal refuses a visitor without a link.

    Results against staging, 2026-10-30 ~00:30 GMT:
    - 7 accounts, 101 screens and 95 tabs, in 4.6 min.
    - Roles: 12 of 12 pass.
    - A screen broken on purpose (E2E_BREAK=/api/v1/domains) goes red with a screenshot.
    - Every-screen is red on two real defects, now logged in this sprint: COM-1454 (Continuity blank for Viewer and Assessor) and COM-1455 (portal Vendors asks for flags a portal person can't read).

    Changes from the plan:
    - One browser at a time, not two. With two, both walking Frameworks starved staging's API until Kubernetes restarted it (logged as COM-1456).
    - Sign-in uses the API in the suite's own setup, not COM-1448's saved sessions (COM-1448 ended up not needing any).
    - The screen list is read from the live menu by clicking, because the menu entries are buttons, not links. A new screen is still covered automatically.
    - Aside, not logged: when Domains fails to load, it shows "0 shown" rather than an error message.
assignee: steve
label:
- feature
priority: medium
task_status: done
---
Sprint 99, Browser Testing (ADR 0135, COM-1446). Needs the test accounts (COM-1447).

## What it checks

For each test account, it opens **every screen in that account's menu, and each tab**, and checks that:
- no error screen appears ("Something went wrong");
- no request to the API fails;
- nothing is written to the browser console as an error;
- the page has its heading and isn't blank.

It also checks what each role **shouldn't** see:
- the viewer gets no Add or Edit buttons on the registers;
- portal accounts can't open the internal app;
- an account without a module doesn't see it in the menu.

This is the "deep smoke" layer. It catches a screen that's broken for one role, or that only breaks once deployed. New screens are covered automatically, because the screen list comes from the app's own menu rather than a hand-kept list.

## Notes (technical)

- A new package at `app/e2e/`: Playwright pinned to an exact version, TypeScript strict, ESLint and Prettier as the frontend has them.
- **Fixtures:**
  - sign-in per account, from the saved sessions (COM-1448's helper) or the secrets file;
  - a **company guard** that asserts the current company is E2E Test Company before any test that changes data;
  - a naming helper: `E2E <run stamp> …`.
- **Screen list** derived from `components/nav.ts`, `portalNav.ts` and the routes in `App.tsx`. Routes with an id parameter use a record found from the register page.
- Keep a screenshot and a Playwright trace on failure. Aim for under 5 minutes with 2 workers, because g5 also runs CI.
- **PR suite:** lint and type-check `app/e2e/` inside the existing frontend job, without running it. Don't add a job: that would change main's required checks list (COM-1111).

**Chain:** independent (no migration or API change).

**Done when:**
- `npx playwright test` from g5 runs green against staging for every test account;
- it goes red, with a screenshot, when a screen is broken on purpose in a local run.
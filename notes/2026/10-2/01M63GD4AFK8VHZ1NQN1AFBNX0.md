---
id: 01M63GD4AFK8VHZ1NQN1AFBNX0
created: 2026-10-29T09:38:37.00747Z
updated: 2026-10-29T09:38:37.00747Z
type: task
title: 'ADR: browser testing — Claude tests staging through the screens: a test company with no live connections, test accounts per role, a browser Claude drives for a pre-UAT pass, and scripted journeys after every staging deploy; staging only, Steve keeps sign-off'
label: brief
assignee: steve
priority: high
task_status: todo
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1446
---
Sprint 99, Browser Testing. Builds on:
- ADR 0016 (pragmatic, risk-based testing);
- ADR 0041 (trunk-based CI/CD; staging is a pointer; fix forward);
- ADR 0007 (local accounts with passwords);
- ADR 0067 (roles are editable rows);
- ADR 0009 (one shared user base across companies).

Write `decisions/0135-browser-testing.md`, and add a testing section to `brief/ways-of-working.md`.

## Why (Steve, 2026-10-29)

Testing today stops at the code. Every PR runs the unit, integration and regression suites, but the staging smoke check only confirms the app is up. Nothing goes through the screens except Steve. With a browser, Claude can cover smoke testing, exploratory testing and a first pass at UAT.

## What the ADR decides

1. **Staging only.** Never production.
2. **A test company with no live connections**: no Microsoft 365 / Entra, Active Directory, AWS, Azure, GCP or scanner connection. Nothing done in it can reach a real system. Staging mail already goes to the mail catcher, so no email leaves.
3. **Test accounts** are ordinary Compass sign-ins (username and password), one per role worth testing. There are **two administrators**, so "nobody approves their own" can be tested end to end. There are also accounts for the vendor portal and the user portal.
4. **Every journey works in the test company**, and checks it is there before changing anything. Shared Playbook records it creates are named "E2E …". It never edits Playbook records it didn't create.
5. **Two ways of using the browser:**
   - **Interactive**: Claude drives a browser on g5 for exploratory checks and a pre-UAT pass on each sprint.
   - **Scripted**: fixed journeys that run after every staging deploy, as a deep smoke test and UI regression.
6. **Scripted journeys are not a PR gate in this sprint.** A failure turns the staging deploy red, and it's fixed forward as usual. Making them a PR gate is a later decision.
7. **UAT sign-off stays with Steve.** Claude's pass means what reaches him already works.

## My calls (for Steve to overturn)

- **Test accounts can still see other companies**, because there's one shared user base (ADR 0009). The safeguard is the journey's company check plus the test company having no connections. It is not a hard restriction on the accounts. "This account can only open these companies" would be a feature, and can follow if wanted.
- **Test passwords live outside the repo**: on g5 in a file only Steve's user can read, and as GitHub Actions secrets for the deploy job.
- **Test data builds up** in the test company. There's no automatic clean-up this sprint; records carry "E2E" and a run stamp so they're easy to spot.
- **Chromium only.** Other browsers can come later.
- **Runs are kept small and come after deploys**, because g5 also runs CI.

**Chain:** independent (docs only).

**Done when:** ADR 0135 is merged and Steve has read the calls above.
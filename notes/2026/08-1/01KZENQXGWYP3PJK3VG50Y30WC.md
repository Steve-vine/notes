---
id: 01KZENQXGWYP3PJK3VG50Y30WC
created: 2026-08-07T17:53:39.356876Z
updated: 2026-08-07T17:59:41.258168Z
type: task
title: 'Breakglass slice 4: the screen — pending-request modal and armed banner (ADR 0089)'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 614
sprint: snk16ew
assignee: steve
priority: medium
task_status: backlog
---
Slice 4 of 4 of the breakglass build (split from ISE-592, which carries slice 1).

**Arming happens in the app — the screen IS the step-up ceremony.** This slice is what makes the whole design work: an MCP bearer token can request a window and can never open one, and the reason it cannot is that opening one requires an interactive, SSO-authenticated session standing on this screen.

- **Incident screen: pending-request modal.** Shows who asked and when; requires a **reason** (free text) and a **duration in minutes, max 120**. Self-approval is deliberate — do not build an approver picker.
- **Armed banner with a live countdown** on the incident screen, plus a Disarm control. State this consequential is a screen element, not a log line (pane-of-glass rule).
- The banner must be honest when the window ends underneath it: expiry is applied lazily server-side, so the UI needs to reconcile rather than count down past zero. `breakglass.remaining_seconds()` floors at zero for exactly this.
- HTTP endpoints for arm/disarm on the incident, if slice 1 or 2 has not already added them.
- Nothing here is offered to a user without the grant.

Playwright rig, not just vitest: a countdown and a modal are the class of thing jsdom passes while the real screen is broken (the ISE-520/523/544 lesson).

Depends on ISE-592 (slice 1). Best done after slice 3 so the banner and the statusline agree.
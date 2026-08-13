---
id: 01KZENQXGWYP3PJK3VG50Y30WC
created: 2026-08-07T17:53:39.356876Z
updated: 2026-08-13T19:00:08.054259Z
type: task
title: 'Breakglass slice 4: the screen — pending-request modal and armed banner (ADR 0089)'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 614
sprint: snk16ew
comments:
- id: 01KZF3831WZ68K2G2MAF94F9E9
  author: Steve Vine
  at: 2026-08-07T21:49:40.795933Z
  text: |-
    Built — PR #533, stacked on ISE-613 (#534). ADR 0089 moves to ACCEPTED with this: all four slices are in.

    Arming happens in the app, and with this slice that stops being aspirational. §Flow 1 and §Flow 2 were BOTH unbuilt before it — nothing could create a request and nothing could arm one — so the property "an MCP token can request but never open a window" had nothing to be true about. Now: break_glass / end_break_glass on the MCP surface, and GET/POST /api/v1/issues/{id}/breakglass[/arm|/disarm] behind an SSO'd session.

    THE SCREEN
    - Pending request → a card, and a modal requiring a reason and a duration (120 ceiling, enforced in the schema AND the service). No approver picker, on purpose — self-approval is the design.
    - Armed → a red banner with a live countdown and Disarm, above everything the incident says about itself.
    - The countdown NEVER passes zero. remaining_seconds comes from the server's clock (the one the approval path enforces), and expiry is lazy server-side, so at zero it re-asks instead of counting negative or showing a window that has closed.
    - No grant, no affordance — not a disabled button explaining a capability the viewer does not have.

    THE GRANT IS READ LIVE OFF THE USER ROW, never from the caller. An MCP token's role cap is chosen at mint time and can only weaken its holder, so no token can assert this capability into existence, and revoking the identity-provider group removes it on the next call. The HTTP endpoints are grant-gated rather than role-gated: an admin who does not hold it is refused exactly like a viewer.

    VERIFIED IN A REAL BROWSER as well as vitest — dockerised playwright over a temporary harness (deleted before committing), per the ISE-520/523/544 lesson that jsdom does no layout and a modal + a countdown are precisely what a green vitest run says nothing about. Modal opens and gates on the reason, banner renders unclipped in light and dark, countdown ticks 24:59 → 24:57, nothing clipped by an ancestor.

    11 new integration tests + 4 vitest.
assignee: steve
label: null
priority: medium
task_status: done
tech: null
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
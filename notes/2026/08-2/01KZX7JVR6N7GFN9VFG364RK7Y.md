---
id: 01KZX7JVR6N7GFN9VFG364RK7Y
created: 2026-08-13T09:34:50.118847Z
updated: 2026-08-13T19:00:27.837293Z
type: task
title: A Collections nav section holds the ways an operator gathers the estate
project: 01KX671DATY39VW6GWK3M2T3DN
number: 677
sprint: savn96w
comments:
- id: 01KZX8VMCQSFKGSQWCPNB0S0Y8
  author: Steve Vine
  at: 2026-08-13T09:57:06.071086Z
  text: |-
    Built and merged to main as PR #628 (609c51b), CI green.

    Collections sits between ISE Core and Integrations, holding Business applications then Business services — bottom-up, the way the layers compose. Both are gone from ISE Core rather than duplicated. Routes, pages and the API are untouched: the umbrella is a nav section, nothing became /collections/*.

    The test asserts the section's index is exactly ISE Core + 1 and Integrations − 1, its item order, and the absence of both items from ISE Core — so a future edit that leaves a duplicate behind fails rather than looking right on screen.
assignee: steve
label:
- improvement
priority: medium
task_status: done
tech: null
---
Groups, Business Applications and Business Services are three answers to the same question — "which parts of the estate do I want to reason about together?" — and today they sit in three unrelated places (a Settings tab and two mid-list ISE Core entries). Give them one banner: **Collections**.

**Scope**
- New `NavSection` titled `Collections` in `components/nav.ts`, placed **between `ISE Core` and `Integrations`**.
- Move `Business applications` (`/business-applications`) and `Business services` (`/business-services`) out of ISE Core into it, in that order. Routes and pages are untouched — this is a nav move, not a re-route.
- Leave the slot above them for Groups, which arrives in the next task; the section order ends up Groups → Business applications → Business services.
- Carry the existing comment blocks across; nav.ts comments are the record of *why* each item sits where it does.

**Naming decision to hold to:** "Collections" is the **umbrella**, not a rename. The three screens keep their own names and URLs — nothing becomes `/collections/*`, and no entity type, API path or DB table is renamed. If that ever changes it needs an ADR, not a nav task.

**Done when** an operator sees a Collections section between ISE Core and Integrations with the two business screens under it, and no Business App/Service entry remains in ISE Core.

Watch the merge: nav.ts conflicts cut straight through object literals and only `npm run build` catches a bad resolution.
---
id: 01M65YAHX089HDE50K9RZ3GYR9
created: 2026-10-30T08:20:21.536183Z
updated: 2026-10-30T08:35:47.404968Z
type: task
title: Staging can send every email to the mail catcher for a while — switched on for a test run, it switches itself off, and the browser journeys use it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1467
sprint: s5pn06h
comments:
- id: 01M65Z6T2C1WYZMVF2JZXCBY4R
  author: Steve Vine
  at: 2026-10-30T08:35:47.404848Z
  text: |-
    2026-10-30 08:40 GMT: built, PR #1474 (auto-merge on). Migration 0749.

    One change from the description: the **Mail catcher** card sits at the top of **Admin ▸ Integrations** itself, above the tiles, not inside one email tile. It applies whichever sender is active, and it's the first thing an admin sees there.

    - API: GET/PUT/DELETE /api/v1/email/catcher (manage integrations), minutes 1–240.
    - Chart: config.mailCatcher.host = mailpit on staging only.
    - Suite: global setup switches it on as E2E Admin A for 30 min, teardown switches it off. If it was already on (someone testing by hand), the suite leaves it alone.
    - ADR 0135 amendment added.

    Tested locally: the new integration tests (routing, sender identity, expiry, bounds, audit, permission, refusal without a catcher), the existing email tests, unit suite, frontend card tests, tsc/eslint/prettier, e2e lint.

    Next: merge, deploy to staging, check the done-when on staging, then a full suite run with the journeys.
assignee: steve
label:
- feature
priority: high
task_status: active
---
Sprint 99 (ADR 0135). Steve, 2026-10-30: "Would it be possible create some sort of toggle that could be switched in the backend when required during testing so that email was sent using catcher?"

## Why

Staging sends real email through SendGrid. The browser journeys (COM-1451) write data that mails people: an incident's handlers, a vendor's contact, digests. So on staging they skip themselves. Switching staging's sender to the catcher for good would stop Steve getting real mail from staging.

## What people see

- Admin ▸ Integrations ▸ Email gains a **Mail catcher** card. It only appears where the deployment has a catcher, so staging has it and production never will.
- Off: "Send every email to the mail catcher instead of the sender above, for testing." with a **Switch on for 30 minutes** button.
- On: "Every email Compass sends is going to the mail catcher until 09:15, switched on by E2E Admin A." with a **Switch off** button. Real recipients get nothing while it's on.
- It switches itself off when the time is up, so a test run that crashes can't leave it on. At most 4 hours at a time.
- Who: anyone who can manage integrations.

## The browser suite

- Before the suite starts, Admin A switches it on for 30 minutes; when the suite ends, it switches it off.
- Each journey checks it is on before it writes anything, and skips with the reason if not. That's the same guard as today, asking the switch instead of the sender.
- The catcher is read where the runner can reach it: mailpit's API in the cluster.

## Done when

- On staging, with the switch on, a password reset for an E2E account lands in mailpit and SendGrid sends nothing. With it off, the active sender is used again.
- Once the time has passed, the switch reads off with nobody touching it.
- A deploy's Browser smoke runs the journeys (not skipped) and leaves the switch off.
- No catcher configured (production): the card is absent and switching on is refused.

**Chain:** on the chain (one migration: the switch's record; new API).
---
id: 01M05SXTWMRN089VR85RASREHT
created: 2026-08-16T17:29:19.508489Z
updated: 2026-08-16T17:29:30.578774Z
type: task
title: An email transport is never health-checked, and its pill says Disabled beside an Enabled toggle
project: 01KX671DATY39VW6GWK3M2T3DN
number: 750
sprint: s50x901
assignee: steve
label:
- bug
priority: high
task_status: backlog
tech: null
---
Found on smoke of [ISE-743], 2026-08-16: a transport named "SendGrid Staging" shows a **Disabled** pill beside an **Enabled** toggle that is clearly on. Sending works — the test send succeeded — so this is a missing safety net plus a contradictory label, not a broken transport.

## The real defect: `health_check` never runs for an email transport

Confirmed on the staging row:

```
name: SendGrid Staging | connector_type: sendgrid-email | enabled: t
health: disabled | sync_interval_seconds: NULL | last_synced_at: NULL
```

`System.health` defaults to `"disabled"` and the **only** thing that ever changes it is the sync loop. `sync.is_due()` returns False when `sync_interval_seconds IS NULL`, and `EmailCard`'s add-transport flow creates the System without one. So the transport is never dispatched, `health_check` is never called, and `health` sits at its initial default for ever.

**That makes ADR 0106 §1 false as shipped.** The ADR's whole argument for a transport being a connector rather than a settings blob is: *"`health_check` on the normal cadence, so a rotated-out key goes degraded on its tile and in the Platform Log BEFORE a send fails"*. The SendGrid `/v3/scopes` check exists, is tested, and never executes — so a revoked key would first be noticed as a notification that did not arrive. Same for SES sandbox detection and the M365 mailbox resolution, which are the equivalent load-bearing checks on the other transports.

Not caught by tests because every connector test calls `health_check` directly; nothing asserted that anything *dispatches* it.

## Fix

- **Set a sync cadence when the Email tab creates a transport.** That is all any other integration does — the ordinary loop then calls `health_check`, and no new machinery is needed. A transport has no sync slices, so the pass is a health check and nothing else; ~5 minutes is plenty.
  - Prefer a **backend default** over a frontend one: `SystemCreate` could apply a default interval for connectors declaring `email`, the way `obs_loop.apply_obs_schedule_default` handles the Obs Loop's inert-combination case (ISE-537). A UI-side default is one screen remembering, and the Add-integration picker is a second caller that would forget.
  - **Backfill the existing staging row**, which has NULL and will otherwise stay unchecked for ever.
- **Stop rendering a bare `health` pill next to an `enabled` switch.** They are different facts and the tab labels neither, so they read as contradicting each other. Two changes: label the pill (**Health**), and render `disabled` health on this screen as **"Not checked yet"** — "Disabled" is the honest word for the platform's internal state and the wrong word for what an operator is looking at.
- Consider a `schedule_warnings`-style notice for the inert combination, the ISE-537 shape: an enabled transport with no cadence will never report its health.

## Watch for

- **`sync_interval_seconds` is deliberately NULL-means-off** (ISE-166; `obs_loop.schedule_warnings` says so explicitly — *"a NULL `sync_interval_seconds` IS the encoding of scheduled sync off"*). So do not treat NULL as a bug generally; only make the email create path choose a value.
- **Teams has the same latent gap** — a `msteams` System added through the picker also starts with no cadence — but it lands on a System detail page where the sync schedule is visible and editable, so it is discoverable there. The Email tab deliberately keeps the operator off that page, which is why it bites here. Worth deciding whether the fix covers every `notifications`/`email` capability connector rather than just email.
- The health pill also appears in the left-hand transport list, not just the panel — both need the same treatment.
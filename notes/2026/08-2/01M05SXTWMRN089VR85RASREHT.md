---
id: 01M05SXTWMRN089VR85RASREHT
created: 2026-08-16T17:29:19.508489Z
updated: 2026-08-16T21:38:49.129823Z
type: task
title: An email transport is never health-checked, and its pill says Disabled beside an Enabled toggle
project: 01KX671DATY39VW6GWK3M2T3DN
number: 750
sprint: s50x901
comments:
- id: 01M05TX4CP1FWAQ1PESXKBM18M
  author: Steve Vine
  at: 2026-08-16T17:46:25.046816Z
  text: |-
    Fixed forward as PR #698 — migration **0145**.

    **Root cause confirmed against the staging row**, as written in the task: `sync_interval_seconds` was NULL, `is_due` reads NULL as "scheduled sync off" (ISE-166), so the transport was never dispatched and `health_check` never ran once.

    **On the "watch for" points in this task, both resolved:**

    1. **NULL-means-off is preserved.** The fix does not treat NULL as a bug generally — it fills a cadence in only for connectors whose capability set is a subset of `{notifications, email}`. A Kubernetes system with NULL is untouched, and there is a test for that in both the unit and the migration suites.

    2. **Teams is covered too.** Keying on the capability set rather than on `email` alone means `msteams` gets the same repair — it had the identical gap, merely discoverable because a Teams integration lands on a System page where the cadence is visible.

    **One design trap worth recording.** My first instinct was to key the rule on "the connector declares no sync slices" — and that is **wrong**: `AWSConnector` declares none either, because its discovery and alarm detection ride the sync loop's own calls rather than a slice. That rule would have handed AWS a cadence nobody chose and started syncing an estate on a schedule. The discriminator has to be "does no reading at all", i.e. the capability set. There is a parametrised test pinning `aws` as NOT outbound-only, so this cannot be re-broken quietly.

    **And one about my own test.** The first version of `test_a_new_transport_is_actually_health_checkable` went through the `add_transport` helper — which PATCHes a credential straight after creating — and so it **passed with the create-path fix deleted**, because the update path repaired it. Rewritten to exercise the create call alone. I then removed each path in turn to confirm both are genuinely covered; the corresponding test fails each time.

    Migration 0145 is deliberately narrow in two directions, both asserted: a source integration's NULL survives, and a hand-set cadence on an outbound integration survives. It is not reversed on downgrade — clearing the cadence again would restore the defect, and it cannot tell a row it filled in from one set by hand since.

    Screen: the pill is labelled **Health**, and `disabled` renders as **"Not checked yet"** on this tab only. Every other health value stays in the shared status vocabulary, which a test pins so the reword cannot creep.

    Once #698 merges I will push the staging pointer again; the migration backfills `SendGrid Staging`, so the pill should read Connected (or Degraded, if the key lacks `mail.send`) within five minutes of the deploy.
- id: 01M0686NN960RAFSR6WV4NY0AS
  author: Steve Vine
  at: 2026-08-16T21:38:49.129592Z
  text: |-
    Verified on staging and closed.

    ```
    SendGrid Staging | health: connected | sync_interval_seconds: 300
                     | last_synced_at: 2026-08-16 18:25:30+00 | last_sync_error: -
    ```

    Migration 0145 backfilled the cadence, the beat dispatcher picked the transport up on its next 30s tick, and SendGrid's `/v3/scopes` ran for the first time and came back clean — so the key carries `mail.send` (or is full-access, which SendGrid reports with no scopes at all). The tile reads **Connected**.

    What this actually buys, beyond the label: ADR 0106 §1's promise — *a rotated-out key goes degraded on its tile before a send fails* — is now true rather than aspirational. A revoked key surfaces within five minutes instead of being discovered by a notification that never arrived.

    Incidental finding while verifying: the existing `Microsoft Teams` system already had a 3600s cadence, so the migration did not touch it. The latent gap was real for a *freshly added* Teams integration and is closed for both by the capability-set rule.

    Steve confirmed testing successful 2026-08-16.
assignee: steve
label:
- bug
priority: high
task_status: active
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
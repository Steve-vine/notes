---
id: 01M0Q8TNPNB4WC0J2X8ZPVQ2BX
created: 2026-08-23T12:16:49.877073Z
updated: 2026-08-23T16:04:52.027796Z
type: task
title: Unrequested changes learn who did it — directoryAudits correlation behind AuditLog.Read.All
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 390
sprint: s5gwx0s
comments:
- id: 01M0QH1JQV7GR4A8KY1MCC1D60
  author: Steve Vine
  at: 2026-08-23T14:40:24.826974Z
  text: |-
    Done — PR #392 (feature/com-390-unrequested-actor).

    **Stacked on #391, and worth explaining why**: the work is genuinely independent of the device chain, but Alembic's single head is not. Two migrations both numbered off 0104 would fork a second head and break the trunk backstop, so this one follows 0105_device_mirror as 0106. Merge order is therefore fixed: 388 → 389 → 390 → 391 → 392.

    The grant: `AuditLog.Read.All` added to `REQUIRED_ENTRA_APP_ROLES` and the setup README (role id `b0afded3-3588-46d8-8b3d-9842eff778da`). **This means existing deployments' health card goes amber until admin consent is granted** — that's the grant-not-credential rule working as designed, and detection keeps working throughout; only the actor reads "unavailable". You'll want to grant consent on the compass-access registration before smoke-testing the Validation tab.

    I added a contract test I'd suggest keeping: it asserts the README's `az ad app permission add` role ids and the health check's required set are the same list. A permission added to one and forgotten in the other is exactly the kind of silent setup gap that only shows up in a fresh tenant six months later.

    Three actor states, kept apart as the brief asked:
    - `actor_kind` null + no reason → not enriched yet (retry next pass)
    - `actor_kind` null + reason → the lookup failed; the reason says why it's unavailable *now*. A later successful read clears it, so granting consent heals the display.
    - `actor_kind` unknown → ran, found nothing, stopped (7-day give-up, with a reason)

    Two implementation notes beyond the brief:
    - **Id extraction.** Graph doesn't put a membership change's group in `targetResources` — it's on the user's record inside `modifiedProperties` as `Group.ObjectID`. So id gathering reads both places, keyed on the `*ObjectID` naming convention plus a guid-shape fallback. Without that, "must match both endpoints" would never match anything.
    - **Ordering.** Enrichment runs *after* the mirror pass is banked, not inside it — a best-effort second Graph endpoint must never put the mirror's own correctness at risk. A 403 completes the pass with the reason recorded.

    Seven correlation tests, including the near-miss that must NOT be adopted (right activity, right user, wrong group) — that's the one that would catch a loosened matcher.

    203 unit + 764 integration green.
- id: 01M0QNW75VZR8M71V3PGS3EMDF
  author: Steve Vine
  at: 2026-08-23T16:04:52.027527Z
  text: |-
    Deployed to staging. **One ops action outstanding, as flagged.**

    The Entra health card is now **error**: "Signed in, but missing admin consent for: AuditLog.Read.All — grant admin consent on the app registration's API permissions". That's the grant-not-credential rule doing its job, not a regression — but it needs admin consent on the `compass-access` app registration before the actor feature does anything.

    The degradation is behaving exactly as designed in the meantime. All 11 pending validation items carry:

    `actor_reason = "could not read the directory audit log (Microsoft 365 error (HTTP 403))"` with `actor_kind` still NULL.

    So the Validation tab reads "Actor unavailable — could not read the directory audit log…" rather than "not yet available", which is the distinction the whole three-state design exists for — and because `actor_kind` stays NULL they're all still in the retry set. The moment consent lands, the next sync pass will clear the reason and attribute whatever it can find within the window.

    Note those 11 items were observed 18–22 Aug, so several are already close to the 7-day give-up. If consent isn't granted within the week they'll age out to `unknown` — which is correct behaviour, but means the backfill opportunity for the oldest ones is time-limited.

    Portal: Entra → App registrations → compass-access → API permissions → add `AuditLog.Read.All` (Application) → Grant admin consent. Role id `b0afded3-3588-46d8-8b3d-9842eff778da`; the `az` one-liner is in `scripts/entra/README.md`.
assignee: steve
label:
- feature
priority: medium
task_status: review
---
The sync knows *that* reality diverged, never *who* diverged it — `unrequested_changes` has no actor columns. Entra's directory audit log has the answer (`GET /auditLogs/directoryAudits`, `initiatedBy` = user or app), and detection's 15-minute cadence + 48h lookback sits comfortably inside the 30-day P1/P2 retention.

- [ ] **Grant**: `AuditLog.Read.All` application permission on the Access app registration (admin consent — ops step; `Directory.Read.All` does not cover audit reads). Add to the verified-app-roles list in `tasks/entra_health.py`, and amend ADR 0045's grant list — it's part of the integration contract.
- [ ] **Columns** on `unrequested_changes`: `actor_kind` (user / app / unknown), `actor_display`, `actor_identifier` (UPN or app id), `performed_at`. Nullable — null means "not yet enriched", shown as such, never conflated with "no actor found".
- [ ] **Correlation**: kind → `activityDisplayName` map ("Add member to group", "Remove member from group", "Add user", "Add group", "Delete group"); filter on `activityDateTime` around `observed_at` + `targetResources/any(t: t/id eq '…')`; a membership item must match **both** the group id and the user id in the targets.
- [ ] **Timing**: attempt enrichment when the item is created, then retry on later sync passes for pending items still missing an actor — audit ingestion can lag minutes to hours. Stop retrying once the item is validated or a bounded age (e.g. 7 days) passes; stamp `actor_kind=unknown` with a reason rather than retrying forever.
- [ ] **Best-effort, loudly degraded**: a missing grant or a failed lookup must never fail the sync pass — the `directory_role_names` None-means-unknown idiom. The API exposes the degraded reason so the UI can say "actor unavailable — audit grant missing" instead of going silently empty.
- [ ] App actors are first-class: "Directory Synchronization Accounts" or a SCIM tool as initiator is signal (the change came from on-prem AD / another IdM), not a failure to resolve a person.

Refs: ADR 0045 §7 (out-of-band detection), ADR 0044 §4 (verified grants), COM-244 (detection), COM-252 (unknown-vs-empty idiom).
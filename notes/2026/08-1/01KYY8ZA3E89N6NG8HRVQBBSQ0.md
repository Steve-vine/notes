---
id: 01KYY8ZA3E89N6NG8HRVQBBSQ0
created: 2026-08-01T09:02:39.214546Z
updated: 2026-08-07T10:06:47.281763Z
type: task
title: 'Microsoft Teams becomes a real integration: its config moves off the main Settings page onto its own integration page'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 459
sprint: sfv5yw0
comments:
- id: 01KYYENRDNB3JCT3MRXV82649Q
  author: Steve Vine
  at: 2026-08-01T10:42:17.653662Z
  text: |-
    Built 2026-08-01 — PR #398 (stacked on #396/ISE-455 so the Alembic chain runs 0082 → 0083), merged to staging (a08ffa6). ADR 0071, migration 0083.

    Everything planned landed: msteams connector on the StatusPageConnector shape, `notifications` capability, notification_channel.system_id, health_check acquiring a bot token, Settings → Notifications tab and TeamsBotCard deleted, cards on the integration page.

    ONE PLAN ITEM WAS WRONG AND I CORRECTED IT MID-BUILD. The plan said multi_tenant moves to System.config, which is where a non-secret setting belongs. I implemented that, then checked the credential table: credentials are stored ENCRYPTED (wrapped_dek/ciphertext, no readable column), so a migration cannot decrypt one to copy the flag out — and a migration has no business doing crypto. Moving it would have silently dropped the setting for the only kind of install that has it (a legacy multi-tenant bot, which Microsoft no longer issues and which therefore cannot be re-created). It stays in the credential. ADR 0071 §3 records the reasoning rather than leaving it looking like an oversight.

    Two further decisions taken in build, both in the ADR:
    - NotificationChannelUpdate no longer carries system_id. Moving a channel to a different bot would silently change who delivers it and from which tenant; that is a new channel, not an edit.
    - The /notification-config endpoints are retired outright rather than made per-system — the credential now goes through the ordinary credential flow, so they had nothing left to manage.

    The health check is authentication only, with a test asserting it hits ONLY the token endpoint: a health check that posted a card would message a human on every cadence tick.

    Test surgery was the bulk of the work: every notification test now builds a Teams System. Two full-suite failures caught it — a shared helper minting duplicate "Microsoft Teams" systems (made idempotent) and an error-message assertion still expecting the word "Settings".

    Gates: full backend suite 2039 passed; migration check green on the combined 0083 chain; frontend 476 / 84 files after the staging merge; ruff, mypy strict, build, eslint, prettier green.
- id: 01KYZ2SMP2PYRS4SKT8CGKC770
  author: Steve Vine
  at: 2026-08-01T16:33:56.417833Z
  text: |-
    FOLLOW-UP: the staging deploy caught a real bug in migration 0083, now fixed and covered.

    The pre-upgrade hook failed: I minted the System with health='unknown', which is not in SYSTEM_HEALTH, so the CHECK constraint rejected it.

    Why no test caught it, which is the part worth remembering: 0083's data path only runs `if channels or credential`. Every test — including the migration check — ran it against a FRESH database where both are absent, so the INSERT was never executed once in CI. Staging had a teams-bot credential and one channel, so the branch ran there for the first time, in the deploy. A migration whose interesting behaviour only fires on populated data needs a test with populated data; zero-to-head proves nothing about it.

    Two tests now migrate to 0082, insert realistic rows, then upgrade to 0083: a configured bot (adopted, enabled, channels re-pointed) and channels with no credential (minted disabled, NOT NULL satisfied). Both reproduce the failure without the fix. A configured bot now starts `connected` and the first health check corrects it; no credential means `disabled`.

    VERIFIED ON STAGING after the re-deploy: alembic_version 0083; System "Microsoft Teams" enabled/connected bound to the teams-bot credential; the existing "Steve Vine" channel adopted onto it. Nothing re-entered, delivery uninterrupted — exactly what ADR 0071 claims.

    All seven sprint PRs (#392-#398) are green and staging CI is green.

    Also found while running the suite, NOT caused by this sprint: four tests fail on main itself (test_freshservice_ingest.py x3 and test_retrieval.py::test_chat_tools_search_and_observe). Verified on main with all sprint work removed. They passed at 09:00 and fail at 16:00, so they look time-of-day dependent. Raised separately.
assignee: steve
priority: medium
task_status: done
---
Steve's call 2026-08-01, chosen over two lighter alternatives. Today Teams is **not** an integration: there is no `msteams` connector, `notification_channel` has no `system_id`, and the bot identity lives as a well-known `teams-bot` credential (ADR 0069 §2). Its config therefore landed on Settings → Notifications, next to the AI and Users tabs, while every other integration configures itself on its own page. To an operator Teams *is* a connected system, so make it one.

Kept as ONE task deliberately: moving the credential onto a System breaks the existing settings card, so a foundation/surface split would leave Teams unconfigurable in between.

**Backend**
- **New `msteams` connector**, display name "Microsoft Teams", built on the `StatusPageConnector` shape — the existing precedent for a connector that syncs nothing and exists to own a surface: `sync_spec()` returns `SyncSpec(slices=[])`, `action_catalogue()` returns `[]`.
- **`credential_spec()`** declares the four bot values that are one `teams-bot` credential today (app id, app secret, tenant id, catalogue app id, plus the multi-tenant flag). The Add-integration form renders itself from this spec (ADR 0018), so Teams gets a correct form for free.
- **`health_check()` acquires a bot token.** Real gain, not a formality: a bot whose secret has been rotated out is invisible today until a delivery fails — as an integration it goes degraded on its tile and on Overview.
- **`CONNECTOR_CAPABILITIES` gains `notifications`** (`connectors/base.py`). It is not a signal capability and adds no nav entry; it gates the config cards.
- **`notification_channel` gains `system_id`** (FK → `system.id`), so two Teams bots in two tenants can each own their channels. `teams_bot.load_config()` stops reading the well-known name and takes the System.

**Migration — stack it.** ISE-455 also adds one; two in-flight branches adding sequential Alembic revisions must stack or the chain breaks CI. Head is 0081, so this is 0083 if it follows ISE-455's 0082.

**Data migration matters here** — staging and prod have a working Teams bot, and this must not silently stop delivering. Mint a `Microsoft Teams` System bound to the existing `teams-bot` credential and adopt every existing channel onto it. If channels exist with no credential (a half-configured install), mint the System disabled so the constraint holds and the gap is visible rather than hidden.

**Frontend**
- Bot identity, channels (with their test send) and recent deliveries become cards on `SystemDetailPage`, gated on the `notifications` capability — the pattern already used there by `ActionsPanel`, `FreshserviceConfigCard`, `KindDictionaryCard`.
- **Delete the Settings → Notifications tab** and `TeamsBotCard`'s place on it.
- Teams appears in Settings → Integrations alongside the connectors, and in the Add-integration modal.

**ADR 0071**, amending ADR 0067 §1 and ADR 0069 §2 (append-only — supersede, never rewrite). Record the consequence rather than discovering it later: **ADR 0067 deliberately made the notification layer destination-agnostic, and system-owned channels narrow that** — a future email or Slack channel must now also be an integration rather than a bare channel kind. That is the trade being accepted, and it should read as a decision.

**Acceptance**
- Teams can be added from the Add-integration modal with the four bot values, and appears in Settings → Integrations.
- Its integration page carries the bot identity, its channels and the recent-deliveries log; Settings → Notifications no longer exists.
- A bot with a stale secret shows degraded on its integration tile, not only at delivery time.
- An install upgraded from the current release keeps delivering with no re-entry of the secret — existing channels adopted by the minted System.
- Two Teams integrations in different tenants each deliver through their own bot.
- ruff, mypy strict and the backend suite green; `npm run build`, eslint, `format:check`, vitest green; OpenAPI snapshot + `npm run generate:api` regenerated.

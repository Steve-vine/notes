---
id: 01KYY8ZA3E89N6NG8HRVQBBSQ0
created: 2026-08-01T09:02:39.214546Z
updated: 2026-08-01T09:16:41.182487Z
type: task
title: 'Microsoft Teams becomes a real integration: its config moves off the main Settings page onto its own integration page'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 459
sprint: sfv5yw0
assignee: steve
label:
- improvement
priority: medium
task_status: todo
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

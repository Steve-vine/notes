---
id: 01M16VKVPMM753KEKRG7S2SBKS
created: 2026-08-29T13:33:46.068231Z
updated: 2026-08-30T06:57:21.535791Z
type: memo
title: Compass sync schedule
project: 01KXGC5PTGYHV30VM3E78G76S1
company:
- moneypenny
---
Every scheduled job that reads Microsoft Entra. Times are **UTC** — beat runs a single replica in UTC, so these are wall-clock and do not shift with BST. Verified against deployed `staging-20260829-0848` on 2026-08-29 (1,557 users · 3,342 groups · 70,826 memberships · 2,038 devices).

Reference page: https://claude.ai/code/artifact/938d1037-ad92-42b0-b5f7-1be979a6bc2b

## Jobs that read Entra

| Job | When | Mode | Collects |
|---|---|---|---|
| **Directory sync** `directory_sync.sync_directory` | `:00 :15 :30 :45` (*/15) | **Delta** | Changed users, groups, devices since the stored token; members + owners of **only** the groups that surfaced; registered owners of changed devices; **all mail contacts in full** (no change feed); directory roles for changed role-assignable groups. 5–9 s. |
| **Directory sync — full crawl** (same task) | ~once a day, on a */15 tick | **Full** | Every user, group, device, mail contact; members **and** owners of all 3,342 groups in batches; nested-group, device and contact memberships; device owners; directory roles, role assignments, PIM eligibility. **149.7 s measured.** |
| **Sign-in activity sweep** `sign_in_sweep.sweep_sign_in_activity` | `:25` hourly | **Full** | Last sign-in for every mirrored account. Own pass — Graph won't return `signInActivity` on the user delta feed. |
| **MFA registration sweep** `auth_methods_sweep.sweep_auth_methods` | `:40` hourly | **Full** | Registered authentication methods per account. Offset from the sign-in sweep; kept separate so a reporting-endpoint failure can't look like everyone losing MFA. |
| **Connection health** `entra_health.check_entra_connection_health` | every 5 min | — | Nothing mirrored. Verifies the app registration's *granted permissions*, not just token acquisition. Drives the Admin ▸ Integrations card. |
| **Actor enrichment** `directory_sync.enrich_actors_safely` | after every pass | either | Entra audit-log entries, to name who made an observed change. Runs **after** the mirror is committed, never inside it. |

## The full crawl has four triggers, not one

24 h backstop due · no stored delta token · Graph rejects the token (`resyncRequired`) · the mirrored field set has widened. The daily one is just the most common. It mints fresh tokens *before* crawling, so changes during the crawl land in the next delta rather than falling in a gap. If a pass is still running when the next tick arrives, that tick stands down.

## Every directory pass then does the same four things

Both modes run identical reasoning — only the starting facts differ.

1. **Reconcile the mirror** — members, nested groups, device + contact memberships, owners.
2. **Membership provenance** — rebuild the explained/unexplained record. Deliberately unscoped (COM-480): whole record against whole mirror, every pass.
3. **Coverage snapshot** — today's figure per company, upserted per day.
4. **Out-of-band detection** — anything in the directory with no matching access-ledger entry becomes a validation-queue item. **48-hour** lookback before calling a change unrequested.

## Load note

Every account is read **three times an hour**: once for changes, once at `:25`, once at `:40`. Relevant if shortening the full-crawl backstop comes back on the table — Graph load is already higher than "one delta every 15 minutes" implies.

## Known defects in this cycle

- [[COM-508]] — a **membership-only change does not surface** the group in the delta, so membership adds *and removes* are invisible until the next full crawl (up to 24 h).
- [[COM-509]] — provenance deletes attribution the mirror hasn't confirmed yet, so it is destroyed before the mirror catches up. Currently **0 explained / 45,324 unattributed**.

## Not Entra (same beat schedule, listed to avoid confusion)

Reminder digest `:00` hourly · scheduled reports every 15 min · email transport health every 5 min · heartbeat every 5 min · vendor lifecycle `01:15` daily · recertification opener `01:30` daily.

---
id: 01KYQQAJXZVXDTHJMA56VWBNPD
created: 2026-07-29T19:58:47.7435Z
updated: 2026-08-05T14:49:05.301925Z
type: task
title: Azure Monitor alerts → Alert signals
project: 01KX671DATY39VW6GWK3M2T3DN
number: 366
sprint: s0d5f5q
blocked_by:
- 01KYQQA7N6RWFYHQ148JMVWA8H
comments:
- id: 01KYQZH8MF34PTTKH3M8J7AN1B
  author: Steve Vine
  at: 2026-07-29T22:22:15.183284Z
  text: |-
    Built and in review — PR #339 (feature/ise-366-azure-monitor-alerts, stacked on #338), merged to staging.

    detect() pulls Fired alerts from the Alerts Management API (2019-05-05-preview) and forwards them as Alert signals. source_key = alert rule + target resource, lower-cased — the monitor/{id}/{group} lesson applied: stable across re-fires so a re-occurrence reinforces the same signal instead of minting one per alert instance; Closed alerts are not sightings. Sev0→critical, Sev1→high, Sev2→medium, Sev3→low, Sev4→info. targetResource (in whatever ARM casing Azure sends) attributes onto the lower-cased ISE-365 keys; targetless alerts stay unattributed and kind falls back to the monitor service slug so ADR 0026 overrides can tune per service.

    The dedupe contract is proven against real Postgres: an Azure alert and a DataDog monitor firing on the same VM resolve to one entity and the existing "same affected entity" merge candidate appears — no new correlation machinery. 4 new tests (12 Azure tests green in the file pair); ruff/mypy clean.
- id: 01KYS1RWFFPSX8VVT77EQV0JXC
  author: Steve Vine
  at: 2026-07-30T08:20:36.463311Z
  text: |-
    Live smoke test on staging found the defect that blocked Steve's whole first sync — fixed on the branch (commit f3d699e), chain re-merged, redeploying:

    The real estate's smart-detector alert ("Failure Anomalies - ain-mp-prd-uks-apig") produces a source_key of rule-id|target-id ≈ 330 chars — past finding.source_key's varchar(300). The INSERT raised StringDataRightTruncation, which killed the entire sync transaction; and because sync_one's error containment only wraps the connector READS (not _persist), nothing recorded the failure: last_synced_at stayed NULL, health stayed at its creation default "disabled" (hence the DISABLED tile), and the never-synced system re-dispatched every beat minute. The composite now passes through _bounded_key; regression test pins the exact live shape through reconcile_findings on real Postgres.

    Two follow-up candidates surfaced for the Bugs & Improvements backlog, both PRE-EXISTING platform issues this exposed rather than Azure code: (a) sync_one's try/except should arguably wrap _persist too, so a bad connector value degrades to health=error instead of a silent unrecorded death; (b) the staging ise-worker is being OOMKilled every ~9 min (62 restarts since last night's deploy, 512Mi limit) — started BEFORE the Azure system existed, so unrelated to this sprint, needs its own investigation.
assignee: steve
priority: medium
task_status: done
---
Mirror of ISE-360 (CloudWatch alarms). Poll fired/resolved alerts from Azure Monitor (Alerts Management API) → Alert signals attributed to discovered entities via the alert's target resource id; Azure Sev0–Sev4 mapped onto the canonical severity ladder. Dedupe/reinforcement against DataDog/K8s signals via same-entity attribution + existing merge candidates — no new cross-source architecture.
---
id: 01KYQQAJXZVXDTHJMA56VWBNPD
created: 2026-07-29T19:58:47.7435Z
updated: 2026-07-29T22:22:16.120988Z
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
assignee: steve
label:
- feature
priority: medium
task_status: review
---
Mirror of ISE-360 (CloudWatch alarms). Poll fired/resolved alerts from Azure Monitor (Alerts Management API) → Alert signals attributed to discovered entities via the alert's target resource id; Azure Sev0–Sev4 mapped onto the canonical severity ladder. Dedupe/reinforcement against DataDog/K8s signals via same-entity attribution + existing merge candidates — no new cross-source architecture.
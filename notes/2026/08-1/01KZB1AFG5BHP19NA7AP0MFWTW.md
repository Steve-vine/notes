---
id: 01KZB1AFG5BHP19NA7AP0MFWTW
created: 2026-08-06T07:59:04.197247Z
updated: 2026-08-06T08:14:53.614944Z
type: task
title: 'EntraID: app-registration credential expiry observation (90/60/30/expired ladder)'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 583
sprint: syjypmr
blocked_by:
- 01KZB18ZQNJVZGXRYY1ZWTT7S8
- 01KZB198WA3NK866R0GHVGE1TX
assignee: steve
priority: medium
task_status: backlog
---
Promote the existing evidence sweep into a laddered Observation — the first multi-rung consumer of threshold_specs. `_ev_app_credential_expiry` (`entraid.py:1248-1298`) already enumerates every app registration's `passwordCredentials`/`keyCredentials` and computes `days_to_expiry`; ADR 0063 left it evidence-only ("one evidence call away"). No new Graph plumbing.

**Ladder (declared as a multi-rung ThresholdSpec, days unit, per-System tunable):**
- expiring ≤ 90 days → **low**
- ≤ 60 days → **medium**
- ≤ 30 days → **high**
- expired → **critical**

Applies to both secrets (passwords) and certificates on app registrations; one observation per app registration at its worst rung (soonest-expiring credential), naming the credential and days remaining, effective bands echoed into `details`. Deterministic detector with fixed per-rung confidence (ADR 0026 house style — never a model's opinion). Rationale for four calendar bands rather than the derived-ladder stance of `freshservice_detect.py:236-240` goes in the threshold_specs ADR: these are calendar-meaningful lead times for a human to rotate a credential, not multiples of a noise floor.

Note: at critical/high + the default auto-incident policy (threshold "high", `severity.py:32-33`) these will auto-open incidents — expired secrets in the tenant will surface loudly on first sweep. Check staging's real expiry landscape before enabling in prod.

Acceptance: staged app registrations with credentials at 95/75/45/10 days and one expired produce low/medium/high/critical observations respectively; bands editable in the generic threshold card; observation visible on the EntraID System screen.
---
id: 01KZB1AFG5BHP19NA7AP0MFWTW
created: 2026-08-06T07:59:04.197247Z
updated: 2026-08-07T10:35:44.101552Z
type: task
title: 'EntraID: app-registration credential expiry observation (90/60/30/expired ladder)'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 583
sprint: syjypmr
blocked_by:
- 01KZB18ZQNJVZGXRYY1ZWTT7S8
- 01KZB198WA3NK866R0GHVGE1TX
comments:
- id: 01KZB7AX5Q3855KKK1T4KQF59Y
  author: Steve Vine
  at: 2026-08-06T09:44:09.655873Z
  text: |-
    Done — PR #497 (feature/ise-583-entraid-credential-expiry, stacked on #496).

    Ladder built exactly as confirmed: 90/60/30/expired -> low/medium/high/critical, declared as a four-rung `ThresholdSpec` (days, 0-730, at_or_below), each band separately tunable. This is the case ADR 0088 admits ladders for, and the ADR now carries the reasoning: an estate with a quarterly change window wants the outer band moved without touching the inner ones, which a derived ladder cannot express. A test holds that moving one band leaves the others alone.

    No new Graph plumbing and no new grant — the dates ride the `$select` `_read_applications` already asks for. Secrets and certificates both covered.

    Decisions inside the acceptance:
    - **One observation per registration, at its worst rung**, naming the credential that put it there and its days remaining. Six signals for one registration would bury the five other registrations that also need attention; the aggregation costs nothing because the specific credential is named.
    - **Keyed on the registration, not the credential.** A key that moved as one secret rotates and another becomes the soonest would recover and re-open the signal every time — the ISE-441 lesson about putting moving values in keys.
    - **A credential with no parseable expiry is skipped, never guessed.** An invented date would either cry wolf or, far worse, promise safety.
    - Confidence fixed at 0.95, deterministic per ADR 0026 — the highest in the connector, since Graph states the date; the residual doubt is only whether the credential is still in use.
    - Effective bands echoed into `details`.

    **A bug found on the way, fixed here.** `detect_observations` returned early when the `/servicePrincipals` read failed — correct for the SP-less detector (without the join every registration looks uninstantiated, 373 false findings), but it would have silenced credential expiry too, which never needed that join. Expiry is now computed first and survives an unrelated Graph failure. Test added.

    23 new tests including the acceptance ladder at 95/75/45/10/expired; backend unit 711 green, EntraID integration 40 green.

    **Carrying the task's own warning to smoke:** at critical/high with the default auto-incident policy (threshold `high`), expired secrets in the tenant will auto-open incidents on the first sweep. Worth looking at staging's real expiry landscape before this points at the production tenant.
assignee: steve
priority: medium
task_status: done
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
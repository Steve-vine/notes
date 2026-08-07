---
id: 01KZB6Z99RP9FXPTJ425JZS8V5
created: 2026-08-06T09:37:48.856325Z
updated: 2026-08-07T10:57:36.588914Z
type: task
title: 'Azure evidence timestamps: use Z-suffix UTC — Azure Monitor double-decodes ''+00:00'' offsets into spaces'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 585
sprint: scb3vol
comments:
- id: 01KZC5XVGAFHWBTFSCXW928VQB
  author: Steve Vine
  at: 2026-08-06T18:38:47.818488Z
  text: |-
    Built — PR #506 (branch feature/ise-585-azure-z-timestamps).

    Fixed as diagnosed: a shared `_arm_timestamp()` emits `…Z` at seconds precision, used for both ends of the metrics `timespan` and for the activity-log `eventTimestamp ge '…'` filter. Your root-cause analysis was exactly right and saved the work — the two-decoders-in-series detail is the whole reason this can't be fixed by encoding harder, so I put it in the helper's docstring where the next person to touch it will see it.

    I swept the rest of the connector: those two call sites were the only `isoformat()` uses in `azure.py`, and both are now on the helper, so there is no remaining exposure. `log_analytics_query` uses `PT{n}M` durations and was never at risk.

    On the test, I took your "green suite, broken live" note seriously and asserted on the **outgoing parameters** rather than the result — a stub that answers happily proves nothing about what Azure would have received, which is precisely how this suite stayed green through the bug. Then I checked the test is worth having: reverting the helper to `isoformat()` fails it with the exact string from your live 400 (`2026-08-06T17:36:55.480596+00:00`). A regression test that has never seen the regression isn't one.

    ruff, mypy strict, 711 unit and 31 Azure integration tests green.

    **Still needs the live check** — ISE Test Plan §7, `monitor_metrics` and `activity_log` against a real VM. The unit assertion proves the string shape; only Azure can prove it accepts it. That's blocked until staging is deployable (GitHub Actions is in a major outage; PR CI can't run either, so this PR is unverified by CI as I write).

    One observation I did not act on, since it's outside this task: `connectors/cloudflare.py` puts bare `isoformat()` output into query params in four places (lines ~723, 959, 989, 1018). Different vendor, no evidence of the same double-decode, and Cloudflare documents RFC3339 — so probably fine. Flagging it because it's the same *shape* of exposure, not because I think it's broken.
label: null
task_status: done
---
Found live during ISE Test Plan execution (2026-08-06): `fetch_evidence` → `monitor_metrics` on CSP Softcat fails with HTTP 400 — `Detected invalid time interval input: 2026-08-06T07:30:02.095974 00:00/…` (space where `+` should be).

Root cause is on Microsoft's side but ours to work around: `_ev_monitor_metrics` (`connectors/azure.py:1115`) builds the timespan from `datetime.now(UTC).isoformat()` → `…+00:00`. httpx 0.28.1 correctly sends `%2B` (verified by repro), but Azure decodes the query **twice** — ARM front door `%2B`→`+`, then the Monitor metrics RP form-decodes `+`→space. Any `+00:00` offset in the metrics `timespan` arrives mangled no matter how correctly it is encoded.

Fix: emit Z-suffix UTC timestamps, e.g. `start.strftime("%Y-%m-%dT%H:%M:%SZ")` (or `isoformat().replace("+00:00", "Z")`), for both ends of the timespan.

Also fix the same latent exposure in `_ev_activity_log` (line ~1147): `$filter=eventTimestamp ge '<isoformat with +00:00>'` — switch to Z format in the same change. (`log_analytics_query` uses `PT{n}M` durations and is unaffected.)

Test note: the integration suite is green because nothing exercises live Azure — same "green suite, broken live" pattern as Sprint 47. Add a unit assertion that the generated timespan/filter strings contain no `+`, and verify live via `fetch_evidence` on a real VM (ISE Test Plan §7 checkboxes: monitor_metrics + activity_log).

Bug exists identically on main and staging.
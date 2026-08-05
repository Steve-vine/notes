---
id: 01KYF12MN110ARHSQAS4ZJC3FJ
created: 2026-07-26T10:56:03.233037Z
updated: 2026-08-05T12:31:56.688303Z
type: task
title: 'GitHub signals: workflow failures + Dependabot + code scanning → Alerts'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 310
sprint: siyfhjg
blocked_by:
- 01KYF10Q72XPZAHFH1KMDCF611
comments:
- id: 01KYHC0BHB8ERGWW6P73ER0WBN
  author: Steve Vine
  at: 2026-07-27T08:45:31.563001Z
  text: |-
    Built 2026-07-27 → Review. PR #293 (stacked on #292, base feature/ise-309 branch), branch feature/ise-310-github-signals. No migration.

    connectors/github.py only: capabilities() now {"repos","alerts"}. detect(ctx) reads REGISTERED repos for ctx.config["system_id"] via a LAZY _session()+select(Repo) (the one deliberate exception where a Repos connector touches ISE state — "which repos" is register scope; documented in the method), then polls three families per repo via build_client. Family builders are module functions taking an httpx client (unit-testable, no DB): _workflow_findings (GET /actions/runs?branch&status=completed, latest run per workflow_id, conclusion==failure → high), _dependabot_findings (GET /dependabot/alerts?state=open; 403/404→[] degrade; sev map critical/high/moderate→medium/low), _code_scanning_findings (GET /code-scanning/alerts?state=open; 403/404→[]; sev from rule.security_severity_level else rule.severity error→high/warning→medium/note→low). Source keys actions-workflow:{full}:{wf_id} / dependabot:{full}:{n} / code-scanning:{full}:{n}. entity_key=full_name (unresolved by design). Flows through standard sync.reconcile_findings — recovery/deleted-workflow-silent-recover come free.

    Tests tests/test_github_signals.py (unit, MockTransport): latest-run-per-workflow, sev mappings, source keys, 403/404 degradation. Updated test_github_connector capability assertion to {"repos","alerts"} / ["alerts","repos"]. Green: mypy 348, ruff, connector-discovery. No frontend/OpenAPI (capabilities dynamic; alerts badge auto-renders).
assignee: steve
priority: medium
task_status: done
---
The signal surface. Add `"alerts"` to the GitHub connector's capabilities and implement `detect(ctx)` over **registered repos only** (never the whole account); alerts flow through the standard `sync.reconcile_findings` + promotion path — no new signal machinery.

**Source keys & semantics** (per ADR 0051):
- `actions-workflow:{full_name}:{workflow_id}` — one signal per workflow, firing while that workflow's latest completed run on the default branch is failing; severity high. A later successful run drops the key from the batch → reconcile recovers it. A deleted workflow silently recovers (accepted, mirrors DataDog monitor deletion).
- `dependabot:{full_name}:{alert_number}` — open Dependabot alerts; severity mapped critical→critical, high→high, moderate→medium, low→low; recovers when no longer open. Needs Dependabot-alerts read on the PAT — degrade gracefully (recorded sync note, not an error) if the scope is missing.
- `code-scanning:{full_name}:{alert_number}` — same shape, severity from `rule.security_severity_level`.

`entity_key = full_name` deliberately stays unresolved — signals hang off the GitHub System; the repo's tags provide estate context on drill-in. `sync_spec` stays sliceless; detect runs off the standard 30s dispatcher gated by `sync_interval_seconds` (set a sensible default, e.g. 300s).

**Acceptance:** a repo with a failing default-branch workflow shows an Alert on the Alerts screen naming repo + workflow, promotes per the auto-incident policy like any alert, and recovers when a later run succeeds; a critical Dependabot alert appears as critical.

**Files:** mod `connectors/github.py` only (+ new `tests/integration/test_github_signals.py`, mirroring `test_datadog_sync.py` patterns). No migration — parallelisable; rebase `connectors/github.py` often.
---
id: 01KXZWFK64FW92YFQYET1JPH88
created: 2026-07-20T13:47:08.356906014Z
updated: 2026-07-21T16:23:15.143946Z
type: task
title: Evidence tools leaked into analyse-issue → per-run Budget Exceeded
project: 01KX671DATY39VW6GWK3M2T3DN
number: 154
sprint: sehghhk
assignee: steve
label: null
priority: high
task_status: done
---
**Bug found in Sprint 15 batch testing (smoke test).** Clicking **Analyse** on an incident returned *Budget Exceeded* on the first action of the day.

**Diagnosis.** Not the daily ceiling — investigation showed only one AI run today (the user's), the Obs Loop dispatching `{'dispatched': 0}` (no scheduled spend), and the run taking **51s before** returning `budget_exceeded`, i.e. it hit the **per-run** cap (12 tool-iterations / 200k tokens = `UsageLimitExceeded`), not the pre-run daily gate.

**Root cause.** ISE-149 added the on-demand Evidence tools (`list_evidence_sources` / `list_evidence_queries` / `pull_evidence`) to the *shared* `DIAGNOSIS_TOOLS`, which `analyse-issue` (the incident re-check) and `propose-remediation` also build on. A re-analysis — a cheap "does this issue still hold" check off recorded state — then went off pulling live cross-integration evidence and blew its per-run budget.

**Fix.** Scope the Evidence tools to the **diagnose** agent only (`DIAGNOSE_TOOLS = DIAGNOSIS_TOOLS + EVIDENCE_TOOLS`), keeping them off `analyse-issue` and `propose-remediation`. Matches ISE-149's stated scope ("diagnose / issue-chat"). Regression tests assert the shared base and the propose/analyse paths carry no evidence tool. Fixed on `feature/ise-149`, re-merged to staging.

Note: idle/daily spend is healthy — no leak. Watch-item: diagnose itself now does a few more tool round-trips; keep an eye on its per-run budget headroom.
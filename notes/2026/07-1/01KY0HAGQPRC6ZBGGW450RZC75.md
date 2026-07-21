---
id: 01KY0HAGQPRC6ZBGGW450RZC75
created: 2026-07-20T19:51:22.102105Z
updated: 2026-07-21T16:49:42.314024Z
type: task
title: Retire system-scoped "Run analysis" — AI must not create incidents outside the Canon open paths (+ ADR)
project: 01KX671DATY39VW6GWK3M2T3DN
number: 167
order: 3.0
sprint: skj7tft
assignee: steve
label: null
priority: medium
task_status: done
---
The system-page "Run analysis" button is a pre-Canon remnant (ISE-37, Sprint 4, when AI analysis *was* the detection layer). It writes the analyse agent's proposals **directly as incidents** (`source='ai'`, `ai/analysis.py:_persist_issues`), bypassing every governance layer the Canon built: ADR 0025 §4 enumerates the only incident open paths (Alert above threshold, severe high-confidence Observation, or a person), and this path sidesteps the ADR 0026 threshold/confidence bar, silence/ignore/suppression, correlation keys (bespoke title dedup instead), the resolution cascade, and signal history. Sprint 14 (ADR 0030) retired the *scheduled* analyse timers but left the on-demand button standing.

Decision (Steve, 2026-07-20): **remove the feature completely** rather than reshape its output into Observations. Analysis is an *incident-scoped* capability, not an integration-wide one — the incident already has analyse/re-check (ISE-94), diagnose and verify, all landing on the timeline; the system-scope "AI looks at this system" need is served by the AI summary card (summarise-state), which describes rather than raises.

## Remove

- **Frontend**: `RunAnalysisButton` in `SystemDetailPage.tsx` (+ tests). Nothing replaces it — see ISE-166 (its original item 3, "move Run analysis onto the AI summary card", is superseded by this removal).
- **Backend**: `POST /api/v1/systems/{system_id}/analyse` (`systems.py:136`), the `analyse_system` Celery task (`tasks/ai/analyse.py`), and `run_analysis`/`_persist_issues` in `ai/analysis.py`.
- **Check before deleting shared machinery**: the `analyse` agent/task-type is shared — the incident-scoped re-check (`analyse_issue`) and verify have their own paths; confirm what still references the system-scoped `analyse` task type (AI model config seeding, budget/tier tables) and retire only the unreferenced parts.

## Keep

- `"ai"` stays in `ISSUE_SOURCES` (`models.py:28`) — existing incidents carry it and the check constraint must keep validating them; it simply stops being producible.
- AI summary card (summarise-state), incident-scoped analyse/diagnose/verify — untouched.

## ADR

Retiring a capability (AI can propose incidents unprompted) is an architecture decision — add a short ADR at the next free number: "AI analysis does not create incidents" — extends ADR 0025/0030, closes the loop the Sprint 14 timer retirement left open; ADR 0025 §4's enumerated open paths become literally true.

## Verification

System page (both DataDog and g5) shows no Run analysis button; `POST /systems/{id}/analyse` returns 404/405; no code path can construct `source='ai'` issues; existing `source='ai'` incidents still load, filter and resolve normally; backend + frontend test suites green.
---
id: 01KXP53E6Q2YT2T5SV301RJ9VE
created: 2026-07-16T19:05:22.903528555Z
updated: 2026-07-21T09:53:41.834988Z
type: task
title: Analyse this issue — re-check whether the condition still holds
project: 01KX671DATY39VW6GWK3M2T3DN
number: 94
sprint: s0v93ii
blocked_by:
- 01KXP51V7CR9VDWE6Z4T9WEV1F
assignee: steve
label: null
priority: medium
task_status: done
---
ISE-88's **Analyse** step: an operator (or the chat) asks "does this issue's condition still exist, or has it resolved?" Today `analyse` is Beat-only (`worker.py:70-73`), **per-system**, and *creates* issues (`ai/analysis.py:54-108`) — there is no way to re-evaluate one existing issue. Add that.

**Endpoint:**
- `POST /api/v1/issues/{id}/analyse` (operator, `202`, mirrors the diagnose trigger `issues.py:84-95`) → Celery task on the `ai` queue → `run_agent(...)`.

**Agent behaviour:**
- Either a new `analyse-issue` task type or a scoped variant of `analyse`, registered in `AGENTS` (`ai/agents.py:341`). Read-only tools only.
- Structured output (ADR 0013): a verdict — `still_present` / `appears_resolved` / `changed` — with a fresh evidence chain compared against the issue's original evidence. If `appears_resolved`, it **recommends** (does not force) resolution; the operator or the loop still decides via the lifecycle controls.
- Records an `AgentRun` + surfaces as a timeline event (ISE-92). Callable from the Analyse button (ISE-98) and the `trigger_analyse` tool (ISE-93).

Blocked by the ADR (ISE-89). Label: feature.
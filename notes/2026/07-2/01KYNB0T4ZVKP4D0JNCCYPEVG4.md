---
id: 01KYNB0T4ZVKP4D0JNCCYPEVG4
created: 2026-07-28T21:45:15.679816Z
updated: 2026-07-28T22:23:14.661373Z
type: task
title: Status page AI fallback parsing + tracked-service matching
project: 01KX671DATY39VW6GWK3M2T3DN
number: 354
sprint: s9cqr80
blocked_by:
- 01KYNB0HDA8Z6HCTHHQ0ZN70YX
assignee: steve
label:
- feature
priority: medium
task_status: active
---
HTML-only status pages work, and the "services we use" description actually drives what is tracked.

**AI fallback parsing**
- New AI task type `parse_status_page`: add to `AI_TASK_TYPES` + `AI_TASK_DESCRIPTIONS` (`models.py`); `AgentDefinition` in `ai/agents.py` (BEGIN/END untrusted-content fencing, char cap like `MAX_DOCUMENT_PROMPT_CHARS`, `tools=()`, Pydantic output = the same normalised state shape the deterministic parsers emit); `PER_TASK_RUN_MAX_TOKENS` entry (`engine.py`); migration extending the `ai_model_config.task_type` check constraint (pattern: `0068_run_playbook_task_type`). Test: `test_per_task_run_caps.py`.
- Invoked ONLY when no deterministic parser matches AND the content hash changed (change-driven, never clock-driven — `summarise-document` convention). Runs through `engine.run_agent` so spend limits/budget apply. HTML pre-reduced to text (Confluence `_to_text` pattern).
- Settings → AI shows the task automatically once registered; NOTE: set its model on staging after deploy (past gotcha).

**Tracked-service matching**
- Match the entry's free-text services_description against the discovered component list: exact/fuzzy name match first, AI assist for the remainder. Persist the tracked-service set on the entry; re-run matching when the component list changes.
- Detail page: tracked set editable (tick/untick components), showing which were auto-matched vs hand-picked.

**Acceptance**: an HTML-only status page yields parsed state (visible on detail) with an AgentRun recorded and capped; unchanged content triggers zero AI calls; description "we use CDN and DNS" tracks exactly those components; manual override sticks across polls.
---
id: 01KYNB0T4ZVKP4D0JNCCYPEVG4
created: 2026-07-28T21:45:15.679816Z
updated: 2026-08-05T14:48:48.546699Z
type: task
title: Status page AI fallback parsing + tracked-service matching
project: 01KX671DATY39VW6GWK3M2T3DN
number: 354
sprint: s9cqr80
blocked_by:
- 01KYNB0HDA8Z6HCTHHQ0ZN70YX
comments:
- id: 01KYNDP59K8Z3G3FCNPFJMABC4
  author: Steve Vine
  at: 2026-07-28T22:31:52.371706Z
  text: |-
    Built and in review. PR #328 (stacked: #325 → #326 → #327 → #328), merged to staging.

    Delivered: AI task type parse-status-page (AgentDefinition with untrusted-content fencing, 60k char cap, tools=(), Pydantic output = the normalised parser shape + a tracked_services judgement; 45k run cap; migration 0071 recreates the ai_model_config check + adds status_page.tracked_source). Change-gated: HTML pages parse only on a moved content hash; matching is deterministic-first (verbatim names; empty description = track nothing; fully-verbatim description never calls a model) with the AI judging exclusions/phrases; AI failure degrades to the name match. Manual override: tick/untick components on detail (tracked_source=manual, never overwritten), "Re-match automatically" hands back to auto; description edits clear an auto set for re-matching. Settings → AI lists the task automatically.

    REMINDER for staging smoke: set the parse-status-page model in Settings → AI after deploy (run_playbook precedent).

    Gates: backend ruff/mypy/pytest green (41 tests incl. per-task caps + worker guard + migration check), frontend build + 435 vitest + prettier green.
assignee: steve
priority: medium
task_status: done
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
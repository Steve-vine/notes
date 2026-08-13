---
id: 01KZEPX1EN1FEVG34T5V9HTY15
created: 2026-08-07T18:13:55.797407Z
updated: 2026-08-13T19:00:02.036124Z
type: task
title: AI-drafted report queries
project: 01KX671DATY39VW6GWK3M2T3DN
number: 619
sprint: sw5yz4n
blocked_by:
- 01KZEPWE659A7HYH9B869W15AX
comments:
- id: 01KZP282Q0BCR933Y9H9W7WADW
  author: Steve Vine
  at: 2026-08-10T14:46:52.896655Z
  text: |-
    Built and pushed as PR #580 (branch feature/ise-619-ai-drafted-queries, last in the stack). Migration **0122** (not 0107 — other sprints landed in between); api-types regenerated.

    Done = describe a report in English, review the drafted spec in the builder, save it unchanged. `output_type = ReportQuerySpec`, so the drafted object IS the saved object — no translation step, and the API's own validator is what the draft is checked against.

    **The prompt's real work is the vocabulary.** A model asked to filter an estate it cannot see invents plausible keys — `launched_at` for `launch_time` — and a spec naming an attribute the estate does not have returns zero rows and reads as "nothing matches": silent, and indistinguishable from a true answer. So:
    - new `attribute_key_inventory(db)` (`jsonb_object_keys` grouped by type) puts the keys that actually exist in the prompt, ordered by how many entities carry each so the per-type cap drops the long tail rather than an alphabetical slice. Retired entities contribute nothing — reports exclude them by default, so their keys would offer filters the default report cannot match.
    - **groups are listed by ID, not name.** A model cannot guess a UUID, so without them a group-scoped description silently comes back UNSCOPED. A test drafts a group scope and previews it end to end.

    Other decisions:
    - **Sonnet, not the cheap tier the other extractors use** — they summarise prose; this composes a typed object over a supplied vocabulary, and a draft the operator has to correct every time is a draft nobody uses.
    - **Nothing is persisted** (computed on read, learning-endpoint precedent). The AgentRun id comes back so the call is traceable in the spend surfaces.
    - **A refusal surfaces the agent's own reason as a 503** — "no model configured", "daily ceiling reached" and "provider down" have three different fixes, and "Draft failed" hides all of them.
    - **A drafted spec that does not validate is refused, not returned** — otherwise the builder lands in a state the save endpoint then rejects.
    - **The draft REPLACES the spec rather than merging** — half a previous query under a new draft is a query nobody wrote.

    Correction to the task's plan: `agent_run.task_type` carries NO check constraint (only `ai_model_config.task_type` does), so the planned "insert agent_run rows at N-1, upgrade, rows survive" data-path test had no constraint to exercise. The migration rebuilds the ai_model_config CHECK and seeds the config row instead — without a row an unconfigured type never runs and the Draft button would do nothing, silently.

    Also found and fixed a CI-only failure in ISE-616 while here: `delete_report` enqueues the artifact purge, and test_reports_api.py has no broker. The stub already existed on the ISE-617 branch, so the parent PR was red on its own — a stacked chain hides exactly this, because the parent is only ever exercised locally with its child's changes present.
assignee: steve
label:
- feature
priority: medium
task_status: done
tech: null
---
Describe a report in English; AI drafts the spec; user reviews, previews, saves — runs never touch AI. New `draft-report-query` task type (AI_TASK_TYPES + descriptions + migration 0107 rebuilding the agent_run CHECK — 0104 precedent; stacks on 0106 per the parallel-migration rule). AgentDefinition with `output_type = ReportQuerySpec` (drafted object IS the saved object), no tools; prompt embeds ENTITY_TYPES, AttributeOp vocabulary, built-in columns, identity-groups, and a new `attribute_key_inventory(db)` helper (jsonb_object_keys by type). `POST /api/v1/reports/draft-query {description} → {spec}`, computed on read like the learning endpoint, operator-gated, AgentRun recorded for spend. Modal gains the Draft-with-AI panel populating the builder.

Done = a described report drafts into the builder and saves unchanged. Carries migration 0107; api-types regen. Depends on the definitions task; last in the stack. Migration data-path test: insert agent_run rows at 0106, upgrade, rows survive.
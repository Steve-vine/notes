---
id: 01KYA2SPEE6V6ZKC2TSBNG28G2
created: 2026-07-24T12:49:55.150377Z
updated: 2026-07-24T16:07:41.112536Z
type: task
title: 'Settings → AI models: describe each task type and prune retired ones'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 247
sprint: sthz8ne
comments:
- id: 01KYA6KQ55375D6BWD8DN0GN9J
  author: Steve Vine
  at: 2026-07-24T13:56:33.573064Z
  text: |-
    Done — PR #231 (feature/ise-247-describe-prune-task-types → main).

    - Added canonical constants to models.py: RETIRED_AI_TASK_TYPES (=("analyse",)), ACTIVE_AI_TASK_TYPES, and AI_TASK_DESCRIPTIONS (plain-English "what it does / what triggers it" for every task type). Single source of truth — ISE-250's By-Task panel will reconcile against these.
    - GET /ai-config now lists every ACTIVE task type in canonical order (not just seeded rows), each carrying a description + a `configured` flag; retired `analyse` is omitted entirely.
    - PUT /ai-config/{task_type} rejects retired types with 404 — "cannot be configured" enforced server-side, not just hidden in the UI. Body validation still fires first, so an active type with a bad provider still 422s.
    - AIModelsCard renders the description under each task and flags unconfigured types ("running on the deployment default — set a model to override").

    Tests updated (analyse excluded, descriptions/configured asserted, retired-PUT→404). API types regenerated. Backend AI-config suite green; frontend build + prettier + eslint clean (0 errors).

    Note: `analyse` stays in AI_TASK_TYPES and keeps its seeded row so historical agent_run rows still validate — only its configurability is removed.
assignee: steve
label: null
priority: medium
task_status: review
---
The AI tab's models card (`AIModelsCard.tsx`) lists bare task-type rows, and only those with a saved `ai_model_config` row — no explanation of what each task does, and no guarantee the list matches reality.

- Add a plain-English description per task type (what it does, what triggers it): summarise-state (on-demand estate summary), diagnose, propose-remediation, analyse-issue (per-issue re-check, ISE-94), execution-followup, assist (global chat), issue-chat (per-issue chat), summarise-document, extract-document-claims.
- List all **active** task types, not just those with a config row (canonical set: `AI_TASK_TYPES`, `models.py:54-77`).
- **Prune retired types**: `analyse` (system-scoped scheduled analysis) was removed entirely in ISE-167/ADR 0034 — no agent definition, no call site; it survives only so historical `agent_run` rows validate. It must not be offered for configuration (hide, or mark "retired" if it has historical spend).

Acceptance: an operator reading the AI tab can tell what each model row is for; retired task types cannot be configured.
---
id: 01KYA2SPEE6V6ZKC2TSBNG28G2
created: 2026-07-24T12:49:55.150377Z
updated: 2026-07-24T13:29:21.971345Z
type: task
title: 'Settings → AI models: describe each task type and prune retired ones'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 247
sprint: sthz8ne
assignee: steve
priority: medium
task_status: backlog
---
The AI tab's models card (`AIModelsCard.tsx`) lists bare task-type rows, and only those with a saved `ai_model_config` row — no explanation of what each task does, and no guarantee the list matches reality.

- Add a plain-English description per task type (what it does, what triggers it): summarise-state (on-demand estate summary), diagnose, propose-remediation, analyse-issue (per-issue re-check, ISE-94), execution-followup, assist (global chat), issue-chat (per-issue chat), summarise-document, extract-document-claims.
- List all **active** task types, not just those with a config row (canonical set: `AI_TASK_TYPES`, `models.py:54-77`).
- **Prune retired types**: `analyse` (system-scoped scheduled analysis) was removed entirely in ISE-167/ADR 0034 — no agent definition, no call site; it survives only so historical `agent_run` rows validate. It must not be offered for configuration (hide, or mark "retired" if it has historical spend).

Acceptance: an operator reading the AI tab can tell what each model row is for; retired task types cannot be configured.
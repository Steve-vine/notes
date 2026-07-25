---
id: 01KYD7H8P7Z679PPX3B2YY9QT7
created: 2026-07-25T18:10:25.095053Z
updated: 2026-07-25T18:11:03.809769Z
type: task
title: Refresh the AI briefs to post-sprint reality
project: 01KX671DATY39VW6GWK3M2T3DN
number: 296
sprint: svgrad3
blocked_by:
- 01KYD59GBJHNSQGZZK7NETEYBH
- 01KYD5A2FFFNF16H6V5D248CVF
assignee: steve
label:
- brief
- chore
priority: medium
task_status: backlog
---
**Sprint 24 closing task — docs only.** The `ai-interaction-map` carries an explicit maintenance contract ("when a surface's context, tools, caps or triggers change, update the relevant section and the two glance tables") and batches 1–3 changed nearly all of it.

- **ai-interaction-map.md**: caps table (per-task run caps ISE-286, current admin overrides, fresh-token guard semantics once ISE-294 lands, chat cap); tool-exposure matrix (issue-chat AND assist now have Evidence; issue-chat has retrieval tools + commit_diagnosis); analyse-issue section (cheap-verdict-first pre-check, 60k cap); diagnose/propose sections (slim header + pulled bounded context, not the force-fed block); issue-chat section (investigation memory preamble, ISE-288); "where the tokens go" (describes the pre-fix world — rewrite as "what was fixed and what the shape is now").
- **ai-limitations-catalogue.md**: L9–L15 are all resolved — mark each verdict's outcome with the task/ADR that closed it (L9→ADR 0049/ISE-280+287, L10→ISE-288, L12 note, L13/L14→ISE-282, L15→ISE-283).
- **ai-token-spend-audit.md**: add an outcome note — recs 1–5 all shipped (282/281/283/286) + the two live-found corrections (ISE-294 guard metric, ISE-295 killed-run breakdown); instrumentation now exists, so its "first job" hand-off points to the measured-numbers pass task.
- **ai-engine.md**: spot-check for statements the sprint made false (chat tool surface, context assembly) and note ADRs 0049/0050.

Best done after ISE-294/295 merge so the caps table is written once.
---
id: 01M127FZFF34G4ZQBADD6FVW41
created: 2026-08-27T18:25:09.615006Z
updated: 2026-08-27T18:25:43.07725Z
type: task
title: Approval routing can threshold on the risk tier
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 476
sprint: sd9gmcq
blocked_by:
- 01M127FSZA2R0DQJV54GBWF0DS
assignee: steve
company: null
label:
- feature
priority: medium
task_status: backlog
---
ADR 0060 §7. A `min_risk_tier` rule kind joins `min_criticality` and `min_sensitivity` on `approval_rules` (ADR 0039 §6, ADR 0042 §3) — required when the engagement's effective tier is at or above the threshold.

This is the one downstream consumer the ADR requires; review cadence by tier, questionnaire by tier and expected assurance evidence by tier are the follow-on work that makes the tier worth having rather than a badge.

Existing rules are unaffected. Include the new kind in the creatable set and the Admin rule editor.
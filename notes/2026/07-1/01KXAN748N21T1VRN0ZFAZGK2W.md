---
id: 01KXAN748N21T1VRN0ZFAZGK2W
created: 2026-07-12T07:56:07.829641823Z
updated: 2026-07-12T15:25:49.769830707Z
type: task
title: UI — model config + AI spend in Settings
priority: medium
task_status: review
assignee: steve
project: 01KX671DATY39VW6GWK3M2T3DN
number: 42
blocked_by:
- 01KXAN69WYA8JMKQ2RC69CEMAP
- 01KXAN6FR3SF2G2SGM56A419Z7
sprint: syv1q8m
---
Admin-editable per-task-type model selection (provider/model/settings/fallback) as sibling Card sections in SettingsPage (card-per-section pattern), writing the ai_model_config store — no redeploy to switch Claude↔OpenAI. Daily-ceiling display + a banner when a provider ceiling is crossed. Per-system & per-task-type AI spend aggregates from AgentRun.cost_usd. Admin-gated (hasRole admin) like Integrations. Uses generated types.
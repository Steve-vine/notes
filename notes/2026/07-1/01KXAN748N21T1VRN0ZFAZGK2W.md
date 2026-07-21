---
id: 01KXAN748N21T1VRN0ZFAZGK2W
created: 2026-07-12T07:56:07.829641823Z
updated: 2026-07-21T08:39:12.63281Z
type: task
title: UI — model config + AI spend in Settings
project: 01KX671DATY39VW6GWK3M2T3DN
number: 42
sprint: syv1q8m
blocked_by:
- 01KXAN69WYA8JMKQ2RC69CEMAP
- 01KXAN6FR3SF2G2SGM56A419Z7
assignee: steve
priority: medium
task_status: done
---
Admin-editable per-task-type model selection (provider/model/settings/fallback) as sibling Card sections in SettingsPage (card-per-section pattern), writing the ai_model_config store — no redeploy to switch Claude↔OpenAI. Daily-ceiling display + a banner when a provider ceiling is crossed. Per-system & per-task-type AI spend aggregates from AgentRun.cost_usd. Admin-gated (hasRole admin) like Integrations. Uses generated types.
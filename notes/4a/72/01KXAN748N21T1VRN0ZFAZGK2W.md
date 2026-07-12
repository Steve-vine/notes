---
id: 01KXAN748N21T1VRN0ZFAZGK2W
created: 2026-07-12T07:56:07.829641823Z
updated: 2026-07-12T07:56:07.829641823Z
type: task
title: UI — model config + AI spend in Settings
priority: medium
task_status: backlog
assignee: steve
project: 01KX671DATY39VW6GWK3M2T3DN
number: 42
---
Admin-editable per-task-type model selection (provider/model/settings/fallback) as sibling Card sections in SettingsPage (card-per-section pattern), writing the ai_model_config store — no redeploy to switch Claude↔OpenAI. Daily-ceiling display + a banner when a provider ceiling is crossed. Per-system & per-task-type AI spend aggregates from AgentRun.cost_usd. Admin-gated (hasRole admin) like Integrations. Uses generated types.
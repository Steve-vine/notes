---
id: 01M5VNMAY1XS11K8ACJKT95J4Z
created: 2026-10-26T08:36:00.577321Z
updated: 2026-10-26T08:36:29.028996Z
type: task
title: 'Admin ▸ Polaris: spend tracker — the last 30 days by provider (Anthropic, OpenAI) as a graph, with this month''s total'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1335
sprint: s9ls6e7
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
## Behaviour

- **A Spend card** at the foot of Admin ▸ Polaris.
- **The graph** shows the last 30 days, one bar per day, stacked by provider (Anthropic and OpenAI), in US dollars.
  - Today's bar fills in as the day goes on.
  - A provider that wasn't used isn't shown.
  - Hovering a day shows each provider's spend and the day's total.
  - The day limit is drawn as a line across the graph, so you can see how close each day came.
- **Above the graph:**
  - "Last 30 days: $X";
  - "This month: $Y";
  - "Today: $Z of $limit".
- **Under the graph**, a small table by model, for the 30 days: provider, model, spend, prompts.
- Every figure is marked as an estimate at list price. The provider's own bill is the real figure.
- Spend for deleted conversations still counts.

## My calls (awaiting Steve)

- Stacked daily bars rather than a line per provider, because the question is "what did we spend each day".
- A per-model table. No per-person spend this sprint: you asked by provider, and per-person spend is easy to add later.

## Notes

- **On the chain** only for API: a `usage/daily` read-out by provider and model; regenerate schema.d.ts. No migration, because it reads `polaris_usage` from the engine task.
- Days are calendar days in Compass's time zone (ADR 0121).
- Charts: `@mantine/charts` pinned to the core version ([[mantine-charts-version-pin]]); BarChart `type="stacked"` plus a referenceLine for the limit.
- Follow the dataviz palette and dark-mode rules already used by the Compliance charts.

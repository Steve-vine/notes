---
id: 01M5Y9ECE34E4D2A30HZEZKRQ5
created: 2026-10-27T09:00:45.891108Z
updated: 2026-10-27T09:05:09.602783Z
type: task
title: Anthropic and OpenAI become tiles holding Polaris's keys — choosing the model, the limits and the spend stay on Admin ▸ Polaris
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1356
sprint: s8fmesf
blocked_by:
- 01M5Y9C3P6MGA186PBB0BF38C4
comments:
- id: 01M5Y9PDZ2H7DD0ZMECHZM8RYJ
  author: Steve Vine
  at: 2026-10-27T09:05:09.602612Z
  text: 'Cancelled 2026-10-27. Steve: "I don''t think polaris should be treated as an integration, that can stay how it is now." Admin ▸ Polaris keeps its provider keys, model, limits and spend exactly as today, and there are no Anthropic or OpenAI tiles. COM-1347, COM-1348 and COM-1360 were updated to match.'
assignee: steve
label:
- feature
priority: medium
task_status: cancelled
---
Sprint 90, Integrations (ADR in COM-1347). Builds on COM-1349.

## What people see

- **Two tiles in the AI category: Anthropic and OpenAI.**
- **Overview:** Polaris uses the organisation's own key with that provider (ADR 0127). What is sent: the conversation and the results of the tools it uses. Nothing is sent unless Polaris is on.
- **Configure:** the key (write-only, last four shown) and, for OpenAI, the organisation and project. Saving checks the key by listing the models, as today.
- **Features:** **Polaris**, on when this is the provider Polaris uses. Choosing it here or on Admin ▸ Polaris is the same setting.
- **Status:** whether the key was accepted at the last check, and the last error Polaris got from the provider.
- **Admin ▸ Polaris keeps:** on/off, the provider and model, the hourly and daily limits, and Spend. Its Providers panel becomes a line per provider linking to its tile.

## Who can do what

Manage Polaris, as today.

## Notes (technical)

- Move `admin/polaris` Providers into the tiles. `polaris_providers` and `polaris_settings` are unchanged.

**Chain:** on the chain (API, if the provider status needs a field).

**Done when:**
- a key is added and checked on its tile;
- Polaris answers with it;
- Admin ▸ Polaris no longer holds keys.
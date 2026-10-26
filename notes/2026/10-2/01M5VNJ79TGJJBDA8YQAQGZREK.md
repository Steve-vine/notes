---
id: 01M5VNJ79TGJJBDA8YQAQGZREK
created: 2026-10-26T08:34:51.322221Z
updated: 2026-10-26T08:36:25.251715Z
type: task
title: 'Admin ▸ Polaris: switch Polaris on, connect Anthropic or OpenAI with your own key, and choose the model — plus the "Use Polaris" and "Manage Polaris" grants'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1327
sprint: s9ls6e7
assignee: steve
label:
- feature
priority: high
task_status: todo
---
## Behaviour

- **There's a new Admin tab, Polaris**, for people who hold *Manage Polaris*.
- **Providers card.** It has one row each for Anthropic and OpenAI.
  - **Connect** asks for the API key. OpenAI also takes an optional organisation and project.
  - The key is checked before it's saved. A wrong key says so and saves nothing.
  - Once saved, a key is never shown again, only "…last 4" with **Replace** and **Remove**.
  - Removing the active provider's key switches Polaris off.
- **Model card.**
  - Choose the active provider. Only a connected one can be chosen.
  - Then choose a model from the models that key can use, listed by the provider.
  - Each model shows its price per million tokens, read and written. Compass knows the prices of the current Anthropic and OpenAI models.
  - **A model Compass has no price for** can be chosen only after the administrator enters its two prices, because the spend limits can't work without them. Known prices can be corrected the same way.
- **The Polaris switch** sits at the top of the tab. It turns on only when:
  - a provider is connected,
  - a model is chosen, and
  - both spend limits are set (COM spend limits task).

  While it's off, nobody sees the Polaris button.
- **A note under the switch** says that what Polaris reads in Compass is sent to the chosen provider, so it's covered by the provider's terms.
- **Grants:** *Use Polaris* and *Manage Polaris*, in a Polaris group on the roles screen. The built-in Admin role holds both. Portal accounts can never hold either (ADR 0067 §3).
- Every change on this tab is in the activity log. A key appears there only as "key replaced".

## My calls (awaiting Steve)

- Both keys can be stored, but one provider is active.
- Compass ships list prices, and an admin can override them.

## Notes

- **On the chain:**
  - migration: `polaris_settings` (single row) and `polaris_providers` (key in `secretbox`, last4, org/project), plus `polaris_model_prices`;
  - API: `/api/v1/admin/polaris` …, regenerate OpenAPI/schema.d.ts;
  - permissions `polaris.use` and `polaris.manage`.
- Validate a key with the provider's models list endpoint. That same endpoint fills the model picker.
- Keys never appear in logs. Add them to the redaction list.
- Secrets never reach the MCP: no assistant tool reads or sets this tab.

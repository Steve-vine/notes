---
id: 01M5VNJ79TGJJBDA8YQAQGZREK
created: 2026-10-26T08:34:51.322221Z
updated: 2026-10-26T10:10:23.178039Z
type: task
title: 'Admin ▸ Polaris: switch Polaris on, connect Anthropic or OpenAI with your own key, and choose the model — plus the "Use Polaris" and "Manage Polaris" grants'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1327
sprint: s9ls6e7
blocked_by:
- 01M5VNHT9PAKXB1DFTVWQY52GY
comments:
- id: 01M5VV13Z6WH8J370RRF4BC2BK
  author: Steve Vine
  at: 2026-10-26T10:10:22.309928Z
  text: |-
    Done — merged to main (PR #1343, migration 0704).

    - Admin ▸ Polaris is a new tab, between Email and Attachments. **Manage Polaris** opens it; that grant alone also shows the Admin section.
    - **The switch is greyed out until nothing is missing**, and the missing items are listed under it: provider, model, prices and spending limits. Below it is the note that what Polaris reads is sent to the chosen provider.
    - **Providers card:**
      - Connect, Replace and Remove for Anthropic and OpenAI. OpenAI also takes an optional organisation and project.
      - The key is checked with the provider (by listing its models) before it's saved. If the provider refuses it, its words show in the dialog and nothing is saved.
      - A saved key is never shown again, only "Key …abcd · connected by …".
      - Removing the active provider's key switches Polaris off.
    - **Model card:**
      - Only connected providers can be chosen. The model list comes from the key, each with its price per million tokens, or "no price".
      - Choosing an unpriced model asks for its prices first.
      - Edit price, and "Use Compass's price" to go back from your own.
    - **Compass's price list** was taken from Anthropic's and OpenAI's pricing pages today.
    - **The grants:** Use Polaris and Manage Polaris are in their own Polaris group on the roles screen, and the built-in Admin role holds both.
    - **The activity log** records every change on the tab. A key shows only as "Anthropic key …abcd".

    My calls (beyond the task):
    - **The switch is greyed out** while something is missing, rather than clickable and then refused.
    - **The tab sits after Email**, because it's a connection like Integrations and Email.
    - **OpenAI's list is filtered to text models.** Embeddings, speech, image and moderation models are left out.
    - **Tests use the official SDKs against a stand-in.** Nothing has met a real Anthropic or OpenAI key yet; your smoke test will be the first.
assignee: steve
label:
- feature
priority: high
task_status: review
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

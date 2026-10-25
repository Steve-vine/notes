---
id: 01M5T745CMMSJDD4K6EGJSX49Q
created: 2026-10-25T19:03:16.116386Z
updated: 2026-10-25T19:03:16.116386Z
type: task
title: 'Trust Centre Settings: a "Questionnaires" switch, and who receives the questionnaires visitors send'
label: feature
assignee: steve
task_status: todo
priority: medium
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1318
---
## Behaviour

- Trust Centre ▸ Settings gets a **Questionnaires** section:
  - **"Questionnaires through the Trust Centre"**: on or off, off by default. While it's on, visitors can send questionnaires and completed DDQs can be sent through the Trust Centre (COM-1316).
  - **"New questionnaires go to"**: a person who can manage DDQs for this company. They become the owner of every questionnaire a visitor sends, and get its to-do.
  - **Default due date**: used when a visitor doesn't give one. 10 working days after it arrives by default (ADR 0121 working days).
- **The switch can't be turned on without someone to receive questionnaires.** If that person later loses Manage DDQs, or leaves, incoming questionnaires go to nobody. The Settings card then shows a warning, and everyone who can manage the trust centre gets a to-do "Choose who receives questionnaires". A questionnaire that arrives meanwhile is still logged, with no owner, and appears in that to-do.
- **The switch respects the portal switch.** With the portal off, nothing about questionnaires is reachable either.
- **Switching it off:**
  - visitors no longer see "Send us a questionnaire";
  - questionnaires already sent in, and DDQs already shared, stay readable in their area until each visitor's access ends;
  - "Send via Trust Centre" disappears from DDQs.
- Changes are in the activity log, like every other setting.

## My calls (awaiting Steve)

- It lives in Trust Centre Settings, not DDQ Settings, because it's about what the portal offers. DDQ ▸ Settings shows a one-line pointer to it.
- 10 working days as the default due date.
- Switching off doesn't take away what's already been shared. Revoking a visitor or stopping sharing a DDQ does that.

## Notes

- **On the chain:** migration (columns on `trust_centre_settings`: `questionnaires_on`, `questionnaires_owner_id` FK users SET NULL, `questionnaire_due_days`) and API (settings schema → OpenAPI/schema.d.ts regen).
- The owner must hold `ddq.manage` for the company (`core/ddqs.resolve_owner`). The "choose who receives" to-do is an Actions source (ADR 0055), never a `notify()`.
- Assistant: `trust_centre_get_settings` / `trust_centre_save_settings` carry the new fields.

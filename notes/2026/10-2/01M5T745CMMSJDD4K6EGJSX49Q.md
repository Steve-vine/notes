---
id: 01M5T745CMMSJDD4K6EGJSX49Q
created: 2026-10-25T19:03:16.116386Z
updated: 2026-10-26T08:03:46.715563Z
type: task
title: 'Trust Centre Settings: a "Questionnaires" switch, and who receives the questionnaires visitors send'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1318
sprint: snfoon1
comments:
- id: 01M5TMZ15BYQMJ8WVRACWK0VRW
  author: Steve Vine
  at: 2026-10-25T23:05:08.011359Z
  text: |-
    Done — merged to main (PR #1334).

    - Trust Centre ▸ Settings has a new **Questionnaires** panel:
      - **"Questionnaires through the Trust Centre"**: off by default. It works only while the portal is on.
      - **"New questionnaires go to"**: anyone who can manage DDQs, with "Assign to me".
      - **"Due by default"**: 10 working days, from 1 to 90.
    - **It can't be switched on without someone to receive questionnaires.**
    - **If that person is later disabled, or loses Manage DDQs:**
      - the card shows "Questionnaires go to nobody" and says why;
      - everyone who manages the trust centre gets a to-do, "Choose who receives questionnaires sent through <company>'s trust centre", which links to Settings;
      - the to-do goes once someone is chosen or the switch is turned off.
    - DDQ ▸ Settings has a one-line pointer to it.
    - Polaris can read and change all three settings.

    My calls (beyond the task):
    - **A receiver who has lapsed doesn't block saving other settings** (the title, say). Switching back on does ask again.
    - **The to-do goes to everyone who manages the trust centre**, matching the document-expiry to-do.
assignee: steve
label:
- feature
priority: medium
task_status: done
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

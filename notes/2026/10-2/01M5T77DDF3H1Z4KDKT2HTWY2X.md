---
id: 01M5T77DDF3H1Z4KDKT2HTWY2X
created: 2026-10-25T19:05:02.639697Z
updated: 2026-10-26T08:03:46.791375Z
type: task
title: 'Polaris: questionnaires through the Trust Centre — see where a DDQ came from and who it''s shared with, send one via the Trust Centre, stop sharing'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1325
sprint: snfoon1
blocked_by:
- 01M5T772S0TZ34RYD7KBZ2GWJX
comments:
- id: 01M5TYZ9DP1WGR261M4MP01W5H
  author: Steve Vine
  at: 2026-10-26T02:00:02.230585Z
  text: |-
    Done — merged to main (PR #1341).

    - **New Polaris tools:**
      - **ddq_preview_trust_centre_send** (read-only): whether a DDQ can go through the Trust Centre now and why not, what goes (the completed questionnaire, evidence files, how many held back), and for each address whether they're a new visitor or an existing one getting a fresh link, and whether they're at another domain.
      - **ddq_send_via_trust_centre** (marked destructive): sends to the people named, or the contact if none. Its description says it emails people outside the company and freezes an unsent DDQ, and to preview and confirm first.
      - **ddq_stop_trust_centre_sharing** (marked destructive): finds the person by name or email, with an optional reason.
    - **Reading:**
      - ddq_list_ddqs and ddq_get_ddq say when a DDQ was sent in through the Trust Centre (by whom, and their note) and who it was shared with: each person's access, when they last opened it, and what they downloaded.
      - trust_centre_get_visitor lists the visitor's questionnaires.
      - trust_centre_get_settings already showed the Questionnaires settings (COM-1318).
    - **Same rules as on screen:** without Manage visitors, sending and stopping are refused.
    - **Polaris's instructions now cover it:** a questionnaire can arrive through the Trust Centre (Received, waiting to be set up), and a completed one can go back that way. It's told to preview, say who will be emailed and that the DDQ will be frozen, then send.

    My calls:
    - **Preview and send are two separate tools**, matching the window and the "preview first" rule.
    - **Stopping finds the person by name or email** among those it's still shared with. An unclear name is refused with the list to choose from.
assignee: steve
label:
- feature
priority: medium
task_status: done
---
## Behaviour

Polaris can do what the person can on screen, with the same rules (ADR 0109):

- **Reading:**
  - `ddq_get_ddq` and `ddq_list_ddqs` say when a DDQ was received through the Trust Centre (from whom, and their note), and who it's been shared with, with opened and downloaded dates.
  - `trust_centre_get_visitor` lists the visitor's questionnaires.
  - `trust_centre_get_settings` shows the Questionnaires switch and who receives them.
- **New tools:**
  - **`ddq_send_via_trust_centre`:** the COM-1322 action, for recipients and an optional note. Its description says it **emails people outside the company and marks the DDQ as sent (frozen)**, so Polaris says both before calling it. It previews first, the same as the window.
  - **`ddq_stop_trust_centre_sharing`:** stops sharing with one person.
- **When a questionnaire arrives**, the owner's to-do says "set it up with Polaris". Polaris's existing layout set-up (`ddq_set_up_layout`) works on it unchanged, whether the format is a file, pasted text (Email) or Online.
- Polaris **can't** upload files, add files on a visitor's behalf, or fetch what a visitor would see.

## Notes

- **On the chain, at the end** (tools wrap the routes from COM-1318..1324).
- `assistant/tools/ddq.py` and the trust_centre module. Tools are auto-discovered; follow how a tool is added in the MCP sprint (memory: mcp-sprint-70). Update the tool-count tests.
- Destructive/sending tools are marked as such.

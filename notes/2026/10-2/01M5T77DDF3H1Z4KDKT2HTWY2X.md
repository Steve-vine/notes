---
id: 01M5T77DDF3H1Z4KDKT2HTWY2X
created: 2026-10-25T19:05:02.639697Z
updated: 2026-10-25T19:05:27.041289Z
type: task
title: 'Polaris: questionnaires through the Trust Centre — see where a DDQ came from and who it''s shared with, send one via the Trust Centre, stop sharing'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1325
sprint: snfoon1
blocked_by:
- 01M5T772S0TZ34RYD7KBZ2GWJX
assignee: steve
label:
- feature
priority: medium
task_status: todo
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

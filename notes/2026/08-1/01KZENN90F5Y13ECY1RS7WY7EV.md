---
id: 01KZENN90F5Y13ECY1RS7WY7EV
created: 2026-08-07T17:52:12.815739Z
updated: 2026-08-07T18:58:31.176868Z
type: task
title: 'Breakglass slice 3: the record — timeline, Platform Log, Teams System event, statusline (ADR 0089)'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 613
sprint: snk16ew
assignee: steve
label: null
priority: medium
task_status: todo
---
Slice 3 of 4 of the breakglass build (split from ISE-592, which carries slice 1).

**The audit trail is the product.** The legible trail is what going-direct can never provide — it is the whole justification for the mode existing, so it is a deliverable and not a side effect.

- **Incident timeline event** on every armed/disarmed/expired transition, so the incident's own story shows the window opening and closing in line with everything else.
- **Platform Log** entry on each transition (remember: a `logger.warning` is a user-visible screen row — put diagnosis in `extra`).
- **Teams System event** notification on arm AND on end, so the channel shows the window closed, not just opened. ISE-591 built the System event type; breakglass is its first producer.
- **`GET /mcp/session`** carries the armed state and remaining minutes, so the Claude Code statusline sidecar shows it in the terminal.
- No mandatory post-hoc review (Steve, 2026-08-06): the stamps, the timeline block and the Teams events ARE the record. A review queue would add ceremony the access-parity argument says nobody will honour.

`breakglass.remaining_seconds()` already exists from slice 1 for the statusline and the banner.

Depends on ISE-592 (slice 1). Independent of slice 2.
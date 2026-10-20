---
id: 01M5BSZRJH83MRYQQBRP2F4D94
created: 2026-10-20T04:44:18.385052Z
updated: 2026-10-20T12:39:21.863656Z
type: task
title: A request's timeline never names a recipient from a disclosure the reader can't see
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1148
assignee: steve
label:
- follow_up
priority: medium
task_status: active
---
Follow-up from sprint 79 (found while building COM-1147).

**What's wrong:** on a request's timeline, entries about recipients that came from the Disclosures log show the recipient's name and DIS reference — e.g. "The Police (DIS-4) — Told…" and "Correction added: The Police (DIS-4)" — even to someone who can see the request but not that disclosure (a disclosure is restricted when it names a restricted request's person). The close card and the accounting card were fixed in COM-1147; the timeline wasn't.

**What it should do:** such entries read "Restricted disclosure" for anyone not able to see it, as the Recipients card does.

## Notes (technical)

- The timeline events (COM-1138 `recipient_*`, COM-1141 corrections) store only the recipient's name, not the recipient row or disclosure id, so the read path can't tell. Store the disclosure id on new events; for old events, match by request + name or leave as is (staging-only data so far).
- Check through the assistant too (`dsr_get_request` timeline).
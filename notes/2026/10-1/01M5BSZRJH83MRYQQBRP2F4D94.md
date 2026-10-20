---
id: 01M5BSZRJH83MRYQQBRP2F4D94
created: 2026-10-20T04:44:18.385052Z
updated: 2026-10-20T13:50:17.406433Z
type: task
title: A request's timeline never names a recipient from a disclosure the reader can't see
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1148
comments:
- id: 01M5CS7FSYYR6WGC60E1K23V8Q
  author: Steve Vine
  at: 2026-10-20T13:50:17.405891Z
  text: |-
    Merged in PR #1152 (main 424de7e0) at 13:49 UTC on 2026-10-20.

    **What changed:** someone who can see a request but not a disclosure on it now sees the recipient from that disclosure as "Restricted disclosure", the same as on the Tell recipients card. This applies on:
    - the request's **timeline**;
    - the request's **history**;
    - the admin **Activity log**.

    On a timeline entry about that one recipient (added, taken off, put back, told or not told, or a correction to it), the name is replaced and the handler's note and details are dropped. A list of names (recipients listed or refreshed) hides only that name; other recipients stay named. Anyone who can read the disclosure sees everything as before. The assistant's request timeline and history read the same routes, so they follow.

    **My calls:**
    - **No stored id.** The disclosure is identified by the DIS reference already in the recipient's name, instead of a new stored id. Entries written before this change, including ones whose recipient row has gone, are therefore judged exactly like new ones.
    - **History and the Activity log too.** The request's history and the admin Activity log carried the same names, so both got the same fix. Viewing activity doesn't imply reading restricted disclosures.

    **Checks:**
    - Unit tests for the hiding rules.
    - An integration test: a handler who can't read the disclosure sees neither the name, its DIS reference nor the notes on the timeline, history or Activity log. The restrictor still sees them.
    - The DSR request, closure, recipients, activity and assistant-DSR suites all pass locally.
    - ruff and mypy; the OpenAPI drift check (no API change).

    **CI:** run 39428735024 took 34 min, with backend-test at 27.3. The frontend job was skipped (backend only).
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
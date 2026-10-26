---
id: 01M5VNK363X8HPD6TW8KXZVVFG
created: 2026-10-26T08:35:19.87574Z
updated: 2026-10-26T09:28:05.204578Z
type: task
title: Polaris asks before each change — "Polaris wants to save the answer to Q5a" with Allow, Allow for this conversation, or Deny
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1330
sprint: s9ls6e7
blocked_by:
- 01M5VNKA3PAFQ4YN339B8FMJVP
assignee: steve
label:
- feature
priority: high
task_status: active
---
## Behaviour

- **Reading never asks.** Polaris looks things up freely.
- **Any change asks first.** Polaris pauses, and the window shows a card:
  - **"Polaris wants to …"**, in plain words, naming the record. For example: "save this answer to Question 5a on DDQ-4", or "send DDQ-4 via the Trust Centre to Jane Smith".
  - Underneath, the detail of what will change: the answer text, the people, the dates.
  - **Allow** does it.
  - **Allow for this conversation** does it, and doesn't ask again for that *kind* of change in this conversation. For example, it stops asking about saving answers, but still asks about sending.
  - **Deny** doesn't do it. Polaris is told you declined and carries on, or asks you what instead.
- **Anything that emails someone outside, deletes, approves or sends** is marked as such on the card, and is never covered by "Allow for this conversation". It asks every time.
- **A card waiting for an answer holds the turn.** If you close the window or leave the page, the card is still there when you come back. Nothing is done without your click.
- What you chose is kept in the conversation ("You allowed …" / "You declined …").

## My calls (awaiting Steve)

- "Allow for this conversation" covers one kind of change, not every change.
- Outward, destructive and approval actions always ask.

## Notes

- **On the chain:** API (a pending-approval state on a turn, plus an endpoint to answer it), regenerate schema.d.ts.
- What counts as a change: any tool not marked `read_only`. "Always asks" means tools marked `destructive`, plus a short list of outward tools (send, email, approve). Check the existing tool flags; add the flag where a tool is missing it rather than hard-coding names.
- The card text comes from the tool's title plus Polaris's one-line summary, and the argument detail is rendered by Compass. Never trust the model's summary alone for what will change.
- Builds on the engine task.

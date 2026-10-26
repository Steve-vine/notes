---
id: 01M5VNK363X8HPD6TW8KXZVVFG
created: 2026-10-26T08:35:19.87574Z
updated: 2026-10-26T19:47:33.131936Z
type: task
title: Polaris asks before each change — "Polaris wants to save the answer to Q5a" with Allow, Allow for this conversation, or Deny
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1330
sprint: s9ls6e7
blocked_by:
- 01M5VNKA3PAFQ4YN339B8FMJVP
comments:
- id: 01M5W0WPM9MQ1ZXEG8N1DZF2RB
  author: Steve Vine
  at: 2026-10-26T11:52:49.033408Z
  text: |-
    Done — merged to main (PR #1348, migration 0707).

    - **Reading never asks.**
    - **Any change asks first.** Polaris stops, and the window shows "Polaris wants to: <what the tool does>", followed by exactly what it would send, set out as a readable list.
      - The card is written by Compass, not by Polaris.
      - When Polaris reaches a tool through "use a tool", the card names the real tool.
    - **Your choices:**
      - **Allow** makes the change as you, recorded "via Polaris" in the activity log, and Polaris carries on.
      - **Allow for this conversation** stops it asking about that kind of change for the rest of the conversation.
      - **Deny** makes nothing. Polaris is told you declined, and not to try again but to ask what you'd like instead.
    - **Some changes ask every time**, and the card marks them ("Can't be undone" / "Asks every time"):
      - all destructive tools;
      - 19 others, newly marked: those that email or send outside the company (Trust Centre invite, resend link, approve request, extend, email update, post update; attestation assign and restart), and those that record a final decision (approve a DDQ answer or library entry, validate an expedited change, DSR decide, extend deadline, legal hold, publish content, complete a plan entry, complete an incident review, start a recertification now).
    - **A card waits however long you take.** It survives closing the window, a reload and a deploy. While it waits, the conversation takes no new prompt.
    - **Polaris's instructions now tell it** that Compass asks you before any change, so it says what it's about to do and then calls the tool, rather than asking you twice.

    My calls (beyond the task):
    - **"Allow for this conversation" covers one tool**, such as saving answers, never all changes.
    - **The 19 always-ask tools are my choice.** Tell me if any should be allowed for a conversation, or if others should always ask.
    - **If Polaris has been switched off or paused while a card waits**, Allow is refused with the reason; Deny still works.
assignee: steve
label:
- feature
priority: high
task_status: done
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

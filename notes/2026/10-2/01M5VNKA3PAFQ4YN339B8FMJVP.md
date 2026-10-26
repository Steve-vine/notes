---
id: 01M5VNKA3PAFQ4YN339B8FMJVP
created: 2026-10-26T08:35:26.966471Z
updated: 2026-10-26T19:47:33.147938Z
type: task
title: Polaris conversations are kept — a list in the window to go back to one, start a new one, or delete it; private to the person
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1331
sprint: s9ls6e7
blocked_by:
- 01M5VNJTW56N1ZMGF01HX0DD3N
comments:
- id: 01M5W0GR1N7645XB3FVWKSNXWQ
  author: Steve Vine
  at: 2026-10-26T11:46:17.269378Z
  text: |-
    Done — merged to main (PR #1347). The tables came with the engine (migration 0706, COM-1329), because carrying a conversation on needs its history.

    - **Every conversation is kept** and listed latest first, titled from the opening words of its first prompt.
    - **Read back as the window shows it**: what you asked (and where you were), what Polaris answered, the tools it used, Compass's own notes, and each change it asked about with what you decided.
    - **Carry one on** by sending a prompt in it.
    - **Delete removes it for good.** What Polaris changed stays changed and stays in the activity log, and its spend stays in the tracker.
    - **Private:** only the person can list, read, carry on or delete their conversations. Administrators see spend only.
    - **A conversation whose turn was cut off part-way** (a restart) shows as interrupted, and is free to carry on.
    - The window (COM-1333) has New conversation, the list with Delete, and reopens the conversation you were last in.

    My calls (beyond the task):
    - **No trimming of long conversations.** Current Claude models refuse a history that has been edited, so a single tool result is capped instead (COM-1329).
    - **Delete is refused while Polaris is answering**: stop it first.
    - **A conversation is deleted along with its owner's account.**
assignee: steve
label:
- feature
priority: medium
task_status: done
---
## Behaviour

- **Every conversation is kept**, with the prompts, the replies, what Polaris did and what you allowed or declined.
- **In the window:**
  - **New conversation** starts afresh.
  - **Conversations** lists your past ones, newest first, each titled from its first prompt and dated.
  - Open one to carry on where you left off.
- **Delete** removes a conversation for good, after a confirmation.
  - The changes Polaris made stay, and stay in the activity log.
  - Its spend stays in the tracker.
- **Private.** Only the person can see their own conversations. Administrators can't read them; they see spend only.
- Reopening the window takes you back to the conversation you were last in.

## My calls (awaiting Steve)

- Kept until the person deletes them, with no automatic clearing.
- Not readable by administrators. The activity log already shows what Polaris changed, and as whom.
- Titled from the first prompt's opening words, not by asking the model, which would cost money.

## Notes

- **On the chain:**
  - migration: `polaris_conversations`, `polaris_messages` (role, content blocks as JSON, tool calls/results, approvals);
  - API: list, get, delete, regenerate schema.d.ts.
- A deleted conversation's `polaris_usage` rows keep their cost. The conversation link goes to SET NULL.
- When a user is deleted, their conversations go with them.
- The engine resends the stored history on each turn. Trim the oldest tool results past a size budget so that long conversations don't grow without limit.

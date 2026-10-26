---
id: 01M5VNKA3PAFQ4YN339B8FMJVP
created: 2026-10-26T08:35:26.966471Z
updated: 2026-10-26T08:36:37.781926Z
type: task
title: Polaris conversations are kept — a list in the window to go back to one, start a new one, or delete it; private to the person
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1331
sprint: s9ls6e7
blocked_by:
- 01M5VNJTW56N1ZMGF01HX0DD3N
assignee: steve
label:
- feature
priority: medium
task_status: todo
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

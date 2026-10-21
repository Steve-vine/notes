---
id: 01M5DAG3597BP6YDK3S4BFFECE
created: 2026-10-20T18:52:05.161342Z
updated: 2026-10-21T20:16:50.736711Z
type: task
title: Tell recipients only appears on a request that asks for a correction, erasure or restriction
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1179
sprint: ss8348q
blocked_by:
- 01M5DAFG3YR20T97VTBQQ571J8
comments:
- id: 01M5F3KYFETK9EG17VHWCPMZ4A
  author: Steve Vine
  at: 2026-10-21T11:30:20.270353Z
  text: |-
    Done — PR #1199, merged 21 Oct 12:29 BST.

    - An access, portability or objection request no longer shows a Tell recipients step, and the steps after it renumber with no gap.
    - A request that asks for a correction, erasure or restriction keeps the step. Until one of them is granted or partly granted it says "Starts once…", and then it shows the list, as before.
    - If every correction, erasure or restriction is refused or withdrawn, or the request closes without one granted, the step stays and says "Not needed — nothing was corrected, erased or restricted".
    - Whether the step shows depends on what the request asks for, so if someone edits the request's types, the step follows.
    - The close checklist has no "Every recipient told or not told" line on a request that didn't ask for any of these. On one that did, the line says "Nothing granted yet needs it" before the decision, and the same "Not needed…" wording after a refusal.
    - The assistant says the same as the screen.

    My calls:
    - "Nothing was corrected" counts a part refused, withdrawn or "not ours", or a request closed with one still undecided.
    - If a part was granted and recipients were listed, and the decision is later changed to refused, the step shows "Not needed" rather than the old list.
assignee: steve
label:
- improvement
priority: low
task_status: done
---
Steve's feedback while smoke-testing sprint 79.

**What's wrong:** every request shows a Tell recipients step. On an access request it only says "Starts once a correction, erasure or restriction is granted or partly granted", and there's nothing to do. That suggests a step was missed when none applies.

**What it should do:**
- A request that **asks for** a correction, erasure or restriction shows Tell recipients, as now. Until one of those parts is granted or partly granted it shows the "Starts once…" line. After that it shows the list.
- A request that asks for none of them (access, portability or objection only) doesn't show Tell recipients at all. With COM-1177's numbered steps, the following steps renumber with no gap.
- If a correction, erasure or restriction part is later refused, or the request is closed without one granted, the step stays, showing "Not needed — nothing was corrected, erased or restricted". It doesn't disappear from a request that asked.

**Done when:** an access-only request has no Tell recipients step, and an erasure request still has it.
---
id: 01M5DAG3597BP6YDK3S4BFFECE
created: 2026-10-20T18:52:05.161342Z
updated: 2026-10-20T18:52:13.522095Z
type: task
title: Tell recipients only appears on a request that asks for a correction, erasure or restriction
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1179
sprint: ss8348q
blocked_by:
- 01M5DAFG3YR20T97VTBQQ571J8
assignee: steve
label:
- improvement
priority: low
task_status: todo
---
Steve's feedback while smoke-testing sprint 79.

**What's wrong:** every request shows a Tell recipients step. On an access request it only says "Starts once a correction, erasure or restriction is granted or partly granted", and there's nothing to do. That suggests a step was missed when none applies.

**What it should do:**
- A request that **asks for** a correction, erasure or restriction shows Tell recipients, as now. Until one of those parts is granted or partly granted it shows the "Starts once…" line. After that it shows the list.
- A request that asks for none of them (access, portability or objection only) doesn't show Tell recipients at all. With COM-1177's numbered steps, the following steps renumber with no gap.
- If a correction, erasure or restriction part is later refused, or the request is closed without one granted, the step stays, showing "Not needed — nothing was corrected, erased or restricted". It doesn't disappear from a request that asked.

**Done when:** an access-only request has no Tell recipients step, and an erasure request still has it.
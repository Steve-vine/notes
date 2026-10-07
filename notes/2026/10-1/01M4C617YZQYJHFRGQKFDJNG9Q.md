---
id: 01M4C617YZQYJHFRGQKFDJNG9Q
created: 2026-10-07T21:59:07.999521Z
updated: 2026-10-07T21:59:07.999521Z
type: task
title: A change whose run died partway is shown as failed with Retry — not left on "Executing" for ever
task_status: todo
label: bug
priority: high
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 859
---
Found investigating ACR-56 (staging, 2026-10-07).

## What happened

The leaver's run was still going when a deploy replaced the worker at 17:06. Nothing ever went back to it: the request sat on *Executing* for hours, with no Retry and nothing saying what had happened. The same happens whenever a worker stops mid-run, whether a deploy, an out-of-memory kill or a node restart. Steve had to ask; the request was set to Failed by hand.

## What should happen

If a change has been *Executing* for longer than any run can take, and no worker is still running it, Compass marks it **Failed**. It says *"The run stopped partway — Retry carries on from where it left off"* and offers **Retry**. A retry only does what's left (applied people are skipped; each step diffs against live state).

## Notes (technical)

- The 5-minute `sweep_due_access_work` finds `access_requests.status = executing` with `updated_at` older than a threshold. The run commits after each subject, so `updated_at` is a heartbeat; 15 minutes is far beyond any real subject.
- Optionally also check the status registry (`compass:status:running`) to confirm no live task has it; age alone is the essential part.
- Pending subjects → failed, with the sentence above; request → failed. Recert removals have the same shape (`removal_approved` → executing?). Check and cover them if so.
- Test: a request left executing past the threshold is failed by the sweep; a recent one is left alone.

**Done when:** a request stranded on Executing is failed with Retry by the sweep, in CI, merged to main.
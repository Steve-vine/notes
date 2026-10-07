---
id: 01M4C617YZQYJHFRGQKFDJNG9Q
created: 2026-10-07T21:59:07.999521Z
updated: 2026-10-07T22:27:56.49096Z
type: task
title: A change whose run died partway is shown as failed with Retry — not left on "Executing" for ever
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 859
sprint: sme8esk
comments:
- id: 01M4C7NYZYGHSFR7B98C1H6CRP
  author: Steve Vine
  at: 2026-10-07T22:27:55.518462Z
  text: |-
    Done: PR #864, merged to main (795fb53). Not deployed to staging yet.

    **What changed:** if a change has been *Executing* with nothing happening for **30 minutes**, Compass now treats its run as dead. It marks the change **Failed**, with *"The run stopped partway — Retry carries on from where it left off"* against each person not yet done, and the **Retry** button appears. The check runs every 5 minutes.

    **Why 30 minutes is safe:** a run saves after every person, so any run that's genuinely going writes something long before that. Every call to AD, Entra, Exchange and now Kerberos has its own much shorter limit, so no real run sits silent that long.

    **Retry is safe:** people already done are skipped, and the rest only gets what's still missing. That's how ACR-56's retry will behave.

    **Proven by a test:** a change stranded 45 minutes is failed and then carried through to *Executed* by Retry. One that last wrote 5 minutes ago is left alone.

    **Smoke test (after deploy):** nothing to set up. ACR-56 is already Failed, by hand. Pressing Retry on it should complete Abigail's leaver: her groups go, and her account is deleted, since the leaver asked for deletion after 0 days.
assignee: steve
label:
- bug
priority: high
task_status: review
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
---
id: 01M14W6DSK4K8A91HBM1V6BRHW
created: 2026-08-28T19:05:25.555086Z
updated: 2026-08-28T19:06:45.133066Z
type: task
title: 'Scheduled reports: a cadence, recipients, and mail that arrives'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 495
sprint: s42ntc9
blocked_by:
- 01M14W60YF3HHYYS7A8BZZKKFP
assignee: steve
company: null
label:
- feature
priority: medium
task_status: todo
---
ADR 0062 §5. A report can carry a schedule: daily, weekly or monthly at a stated time, a list of recipients, and a format.

Delivery is mail like all other mail (ADR 0055) — the report declares what it produced and the existing transport sends it. Do not write a bespoke sender.

A scheduled run is a run (COM-494): it lands in the history with its snapshot, so *the report was sent, and this is what it said* is one record, not two.

Points to get right:

- **Beat crontabs are wall-clock.** A schedule stated as 07:00 must mean 07:00 to the reader, across a BST/GMT change.
- **Idempotent, by the cadence step.** A worker restart inside the hour must not send twice; the run ledger is what decides whether a step has already happened.
- **An empty result still sends, and says it is empty.** *Nothing to report* is the answer a governance reader most needs to receive on time; silence is indistinguishable from a broken job.
- **A failed run is visible in the library**, not only in the logs. A schedule that quietly stopped is the failure mode that makes people go back to running things by hand.

Recipients are named users; the run executes with the scoping of the report's company, never with the recipient's rights.
---
id: 01M8HMVPCAYJ0MMJD8XD1Y0GBF
created: 2026-11-28T17:57:14.25053Z
updated: 2026-11-28T17:57:20.608426Z
type: task
title: 'A PowerShell or Python script can reach the network in its first second or two, before the seal takes hold: the runner waits until it''s sealed, and won''t run the script if it isn''t'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2239
sprint: s09wwd3
assignee: steve
label:
- bug
priority: high
task_status: active
---
**Defect from the sprint 132 pre-UAT pass (COM-2230).** Independent: **no migration, no API change.**

## What was seen
On staging, a Python probe script tried to reach Compass, the cluster and the internet the moment it started. It **reached all three**: the cluster's API address on 443, 1.1.1.1 on 443, and the cluster's DNS server by IP. The same probe run after a **10-second wait was refused everywhere**. Name lookups failed both times, as designed.

So the deny-all network rule is right, but the cluster applies it to a new script pod a moment after the pod starts. A script that acts at once runs unsealed. It holds no credential, so it can't sign in to anything. But it could send its inputs somewhere, or probe the network.

## What changes
- Before running the script, the runner checks that it can't reach anything, and waits (briefly) until it can't.
- If it still isn't sealed after a short limit, the run **fails without running the script**: "The script runner couldn't confirm it was sealed off, so the script didn't run." That's an Alert in the Event log, and the run can be retried.
- Nothing else changes: same pod, same rules.

**Done when:** on staging, the probe script run straight away is refused everywhere (Compass, the cluster, the internet), as it is after a wait; a normal script still runs in a few seconds.

Screenshots and the probe's output: `~/compass-uat/132/COM-2230/`.
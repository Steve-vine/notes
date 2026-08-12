---
id: 01KZVFG5SRZX9H4DVE941C2DQH
created: 2026-08-12T17:14:41.848808Z
updated: 2026-08-12T17:15:29.287301Z
type: task
title: Get RedVektor running end-to-end on EC2
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 323
sprint: ssxh43d
assignee: steve
imported_from: linear
priority: medium
task_status: done
---
Working issue for fixing the gaps surfaced while standing up the EC2 cutover (Briefs 064/065/066). Each fix lands as its own small PR; no further briefs. Iterating with chat-Claude as issues are discovered.

**Known fixes needed**

1. `scripts/bootstrap/setup.sh` **doesn't enable/start** `buildkit.service`**.** Brief 064's install of `nerdctl-full` drops the unit file at `/usr/local/lib/systemd/system/buildkit.service` but never `systemctl enabl…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-289](https://linear.app/stevevine/issue/DEV-289/get-redvektor-running-end-to-end-on-ec2)
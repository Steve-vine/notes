---
id: 01KZVEPQGN88WW10P7KDFGEAFY
created: 2026-08-12T17:00:48.021312Z
updated: 2026-08-12T17:02:02.089041Z
type: task
title: Service-detection progress is all-or-nothing — single nmap group means 0/N for the entire scan
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 261
sprint: sewyev2
assignee: steve
imported_from: linear
label:
- follow_up
- bug
priority: null
task_status: done
---
## Observation (M8 service-detection testing)

A service-detection step against 413 inputs sat at **0/413 for 11+ minutes** with no feedback — indistinguishable from a hang. Pod inspection showed it was healthy and mid-scan (CPU ~35m, nmap active). Run was cancelled by Steve rather than waiting out the `wall_clock_seconds: 1200` budget.

From the pod logs:

* Pre-resolve completed in 0.2s (51 NXDOMAIN dropped, 362 hosts forward).
* The runner la…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-383](https://linear.app/stevevine/issue/DEV-383/service-detection-progress-is-all-or-nothing-single-nmap-group-means)
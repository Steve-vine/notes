---
id: 01KZVE1RV5ZDR5N65XVAM770D5
created: 2026-08-12T16:49:21.253078Z
updated: 2026-08-12T16:50:16.821049Z
type: task
title: Dispatcher progress poll misses sparse progress (7s window) → vuln scan stuck at 0/N
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 210
sprint: sp88phy
assignee: steve
imported_from: linear
label:
- bug
priority: high
task_status: done
---
Found debugging a live app scan: the vulnerability-scanner step showed **0 of 379** for 28+ min while nuclei was actively scanning at ~27% (`done=102/379` on the pod's stdout).

### Root cause

`_poll_step_once` reads only the **last** `poll_interval + 2` **= 7 seconds** of pod logs each tick (`tasks/workflow_runs.py` → `_read_progress_slice(since_seconds=...)`, `k8s_scan_poll_interval_seconds=5`). On a slow scan the vuln scanner emits a progress line only when the percentage ticks up — here ~once every **\~90 s** (percent crawls on a slow/Cloudflare estate). Compounded by a few seconds of log-flush lag, a freshly-emitted line is almost never inside the 7 s window, so the poll keeps finding nothing and `progress_current` stays 0.

Proven against the live pod:

```
read window 7s  → 0 progress lines
read window 30s → 0 progress lines
read window 60s → 0 progress lines
read window 180s→ 2 progress lines  (parsed done=102)
```

The progress line parses fine (`_parse_slice_progress` returns `done=102`), and polls fire every ~5 s — it's purely the read-window size.

### Why now

Latent limitation. Pre-DEV-569 the vuln scanner emitted progress per *finding*, so a clean scan showed 0/N regardless. DEV-569 made it emit *real* progress, exposing that the poll window is too small for a **sparse** emitter. Dense-progress engines (subfinder, etc.) get caught by luck; the vuln scanner on a slow scan does not.

### Fix

Decouple the progress-read window from the 5 s poll interval. Read a window that reliably covers the gap since the last poll **plus** log-flush lag — e.g. `since_seconds` = (now − previous poll `last_seen_at`) + a lag buffer, or a generous fixed floor (~120 s). `_parse_slice_progress` already takes "highest-wins", so a larger overlapping read is safe + monotonic. Contained change in `_poll_step_once`.

### Acceptance

A slow scan with sparse progress emission (e.g. the 379-input vuln scan) shows a monotonically advancing `progress_current` in the run report, matching nuclei's real percentage — not stuck at 0/N.

---

Imported from Linear [DEV-580](https://linear.app/stevevine/issue/DEV-580/dispatcher-progress-poll-misses-sparse-progress-7s-window-vuln-scan)
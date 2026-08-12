---
id: 01KZVE2RDY0Z8PZ79SE3ERZAGE
created: 2026-08-12T16:49:53.598269Z
updated: 2026-08-12T16:50:23.90819Z
type: task
title: Vulnerability scanner shows no real scan progress (counter is findings, not inputs)
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 213
sprint: sp88phy
assignee: steve
imported_from: linear
label:
- tech_debt
priority: medium
task_status: done
---
A long vuln scan is indistinguishable from a hang — run `a1c0de12` sat at **"0 of 379"** for 75+ minutes and looked stuck, but nuclei was actively scanning (sustained ~450m CPU) and had simply found nothing yet.

### Root cause

The runner advances the scan-progress counter **per nuclei finding**, not per input scanned: `processed_lines += 1; ctx.emit_progress(phase="scan", done=processed_lines, total=total_inputs)` (`app/scanners/vulnerability-scanner/src/redvektor_vulnerability_scanner/runner.py:895-896`), where `total=input_count`. So `done` only moves when nuclei emits a finding, while `total` is the input count — a clean scan (0 findings) shows `0/N` forever, identical to a hang.

Compounding it: the runner does **not** pass nuclei `-stats`, so there's no host/request-completion signal to derive real progress from. There is currently *no* way to see how far through its inputs nuclei is.

### Fix

* Pass nuclei `-stats -stats-json -stats-interval <n>` and parse the periodic stats (hosts/requests completed, total) from stderr.
* Emit `progress(phase="scan", done=<hosts_or_requests_completed>, total=<total>)` from those stats, so the bar reflects **scan progress**, not findings.
* Keep findings as their own count/metric (don't conflate the two).
* nuclei stats lines currently fall through to `nuclei_bad_line` WARN — handle them explicitly.

### Acceptance

A running vuln scan shows monotonic scan progress (X of N inputs/requests) that advances even when 0 findings are produced, so a slow-but-healthy scan is clearly distinguishable from a stall.

### Context

* Found while diagnosing a slow scan on a Cloudflare-fronted estate (379 URLs, `critical/high/medium` — config was fine; the targets are just slow/WAF-challenged). The dispatcher itself was healthy (DEV-564): `last_seen` fresh, poll alive, would finalise at the 4h wall-clock.

---

Imported from Linear [DEV-569](https://linear.app/stevevine/issue/DEV-569/vulnerability-scanner-shows-no-real-scan-progress-counter-is-findings)
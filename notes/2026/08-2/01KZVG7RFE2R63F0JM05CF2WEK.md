---
id: 01KZVG7RFE2R63F0JM05CF2WEK
created: 2026-08-12T17:27:34.638021Z
updated: 2026-08-12T17:27:34.638021Z
type: task
title: Chained scan step 2 fails at ARG_MAX with realistic input volumes — switch to file-mounted inputs
imported_from: linear
label:
- follow_up
- bug
priority: high
task_status: done
assignee: steve
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 391
---
Brief 011's chained dispatcher passes step N+1's inputs via the `RV_INPUTS` environment variable (a JSON `[{kind, value}]` list). At realistic scale this hits `ARG_MAX` — the Linux kernel's hard cap (typically 128–256KB) on the combined size of args + environment passed to `execve()`.

**Verified failure mode:** chained `subfinder-then-httpx` scan against `example.com`:

* Step 1 (subfinder) found 22,249 subdomains ✅
* Step 2 (httpx) Pod failed …

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-160](https://linear.app/stevevine/issue/DEV-160/chained-scan-step-2-fails-at-arg-max-with-realistic-input-volumes) · parent DEV-159
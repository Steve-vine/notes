---
id: 01KZVGA5T6S32KW3G7EPKK00EB
created: 2026-08-12T17:28:53.830644Z
updated: 2026-08-12T17:28:53.830644Z
type: task
title: Close the `subprocess.run` vs streaming gap in BaseRunner
label:
- follow_up
- tech_debt
imported_from: linear
assignee: steve
priority: medium
task_status: done
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 397
---
Brief 009 implemented httpx with `subprocess.run(capture_output=True)` to match subfinder's structure (correct call at the time). Two scanners now share the pattern. Future scanners — nuclei especially — will produce too much output for buffered run. When `BaseRunner` is extracted (likely in Brief 010 or a dedicated refactor), it should expose both `run_buffered()` and `run_streaming()` so scanners can pick. Subfinder + httpx stay buffered; nucl…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-55](https://linear.app/stevevine/issue/DEV-55/close-the-subprocessrun-vs-streaming-gap-in-baserunner) · parent DEV-15
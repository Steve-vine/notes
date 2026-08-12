---
id: 01KZVF4S1JMZ774DCE2XS6FASP
created: 2026-08-12T17:08:28.338765Z
updated: 2026-08-12T17:08:28.338765Z
type: task
title: M6.5 P7 — Retire the legacy scan-job API (/scans, /scan-engines, SCANNER_REGISTRY, ScanEngineLoader)
priority: medium
task_status: done
assignee: steve
imported_from: linear
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 294
---
**Retire the legacy scan-job API surface.** Pre-workflow scanning ran through `POST /scans` and `/scan-engines` (YAML presets), backed by `SCANNER_REGISTRY` (`tasks/scans.py`) and `ScanEngineLoader`/`configure_scan_engines` (`core/scan_engines.py`) reading `scan_engines_dir`. The modern path is workflows (`/workflows` → dispatcher → CR-sourced engines). The legacy route is now **vestigial** — `chart/scan-engines/` is empty, so `ScanEngineLoader`…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-326](https://linear.app/stevevine/issue/DEV-326/m65-p7-retire-the-legacy-scan-job-api-scans-scan-engines-scanner)
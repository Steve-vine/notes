---
id: 01KY7377K3BEGNVZSCB233MVVA
created: 2026-07-23T08:59:35.395168Z
updated: 2026-07-23T11:04:51.947673Z
type: task
title: Concurrent-writers chaos harness for sync (ADR 0045 stage 4)
imported_from: linear
task_status: done
assignee: steve
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 362
---
Stage 4 of ADR 0045 — merge behaviour verified as a **system**, not per incident.

A test harness spinning up two `VaultRuntime`s cloned from one bare git remote, driving scripted interleavings of real operations (save, patch, comment, sprint assignment, status flip, import, open-and-close) on both sides with sync cycles interleaved, then asserting the invariants:

* **No data loss**: every operation's effect is present in the converged vault (or in a conflict copy, for the one legitimate keep-both case).
* **No false copies**: conflict copies appear only for same-body-region divergence.
* **Convergence**: both clones reach identical vault content after quiescent sync.
* **No churn**: a quiescent vault produces zero further commits (the DEV-995/DEV-1012 guarantee, system-level).

Runs in CI as ordinary `cargo test` (the gitsync tests already build real repos; this composes the same pieces). Scenario list seeded from the incident ledger — ISE-73 comment adds, counter races, reorder echoes, timestamp-only sides, the DEV-1014 matrix — plus a small randomised-interleaving mode with a fixed seed.

Pairs with DEV-1014 (built alongside; its acceptance gate).

---

Linear DEV-1015 · created 2026-07-19 · done 2026-07-19
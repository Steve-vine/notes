---
id: 01KZVETPG741SK6B4BZCQ2SSMY
created: 2026-08-12T17:02:58.055536Z
updated: 2026-08-12T17:05:27.620314Z
type: task
title: 'Rename engine: nuclei → vulnerability-scanner (Vulnerability Scanner)'
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 273
sprint: s0ht2jk
assignee: steve
imported_from: linear
label:
- chore
priority: medium
task_status: done
---
Atomic engine rename per **Brief 110** + **ADR 036**.

**Mapping:** tool `nuclei` → slug `vulnerability-scanner`, displayName "Vulnerability Scanner".

One PR: package dir + python module + `pyproject` + `@engine` name + handshake + CR `metadata.name`/`engineRef` + seed filename + image repo + CI/smoke/docs + tests move to the slug; implementation refs keep the tool name. Note nuclei emits findings — confirm `scanner_id`/fingerprint follows the …

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-368](https://linear.app/stevevine/issue/DEV-368/rename-engine-nuclei-vulnerability-scanner-vulnerability-scanner)
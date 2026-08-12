---
id: 01KZVETCDNF9SD30GKVPFV4TER
created: 2026-08-12T17:02:47.733067Z
updated: 2026-08-12T17:02:47.733067Z
type: task
title: 'Rename engine: nmap → service-detection (Service Detection)'
imported_from: linear
assignee: steve
label: chore
priority: medium
task_status: done
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 270
---
Atomic engine rename per **Brief 110** + **ADR 036**.

**Mapping:** tool `nmap` → slug `service-detection`, displayName "Service Detection".

One PR: package dir + python module + `pyproject` + `@engine` name + handshake + CR `metadata.name`/`engineRef` + seed filename + image repo + CI/smoke/docs + tests move to the slug; implementation refs (`NMAP_BIN`, defusedxml, description) keep the tool name. Accepts the `port` kind, produces `service` — …

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-371](https://linear.app/stevevine/issue/DEV-371/rename-engine-nmap-service-detection-service-detection)
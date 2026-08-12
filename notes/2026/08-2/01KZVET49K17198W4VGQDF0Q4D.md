---
id: 01KZVET49K17198W4VGQDF0Q4D
created: 2026-08-12T17:02:39.41164Z
updated: 2026-08-12T17:02:39.41164Z
type: task
title: 'Rename engine: tlsx → tls-certificate-analysis (TLS & Certificate Analysis)'
task_status: done
label: chore
assignee: steve
priority: medium
imported_from: linear
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 269
---
Atomic engine rename per **Brief 110** + **ADR 036**.

**Mapping:** tool `tlsx` → slug `tls-certificate-analysis`, displayName "TLS & Certificate Analysis" (the `&` drops out of the slug).

One PR: package dir + python module + `pyproject` + `@engine` name + handshake + CR `metadata.name`/`engineRef` + seed filename + image repo + CI/smoke/docs + tests move to the slug; implementation refs (`TLSX_BIN`, description) keep the tool name. Produces `…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-372](https://linear.app/stevevine/issue/DEV-372/rename-engine-tlsx-tls-certificate-analysis-tls-and-certificate)
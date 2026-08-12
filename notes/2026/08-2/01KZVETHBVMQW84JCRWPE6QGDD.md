---
id: 01KZVETHBVMQW84JCRWPE6QGDD
created: 2026-08-12T17:02:52.795655Z
updated: 2026-08-12T17:02:52.795655Z
type: task
title: 'Rename engine: naabu → port-scanner (Port Scanner)'
assignee: steve
imported_from: linear
label: chore
priority: medium
task_status: done
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 271
---
Atomic engine rename per **Brief 110** + **ADR 036**.

**Mapping:** tool `naabu` → slug `port-scanner`, displayName "Port Scanner".

One PR: package dir + python module + `pyproject` + `@engine` name + handshake + CR `metadata.name`/`engineRef` + seed filename + image repo + CI/smoke/docs + tests move to the slug; implementation refs (`NAABU_BIN`, gopacket/glibc build notes, description) keep the tool name. Note `port-scanner` produces the `port…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-370](https://linear.app/stevevine/issue/DEV-370/rename-engine-naabu-port-scanner-port-scanner)
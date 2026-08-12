---
id: 01KZVF00Z04PAY8C2T74TF9AAH
created: 2026-08-12T17:05:52.608915Z
updated: 2026-08-12T17:05:52.608915Z
type: task
title: 'Rename engine: subfinder → subdomain-discovery (Subdomain Discovery)'
priority: medium
label: chore
imported_from: linear
task_status: done
assignee: steve
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 275
---
Atomic engine rename per **Brief 110** + **ADR 036**.

**Mapping:** tool `subfinder` → slug `subdomain-discovery`, displayName "Subdomain Discovery".

One PR: package dir + python module + `pyproject` + `@engine` name + handshake + CR `metadata.name`/`engineRef` + seed filename + image repo (`redvektor/subdomain-discovery`) + CI/smoke/docs + tests all move to the slug. Binary env/path, install line, and description keep the tool name (implementa…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-365](https://linear.app/stevevine/issue/DEV-365/rename-engine-subfinder-subdomain-discovery-subdomain-discovery)
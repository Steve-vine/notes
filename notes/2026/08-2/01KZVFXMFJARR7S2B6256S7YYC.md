---
id: 01KZVFXMFJARR7S2B6256S7YYC
created: 2026-08-12T17:22:02.866288Z
updated: 2026-08-12T17:22:57.282765Z
type: task
title: 'Subfinder runner: -dL - doesn''t read stdin in subfinder v2.6.6'
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 358
sprint: sv5cbvq
assignee: steve
imported_from: linear
label:
- bug
priority: medium
task_status: done
---
## Problem

Subfinder runner fails immediately when a step is configured with more than one domain. Surfaced during the Brief 036 (DEV-237) smoke on 2026-05-16; only single-domain runs work today.

## Diagnostic evidence

Workflow run `164e325d-003f-4e33-8fd6-76895e6a6a7c`, ste…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-242](https://linear.app/stevevine/issue/DEV-242/subfinder-runner-dl-doesnt-read-stdin-in-subfinder-v266)
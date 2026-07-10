---
id: 01KX6DMKFCYDB4VHZMFMPKRRZ3
created: 2026-07-10T16:26:43.052600935Z
updated: 2026-07-10T16:27:32.509988193Z
type: task
title: CI pipelines — PR gate, staging, main, image builds, secret scanning
task_status: todo
assignee: steve
priority: high
project: 01KX671DATY39VW6GWK3M2T3DN
number: 7
sprint: sh9ng2k
---
GitHub Actions per ADR 0011: PR→main full test suite (unit, lint, types, migration check); push→staging combined tests + staging deploy; push→main belt-and-braces + production build. Immutable `<branch>-yyyymmdd-hhmm` image tags (ADR 0008) and secret scanning.
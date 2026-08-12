---
id: 01KZVBT2C46S6737XV13SNZ1VC
created: 2026-08-12T16:10:11.716522Z
updated: 2026-08-12T16:10:11.716522Z
type: task
title: Subfinder behaviour doesn't allow chaining
imported_from: linear
assignee: steve
label: improvement
task_status: done
priority: medium
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 146
---
Because the subfinder selector doesn't store the domain to be checked, instead it's entered at run time, it's not possible to chain 2 subfinders.

Change Subfinder bahaviour so that the domain it scans is stored as part of the workflow edit process, i.e. the domain is stored along with the other step options, same as the cloudflare selector, not provided at run-time.

---

Imported from Linear [DEV-234](https://linear.app/stevevine/issue/DEV-234/subfinder-behaviour-doesnt-allow-chaining)
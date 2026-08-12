---
id: 01KZVE956DG2QGRNEQRQKZQ9ZW
created: 2026-08-12T16:53:23.277521Z
updated: 2026-08-12T16:53:23.277521Z
type: task
title: HTTP_POST engine as step 0 loses its findings (no RV_OUTPUT_URL on trigger-time env)
label: follow_up
task_status: done
imported_from: linear
priority: medium
assignee: steve
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 220
---
Found while verifying DEV-524.

A vulnerability-scanner (or any `result_transport=HTTP_POST` engine) run as **step 0** of a workflow has its findings **silently dropped**.

### Root cause

The HTTP_POST output contract (`RV_RESULT_TRANSPORT`, `RV_OUTPUT_URL`, `RV_EVIDENCE_URL` + the output token) is injected by the *…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-558](https://linear.app/stevevine/issue/DEV-558/http-post-engine-as-step-0-loses-its-findings-no-rv-output-url-on)
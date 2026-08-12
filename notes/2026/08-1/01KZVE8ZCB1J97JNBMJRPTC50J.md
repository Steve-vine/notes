---
id: 01KZVE8ZCB1J97JNBMJRPTC50J
created: 2026-08-12T16:53:17.323951Z
updated: 2026-08-12T16:53:17.323951Z
type: task
title: TLS & Certificate Analysis crashes on a malformed/non-web URL input (e.g. tel:)
label: bug
imported_from: linear
assignee: steve
priority: high
task_status: done
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 219
---
Found while diagnosing a failed `vul-scan` run (run `cf64dea7`).

The TLS engine (`tls-certificate-analysis`) **crashes the entire step** when one `url` input has a port that isn't 0–65535:

```
{"type":"error","code":"ENGINE_UNHANDLED_EXCEPTION","message":"ValueError: Port out of range 0-65535","fatal":true}
```

### Root cause

`_endpoints_for_ref` ([runner.py:241](<http://runner.py:241>)–247) parses a `url` input with `urlsplit(...)` then rea…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-563](https://linear.app/stevevine/issue/DEV-563/tls-and-certificate-analysis-crashes-on-a-malformednon-web-url-input)
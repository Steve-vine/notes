---
id: 01KZVFFTWM0R80F9Z29J0E9CE6
created: 2026-08-12T17:14:30.676792Z
updated: 2026-08-12T17:14:30.676792Z
type: task
title: 'Backend email validator inconsistency: `redvektor-admin create-user` accepts reserved TLDs that `/auth/login` rejects'
assignee: steve
imported_from: linear
priority: medium
task_status: done
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 320
---
## Surfaced by DEV-285 (Brief 067 first smoke run)

The two validation paths for the same email field disagree:

* `redvektor-admin create-user --email smoke@redvektor.local` → **succeeds**. Writes the user to the DB.
* `POST /api/v1/auth/login` with the same email → **rejects with 422**:

…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-294](https://linear.app/stevevine/issue/DEV-294/backend-email-validator-inconsistency-redvektor-admin-create-user)
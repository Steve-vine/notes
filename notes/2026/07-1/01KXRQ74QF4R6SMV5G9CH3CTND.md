---
id: 01KXRQ74QF4R6SMV5G9CH3CTND
created: 2026-07-17T19:00:27.503247469Z
updated: 2026-07-21T17:37:26.547777Z
type: task
title: 'Flaky test: test_audit_details_never_contain_secret_values (shared-DB ordering)'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 106
sprint: s0v93ii
assignee: steve
label: null
priority: low
task_status: done
---
`tests/integration/test_credentials.py::test_audit_details_never_contain_secret_values` is **order-dependent / flaky**. It stores a credential then queries `select(AuditEvent).where(entity_type=='credential', action=='created')` with **no `order_by`** and takes `.all()[-1]`. On the module's shared Postgres, other tests also create `credential`/`created` audit events, so `[-1]` returns an arbitrary row — and the assertion `event.details["fields"] == ["api_key", "app_key"]` fails when it picks a different credential's event. Passes in isolation; fails intermittently in the full suite depending on execution order (seen 2026-07-17: 1 failed / 487 passed on one run, clean on re-run).

**Fix:** scope the query to the credential this test just created — filter by its `entity_id` (or `name`), or `order_by(AuditEvent.at.desc()).limit(1)` keyed to this credential — rather than "the last credential-created event anywhere". Not caused by any ISE-10x change; a latent test-isolation bug surfaced during Sprint 8. Label: bug / test.
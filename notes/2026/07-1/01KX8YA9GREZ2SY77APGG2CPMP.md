---
id: 01KX8YA9GREZ2SY77APGG2CPMP
created: 2026-07-11T15:56:39.832077314Z
updated: 2026-07-23T13:54:50.960513Z
type: task
title: DataDog connector — service-map slice + event-based detect
project: 01KX671DATY39VW6GWK3M2T3DN
number: 31
sprint: sdm5e08
comments:
- id: 01KXAKYRRDAA0W42TXSABK3NWQ
  author: Steve Vine
  at: 2026-07-12T07:34:05.325450003Z
  text: 'Development complete on feature/ise-031-datadog-servicemap. PR #32: https://github.com/Steve-vine/ise/pull/32. Completes the DataDog connector to the connectors-brief scope (ISE-24 deferred these). Added: read-state service_map slice (v2 ServiceDefinitionApi, defensive name extraction over the versioned schema union) and event-based detect (v1 EventsApi, recent ERROR events only, rolling 1h window so findings stay small + self-clearing). build_client/DatadogApis gain events+services; credential read_only_scopes add events_read + apm_service_catalog_read. No API-schema change (connector-spec data changes, not the Pydantic models → openapi.json unchanged). Signal-to-noise: error-only by design — a live check showed the org emits ~56 warning events/hour (routine k8s ops) vs 0 errors; promoting warnings would flood the queue with ephemeral noise. Tests: mypy/ruff clean, 9 connector contract tests (service_map slice, error-only events, combined monitors+events), full suite 133 passed. VALIDATED LIVE against the real DataDog EU org: health connected; service_map returns cleanly (org has empty service catalogue → count 0); detect = 13 monitor alerts + 0 error events (event path proven — returned 56 findings when warnings were temporarily included). PR CI green (frontend correctly skipped — backend-only). Merged to staging (706341f); deploy-staging fully GREEN incl. smoke check (ISE-34 fix holding). Confirmed live on staging: datadog system now syncs 4 slices (service_map added), 13 findings, no promotion churn. Housekeeping: cleared a stray/erroneous blocked_by link to an unrelated personal note. Awaiting merge clearance. Note: minimal new UI surface — datadog System detail gains a ''service_map'' state slice (count 0 in this org); error events would appear as high findings/issues when they occur.'
- id: 01KXAMBPHDF1325WKPMC80KQ7W
  author: Steve Vine
  at: 2026-07-12T07:41:09.03655033Z
  text: 'Smoke tests passed. PR #32 merged to main (637feac), branch deleted. Belt-and-braces main run green (frontend skipped — backend-only). Done. Sprint 3 (Phase 2 — State Sync) fully complete: 13/13 (ISE-20..31 + ISE-34).'
assignee: steve
priority: low
task_status: done
---
Follow-up to ISE-24 (deferred pending live keys, now available). Add the read-state service-map slice (APM service dependencies / service definitions) and event-based detect (alert/error events via EventsApi), validated against the real DataDog EU org. Extends the existing DataDogConnector; contract tests + live check.
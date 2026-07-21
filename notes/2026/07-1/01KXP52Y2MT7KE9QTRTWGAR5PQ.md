---
id: 01KXP52Y2MT7KE9QTRTWGAR5PQ
created: 2026-07-16T19:05:06.388531083Z
updated: 2026-07-21T17:44:29.377081Z
type: task
title: Per-issue timeline API — unified event feed
project: 01KX671DATY39VW6GWK3M2T3DN
number: 92
sprint: s0v93ii
blocked_by:
- 01KXP51V7CR9VDWE6Z4T9WEV1F
- 01KXP52NRFDXD3Z6KTDXGFS1G0
assignee: steve
label: null
priority: high
task_status: done
---
Expose the merge-on-read timeline the ADR (ISE-89) specifies — the single ordered feed the redesigned screen renders. **No new event table**; merge existing sources on read.

`GET /api/v1/issues/{id}/timeline` → an ordered, typed **discriminated union** of events, each with a `type`, `at` timestamp, `actor`, and a render payload:
- **conversation messages** (user + assistant) — from the issue conversation (ISE-91).
- **status transitions** — from the append-only `AuditEvent` filtered by `entity_id` (`api/v1/audit_log.py`): `acknowledged`/`resolved`/`dismissed`, `diagnosis_requested`, `remediation_requested`, `assignee` changes.
- **proposed changes** — this issue's `ProposedChange` rows (tier, operation, parameters, status, decided_by/at, execution result).
- **agent runs** — `AgentRun`s linked to the issue (analyse/diagnose/propose + the post-execution follow-up), with a link to `/agent-runs/{id}` for the full tool-call trace.
- **execution results** — from `ProposedChange.result` (before/after, rollback note).

Viewer-gated read. Ordered by time; paginate. Declare the union in the OpenAPI schema so the frontend renders from typed events, not shape-sniffing (ADR 0013 spirit). This replaces the four separate stacked panels on today's `IssueDetailPage.tsx` (Diagnosis / Remediation / ProposedChanges / Evidence) with one feed.

Blocked by the ADR (ISE-89) and the conversation model (ISE-91, whose messages it merges). Label: feature.
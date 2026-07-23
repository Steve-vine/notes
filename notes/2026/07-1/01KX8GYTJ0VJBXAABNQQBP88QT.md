---
id: 01KX8GYTJ0VJBXAABNQQBP88QT
created: 2026-07-11T12:03:12.576483821Z
updated: 2026-07-23T19:50:31.189015Z
type: task
title: UI — Issues queue (read + manual lifecycle)
project: 01KX671DATY39VW6GWK3M2T3DN
number: 29
sprint: sdm5e08
blocked_by:
- 01KX8GYFYR77GNS41SCQN1QXE8
comments:
- id: 01KX99SB0B2K9AY6A7CF9QCQPA
  author: Steve Vine
  at: 2026-07-11T19:17:07.211512419Z
  text: 'Development complete on feature/ise-029-issues-queue. PR #30: https://github.com/Steve-vine/ise/pull/30. Replaces the Issues placeholder with a live queue + detail view surfacing ISE-26 promoted findings alongside manual issues. IssuesPage: filterable table (system/severity/status/source), rows show severity pill, title→detail, system name, status pill, source-tagged pill; per-screen polling. IssueDetailPage (/issues/:id): narrative (title, severity/status/source pills, raised-by/when), description, evidence panel (promoted issues link finding→owning system state + raw evidence JSON), operator-gated lifecycle controls (Acknowledge/Resolve/Dismiss) mirroring backend VALID_TRANSITIONS, hidden from viewers + on terminal issues. Nav item live; routes replace PlaceholderPage. Backend additive (ADR 0009): GET /issues gains system_id + severity filters (alongside status/source); regenerated openapi.json+types. Tests: backend mypy/ruff clean, new test_issue_list_filters, crud+promotion 18 pass; frontend tsc/eslint/prettier clean, 24 tests (4 new — queue lists promoted+manual with source, detail evidence+operator lifecycle, viewer sees no lifecycle). PR CI fully green. Merged to staging (ac3415e); staging test suite + build-images green; deploy-staging Helm upgrade + Rollout status succeeded, only the post-deploy Smoke curl failed — SAME transient TCP flake, now 3rd consecutive (ISE-34 bumped to high). Verified LIVE on g5: ise-api/frontend/worker/beat all freshly rolled (~105s) and 1/1 Running. This one has a real UI surface to smoke test — the Issues queue should now show promoted findings from g5/datadog plus any manual issues, filterable. Awaiting UI smoke test + merge clearance.'
- id: 01KX9CDQ600YWDTVKQ0G9XAKW3
  author: Steve Vine
  at: 2026-07-11T20:03:12.19212697Z
  text: 'Smoke tests passed. PR #30 merged to main (6e77411), branch deleted. Belt-and-braces main run green (test suite + production build). Done.'
assignee: steve
label: null
priority: medium
task_status: done
---
Filterable/sortable issues table (ui-brief): system, severity, status, source (manual vs finding-promoted). Issue detail: narrative, evidence panel (finding/snapshot links), lifecycle controls. Replaces the Phase-2 Issues placeholder in the nav. Uses the ISE-15 issues API + finding promotion; generated types.
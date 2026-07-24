---
id: 01KX8GYFYR77GNS41SCQN1QXE8
created: 2026-07-11T12:03:01.72069059Z
updated: 2026-07-24T16:07:42.650246Z
type: task
title: Finding → Issue promotion
project: 01KX671DATY39VW6GWK3M2T3DN
number: 26
sprint: sdm5e08
comments:
- id: 01KX95AR0AQGKFSD4C53R0YPPR
  author: Steve Vine
  at: 2026-07-11T17:59:14.6981026Z
  text: 'Development complete on feature/ise-026-finding-promotion. PR #29: https://github.com/Steve-vine/ise/pull/29. Deterministic (no-AI) promotion of connector findings to ISE Issues, run inside the sync transaction after findings flush. Data model (migration 0007, append-only): issue.source (manual|finding-promoted, CHECK; existing rows default manual) + unique issue.finding_id FK — the unique link DB-enforces idempotency so a re-synced firing finding never duplicates. Lifecycle: firing→create open issue (evidence carries finding_id/source_key/kind/details, created_by=finding-promotion); cleared→resolve (mirrors ISE-22); recurrence→reopen; operator dismissal sticky. Counts surface in the synced audit record + sync result. API additive (ADR 0009): IssueRead exposes source/finding_id; GET /issues gains a source filter; regenerated openapi.json+types. Tests: backend mypy/ruff clean, migration 0007 up/down round-trips, 6 new promotion tests (evidence+source, idempotency, resolve-on-clear, reopen-on-recur, sticky-dismiss, e2e via sync_one with manual issues coexisting), FULL SUITE 129 passed; frontend tsc clean, generated types pass prettier. PR CI fully green (incl. migration check in backend job). Merged to staging (a44721b); staging test suite + build-images green; deploy-staging Helm upgrade (ran the 0007 pre-upgrade migration hook — Helm waits on it, so migration applied) + Rollout status succeeded, only the post-deploy Smoke curl failed with the SAME transient TCP-connect timeout as ISE-27 (2nd occurrence → filed ISE-34 to add a retry loop). Verified LIVE on g5: ise-api/frontend/worker/beat all freshly rolled (~2m) and 1/1 Running. NOTE: backend-only — promoted issues have no UI surface until ISE-29 (Issues queue), so there''s little to click-smoke-test; acceptance rests on the test suite + healthy deploy. Awaiting merge clearance.'
- id: 01KX98NV1CQC76WR5JZ4EQ4SS0
  author: Steve Vine
  at: 2026-07-11T18:57:43.98069741Z
  text: 'Smoke tests passed. PR #29 merged to main (6e6b916), branch deleted. Belt-and-braces main run green (test suite + production build). Done.'
assignee: steve
label: null
priority: medium
task_status: done
---
Promote native findings to ISE-level Issues carrying evidence links (finding + snapshot refs) and source=finding-promoted, alongside the existing manual issues (ISE-15). Deterministic mapping (no AI). Idempotent — a re-synced finding doesn't spawn duplicate issues.
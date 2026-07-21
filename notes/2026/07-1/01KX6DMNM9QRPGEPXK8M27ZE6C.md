---
id: 01KX6DMNM9QRPGEPXK8M27ZE6C
created: 2026-07-10T16:26:45.257247189Z
updated: 2026-07-21T16:17:08.607118Z
type: task
title: Helm chart — API, worker, beat, migration pre-upgrade hook
project: 01KX671DATY39VW6GWK3M2T3DN
number: 8
sprint: sh9ng2k
blocked_by:
- 01KX6DKNCP0TJDRGXS8GHHYAKK
- 01KX6DKY441NZS7H767CCFQAE4
- 01KX6DMKFCYDB4VHZMFMPKRRZ3
comments:
- id: 01KX6RTF0B9F4CKK4ZEHY11WHV
  author: Steve Vine
  at: 2026-07-10T19:42:09.41894893Z
  text: 'Development complete on feature/ise-008-helm-chart. PR #9: https://github.com/Steve-vine/ise/pull/9. ISE is LIVE on staging: https://ise.citops.net (LE cert via DNS-01). Chart in helm/ per ADR 0012 (Compass pattern): api/worker/beat/frontend + bundled Valkey, migrations only via pre-upgrade hook (ADR 0005). Bootstrap infra applied to g5: namespace ise, CNPG ise-postgres (healthy), CI deployer RBAC, Cloudflare A record ise.citops.net. CI deploy-staging job live — first real deploy succeeded end-to-end: helm upgrade + migrate hook (alembic_version=0001 in CNPG), rollout, smoke checks green. Verified live: all 6 pods running, /api/v1/meta served through the nginx proxy on the public URL, Beat heartbeat firing every 60s through Valkey with JSON logs. Awaiting smoke test and merge clearance.'
- id: 01KX6S659WK8SCDVH2B56DD5B9
  author: Steve Vine
  at: 2026-07-10T19:48:32.700318425Z
  text: 'Smoke tests passed. PR #9 merged to main (b394b65), branch deleted. Belt-and-braces main run green: main-tagged images pushed, deploy-staging correctly skipped on the main push (staging is the only deploy target for now). Done.'
assignee: steve
priority: medium
task_status: done
---
Helm chart deploying API + Celery worker + beat to staging (ADR 0012), with Alembic migrations run as a Helm pre-upgrade hook only — never at container startup (ADR 0005).
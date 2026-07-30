---
id: 01KYSFNC0CBEWH3471N0T1ZBMD
created: 2026-07-30T12:23:21.356255Z
updated: 2026-07-30T12:57:15.078232Z
type: task
title: Add mount to the XR
project: 01KYSAV18TJ88R2CXJDAJ2NGAJ
number: 4
order: 2.0
sprint: spnxcp3
assignee: steve
priority: medium
task_status: done
---
Add share-ai-agent-docs-dev under efs-envstagingus in env/staging/build/env-staging-xr.yaml (mirror the UK entry: rootDirectory /dev/ai-agent-docs, namespace chinwag-v2-dev, uid/gid 1000) — without this, management-api won't start.
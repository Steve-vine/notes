---
id: 01KYSFNC0CBEWH3471N0T1ZBMD
created: 2026-07-30T12:23:21.356255Z
updated: 2026-07-30T12:23:21.356255Z
type: task
title: Add mount to the XR
assignee: steve
priority: medium
sprint: spnxcp3
task_status: todo
project: 01KYSAV18TJ88R2CXJDAJ2NGAJ
number: 4
---
Add share-ai-agent-docs-dev under efs-envstagingus in env/staging/build/env-staging-xr.yaml (mirror the UK entry: rootDirectory /dev/ai-agent-docs, namespace chinwag-v2-dev, uid/gid 1000) — without this, management-api won't start.
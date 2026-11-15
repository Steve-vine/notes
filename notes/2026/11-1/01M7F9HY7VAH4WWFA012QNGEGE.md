---
id: 01M7F9HY7VAH4WWFA012QNGEGE
created: 2026-11-15T09:45:29.595563Z
updated: 2026-11-15T10:57:59.77624Z
type: task
title: The core "Microsoft" integration is called "Microsoft 365" everywhere
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1842
sprint: spsp226
assignee: steve
label:
- improvement
priority: low
task_status: active
---
## What happened

Steve, testing Integrations (2026-11-15): the core integration's tile and page are named "Microsoft", but what it connects to is the Microsoft 365 tenant. Its own purpose line already reads "Reads and changes your Microsoft 365 directory, mail and SharePoint", and the Admin ▸ Integrations card heading inside it says "Microsoft 365". The name comes from the frontend registry (`integrations/registry.ts`, key `microsoft`, `name: 'Microsoft'`). The backend doesn't name it.

## What people see

- The tile in the Integrations library, the integration's page header, the trail, Find a page and pinned pages all say **Microsoft 365**.
- So do links that point to it, for example COM-1835's Review line "Set what it's used for", which opens Microsoft 365 ▸ What we use it for.
- Polaris's words for it match.
- The address and key stay as they are (`microsoft`), so saved links and pins keep working.

## Done when

- On staging, nothing on screen names this integration plain "Microsoft".
- An existing pin or link to it still opens it, now titled Microsoft 365.
- Vitest updated wherever it asserts the old name.

**Independent** (a screen label only, no API or migration).
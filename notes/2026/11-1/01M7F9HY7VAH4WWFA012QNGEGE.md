---
id: 01M7F9HY7VAH4WWFA012QNGEGE
created: 2026-11-15T09:45:29.595563Z
updated: 2026-11-17T19:50:07.562194Z
type: task
title: The core "Microsoft" integration is called "Microsoft 365" everywhere
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1842
sprint: spsp226
comments:
- id: 01M7FFWJM5VR0MFZ7BF27QRYPK
  author: Steve Vine
  at: 2026-11-15T11:36:09.604883Z
  text: |-
    Built and merged — PR #1833 (d23606cc).

    - The core integration is called **Microsoft 365** everywhere: its tile, page header and trail, plus every hint that points to it (Shared mailboxes, List senders, Conditional Access, sign-in mappings, "switched off on the Microsoft 365 integration" messages, Secrets "kept in", Azure's overview line).
    - The address stays /admin/integrations/microsoft, so saved links and pins still open it, now titled Microsoft 365.
    - "Sign in with Microsoft" is left alone (Microsoft's own name for the button). Polaris had no wording of its own for it.
    - Tests: Vitest for the Integrations pages, backend test for the switched-off message.

    Will be on staging with the rest of the sprint.
- id: 01M7FSSJ6B1J7B4236EF1B91TE
  author: Steve Vine
  at: 2026-11-15T14:29:16.619396Z
  text: |-
    **Passed** — pre-UAT, staging build 20261115-1354 (36d3de6c), E2E Test Company, as E2E Admin A.

    - Admin ▸ Integrations ▸ Core: the tile reads **Microsoft 365** (Identity & directory, "Can change things", Connected).
    - Opened the old address /admin/integrations/microsoft directly. It opens with the header **Microsoft 365** and the trail "Integrations › Microsoft 365".
    - Went through all five tabs (Overview, Configure, What we use it for, Features, Status). Every "Microsoft" on them is "Microsoft 365", "Microsoft Graph" or Microsoft's own "Sign in with Microsoft" wording, which was deliberately left alone.
    - The Azure page says "a separate app from the Microsoft 365 integration's Entra app". Secrets, Shared mailboxes and Conditional Access show nothing that calls it plain "Microsoft". The hints there only show while the connection isn't set up, and in E2E it is set up.
    - Pins and Find a page: the floating menu pins and finds only menu pages (Integrations, not a single integration), so no pin to it can exist. Find a page for "Microsoft" finds nothing. Nothing there names it plain "Microsoft".

    Screenshots: ~/compass-uat/spsp226/COM-1842/
assignee: steve
label:
- improvement
priority: low
task_status: done
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
---
id: 01M8GQ21FYBV4W1AK1GYSTRJE9
created: 2026-11-28T09:16:24.958786Z
updated: 2026-11-28T09:50:02.97851Z
type: task
title: Adding an integration asks Web/API or Server first, on the Collection and Action tabs alike
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2226
sprint: s09wwd3
assignee: steve
label:
- feature
priority: high
task_status: todo
---
**On the chain** (integration kinds in the API). After the Scripting phase 2 ADR.

## What people see
- **Admin ▸ Integrations ▸ Collection ▸ Add** and **▸ Action ▸ Add** both start with one question: **Web/API** or **Server**.
  - **Web/API**: an address, a sign-in, paging and a test read, as a Collection integration is set up today.
  - **Server**: then *how Compass reaches it*. **SQL Server database** this stage; Windows server and SSH appear when they're built (or are listed as "coming later"; decide in the PR).
- Today's Collection integrations are all Web/API and read as such. Today's action integrations are all Server ▸ SQL Server database. Nothing about them changes.
- Each list shows the family and kind beside each integration's name, and can be filtered by them.
- The Polaris wizard for Collection integrations still sets up Web/API ones. A Server one is added on screen.
- While a tab has only one choice, it isn't asked.

**Done when:** on staging, both Add screens ask Web/API or Server; an existing integration of each tab reads with its family; and nothing an existing integration does has changed.
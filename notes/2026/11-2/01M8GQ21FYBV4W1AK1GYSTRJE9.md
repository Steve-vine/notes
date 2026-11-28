---
id: 01M8GQ21FYBV4W1AK1GYSTRJE9
created: 2026-11-28T09:16:24.958786Z
updated: 2026-11-28T12:08:25.185036Z
type: task
title: Adding an integration asks Web/API or Server first, on the Collection and Action tabs alike
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2226
sprint: s09wwd3
comments:
- id: 01M8H0WYVG4KTYZKPJAZR15XX4
  author: Steve Vine
  at: 2026-11-28T12:08:24.176669Z
  text: 'Done in PR #2234 (merged). Both Add screens start by asking Web/API or Server, then (for a Server) how Compass reaches it. A question with only one answer isn''t asked. Now that COM-2227 and COM-2228 are built, both tabs ask the first question; Server has one kind (SQL Server database), so it goes straight to that form. Existing integrations read as before: Collection ones as Web/API, action ones as "Server · SQL Server database". Each tile shows its family and kind, and a Kind filter appears once a tab holds more than one kind. Decided in the PR, as the task asked: Windows server and SSH aren''t listed as "coming later"; they''ll appear when they''re built. The Polaris wizard still sets up Web/API integrations only.'
assignee: steve
label:
- feature
priority: high
task_status: review
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
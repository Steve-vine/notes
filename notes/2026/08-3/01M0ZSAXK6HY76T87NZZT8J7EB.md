---
id: 01M0ZSAXK6HY76T87NZZT8J7EB
created: 2026-08-26T19:39:14.918673Z
updated: 2026-08-27T19:58:21.388892Z
type: task
title: Page titles stand on their own — drop the subtitle under every page heading
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 436
sprint: smnkt3k
assignee: steve
company:
- moneypenny
label:
- improvement
priority: medium
task_status: active
---
Nearly every screen carries a grey line under its heading restating the heading — Reports says *"Audit-ready exports for Default."*, Gaps says *"Default — shortfalls tracked to closure."*, Decisions says *"Architecture decision records — what we decided, and why."* Nobody reads them after the first visit, and they push the actual content down the page on every screen in the app.

## What changes for the reader

**The heading is the whole header.** Content starts straight under it, higher up the page, and every screen begins the same way.

## Scope

Remove the dimmed line that sits directly under the page title, on every page in the main app and both portals: Dashboards, Reports, Actions, Assessments, Gaps, Risks, Decisions, Content, Domains, Controls, Frameworks, Vendors, Access Control's pages, Activity, Notifications, Search, Admin, the User Portal and the Vendor Portal.

**Do not remove the "Select a company…" text.** Several pages render *"Select a company to see its gaps."* and its siblings as the entire body of an empty state, with no content behind it — that line is the screen's only content when no company is chosen, and it stays. Only the subtitle shown alongside real content goes.

Where a header currently spaces itself for two lines, tighten it so the gap under the title matches a page that never had a subtitle.

Companion to the tab-subtitle task, which does the same job one level down. Both touch the same headers on the tabbed screens, so land them in order rather than at once.

## Tests

Some page tests assert on the subtitle text — update rather than delete them where the assertion was the only thing proving the page rendered.
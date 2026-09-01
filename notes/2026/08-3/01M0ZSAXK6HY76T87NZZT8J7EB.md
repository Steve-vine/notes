---
id: 01M0ZSAXK6HY76T87NZZT8J7EB
created: 2026-08-26T19:39:14.918673Z
updated: 2026-09-01T13:55:52.257076Z
type: task
title: Page titles stand on their own — drop the subtitle under every page heading
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 436
sprint: smnkt3k
comments:
- id: 01M12DSTHQ281DAKV88TX04W62
  author: Steve Vine
  at: 2026-08-27T20:15:23.702849Z
  text: |-
    Done — PR #455.

    24 subtitles gone: Actions, Activity, Admin, Assessments, Content, Controls, Decisions, Domains, Frameworks, Gaps, Notifications, Reports, Risks and Vendors in the main app; Access Graph, Devices, Directory roles, Groups, Recertification, Access requests, Role matrix, Users and Validation under Access Control; Actions in the user portal. Content now starts straight under the title on every screen.

    Two kinds of dimmed line stayed, and the difference is the thing a future sweep will get wrong.

    A line with nothing behind it is the screen, not a subtitle. "Select a company to see its gaps." does not restate the heading — with no company chosen it is the entire body of the page, and deleting it leaves a heading over blank space. Same for "Admins only.", "Not found.", the activity log's admin-only notice, the section permission messages and the placeholder's "Coming soon."

    A line that says something the title does not is content. A decision's "Decided 2026-03-04", a framework's "Effective from …", a control's "was ACC.2", a campaign's "Opened … — reviews due …", a recertification's "Triggered … — 3 of 5 owners submitted", a domain's own description, a vendor's "Next review", and the vendor portal's intro text (which the customer configures) are all data. None restates its heading; none went.

    Section headings inside cards — the rubric explanations, the SSO mapping note, the email transport note — are a level down and were left alone. Tab subtitles are COM-438.

    On spacing: the subtitle was always wrapped with its title in a container whose only job was to hold the two lines together against the page gap. With the subtitle gone that wrapper is unwrapped rather than left holding one child, so the gap under a title now matches Search, which never had a subtitle.

    On tests: no existing test asserted on any of the 24 removed strings — checked before removing, and the suite passed unchanged — so there was nothing to update. The precaution turned out to be needed in the other direction: only 3 of the roughly 12 surviving "Select a company…" lines had any coverage at all. Added it for Gaps, Risks, Vendors and Assessments, because those are exactly what the next sweep for dimmed text under a title would delete. 748 tests pass.
assignee: steve
label:
- improvement
priority: medium
task_status: done
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
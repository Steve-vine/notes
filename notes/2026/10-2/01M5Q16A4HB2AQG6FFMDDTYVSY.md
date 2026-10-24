---
id: 01M5Q16A4HB2AQG6FFMDDTYVSY
created: 2026-10-24T13:21:51.761729Z
updated: 2026-10-24T18:10:13.213449Z
type: task
title: When Compass can't be reached, a page says "Not found" — it should say it couldn't load and offer to try again, and never call a DDQ that exists missing
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1285
sprint: ssgnel8
comments:
- id: 01M5QHP94FW14712CXQ861Z5VG
  author: Steve Vine
  at: 2026-10-24T18:10:12.238687Z
  text: |-
    **Done: PR #1300, merged to main (39f150bb).** Not yet on staging; it goes with the rest of sprint 86.

    **What you'll see**
    - **The record doesn't exist, or you can't see it:** "Not found", as before.
    - **Compass couldn't be reached, or answered with an error:** "Compass couldn't load this — try again", with a **Retry** button.
    - **A refresh fails while the record is on screen:** the record stays, with a yellow notice above it saying "Compass couldn't load the latest — try again" and a Retry button. This is the case you hit on DDQ-3.
    - **Pages that refresh themselves** (an access request, a recertification campaign, a portal recert review) keep their content when a refresh fails. Before, they blanked to "Not found".

    **Root cause:** the detail pages' data hooks turned any failed reply, such as a 502 while the API restarted, into "no such record". That counted as a successful load, so on a refresh it replaced what was already on screen.

    **One shared pattern:**
    - `recordOrNull` in `src/api/load.ts`.
    - `NotLoaded` and `RefreshFailed` in `src/components/LoadState.tsx`.
    - 39 detail pages converted, covering DDQ, data privacy, incidents, posture and playbook, vendors, inventory, SAP, audit evidence, attestations, trust centre, access and the portal.

    **Calls awaiting Steve**
    1. **A malformed id:** a link the server rejects as malformed (422) shows "Not found", because retrying can't help. Everything other than 404, 403 and 422 shows "couldn't load", including an expired session (401).
    2. **No title on the failure page:** the full-page failure shows just the notice and Retry.
    3. **Report edit screen left out:** the edit screen for an existing report (ReportWizardPage) still says "Not found" on any failure. It has a different layout and wasn't converted.
assignee: steve
priority: medium
task_status: review
---
Found running DDQ-3, 2026-10-24. Steve assigned a question; the API was killed for memory a second later (COM-1284); the DDQ page refreshed, its load failed, and the page showed "Not found". Reloading a minute later showed DDQ-3 as normal.

DdqRequestPage renders "Not found" whenever it has no DDQ after loading, so a failed request reads the same as a missing one. DdqAssignedQuestionPage, DsrRequestPage, DsrDisclosurePage, ContentDetailPage, DecisionDetailPage and the Audit evidence pages use the same pattern.

**Do:** tell the two apart.
- **The DDQ, request or document doesn't exist, or you can't see it:** say so, as now.
- **The server couldn't be reached or returned an error:** say "Compass couldn't load this — try again" with a retry, and keep anything already shown on the page.

Use one shared pattern across the detail pages, not a fix to each one.
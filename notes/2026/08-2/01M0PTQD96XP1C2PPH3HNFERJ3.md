---
id: 01M0PTQD96XP1C2PPH3HNFERJ3
created: 2026-08-23T08:10:22.886774Z
updated: 2026-08-25T18:43:11.745333Z
type: task
title: User portal loses its page descriptors
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 378
sprint: sbph5q5
comments:
- id: 01M0Q1DM3J3TYVPERPC4HZSSG5
  author: Steve Vine
  at: 2026-08-23T10:07:22.226482Z
  text: |-
    Done — PR #380, merged to main as 79763e6.

    Removed the standing page-summary sentences from Register/My Vendors, My requests and Recertifications, along with the `<div>` / `<Stack gap={2}>` wrappers that existed only to pair a title with its descriptor, so the spacing closes up rather than leaving a hole.

    Kept, as scoped: the empty states, the "Select a company to see…" prompts, and the per-row dimmed explanations. Two judgement calls worth naming — `PortalRecertReviewPage`'s "Triggered {date} — N of M owners submitted" stays (live data about that review, not a page summary), and the supplier-facing Vendor Portal intro is untouched, since it is configured through branding settings rather than hardcoded.

    Tests: eight `PortalRouting` assertions had been using the Register descriptor as their "we landed on the portal" signal; they wait on the heading now.

    One thing to know while smoke-testing: `PortalRouting > lands a portal-only user on the portal after signing in` flakes locally under full-suite CPU load. I checked it against an unmodified `main` worktree — it fails there too, 2 runs in 3, with the old assertion. Pre-existing, not from this change.
assignee: steve
company: null
label:
- improvement
priority: medium
task_status: done
---
Remove the standing descriptor sentences under the user portal's page titles — e.g. "{company} — approved and pending suppliers." (`PortalVendorsPage.tsx:128`) and "Access reviews assigned to you. Open one to review each member and submit your recertification." (`PortalRecertificationsPage.tsx:30`). The titles and tabs carry the meaning now.

(The ask said "vendor portal", but both examples are **user portal** pages — scoped there. The supplier-facing Vendor Portal's intro text is separately configurable via the branding settings and untouched here.)

- [ ] Sweep all `Portal*.tsx` pages (Vendors/My Vendors, Requests, Approvals, Recertifications, detail pages) and remove the dimmed descriptor line under each page/tab title.
- [ ] **Keep the functional dimmed text**: empty states ("You have not raised any requests yet."), prompts ("Select a company to see your requests."), and inline explanations attached to controls are doing a job — only the standing page-summary sentences go.
- [ ] Check spacing after removal (a `<div>`/Stack that held title + descriptor shouldn't leave a gap).
- [ ] Tests: any assertions on the removed strings updated.
---
id: 01M0PTQD96XP1C2PPH3HNFERJ3
created: 2026-08-23T08:10:22.886774Z
updated: 2026-08-23T08:10:22.886774Z
type: task
title: User portal loses its page descriptors
label: improvement
priority: medium
assignee: steve
task_status: backlog
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 378
---
Remove the standing descriptor sentences under the user portal's page titles — e.g. "{company} — approved and pending suppliers." (`PortalVendorsPage.tsx:128`) and "Access reviews assigned to you. Open one to review each member and submit your recertification." (`PortalRecertificationsPage.tsx:30`). The titles and tabs carry the meaning now.

(The ask said "vendor portal", but both examples are **user portal** pages — scoped there. The supplier-facing Vendor Portal's intro text is separately configurable via the branding settings and untouched here.)

- [ ] Sweep all `Portal*.tsx` pages (Vendors/My Vendors, Requests, Approvals, Recertifications, detail pages) and remove the dimmed descriptor line under each page/tab title.
- [ ] **Keep the functional dimmed text**: empty states ("You have not raised any requests yet."), prompts ("Select a company to see your requests."), and inline explanations attached to controls are doing a job — only the standing page-summary sentences go.
- [ ] Check spacing after removal (a `<div>`/Stack that held title + descriptor shouldn't leave a gap).
- [ ] Tests: any assertions on the removed strings updated.
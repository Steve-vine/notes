---
id: 01M5CQ8MTZHBAG1FARTRQ0AEV5
created: 2026-10-20T13:15:58.175503Z
updated: 2026-10-20T13:15:58.175503Z
type: task
title: The Activity tab — who signed in, which documents they viewed and downloaded, NDAs accepted and requests made, by visitor and by document, with a CSV export
priority: medium
assignee: steve
label: feature
task_status: todo
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1166
---
Sprint 81, Trust Centre Portal (ADR in COM-1157). Builds on COM-1162 (and records NDA acceptances from COM-1163 if it has landed; otherwise COM-1163 adds its event).

## What people see

An **Activity** tab, newest first: when, who (visitor, organisation), what (Signed in, Viewed, Downloaded, Accepted NDA, Asked for access, Asked for a new link), and which document. Filters: visitor, organisation, document, kind, date range. Export to CSV.

**On a visitor:** their own timeline, and "last visit".

**On a document:** how many visitors viewed and downloaded it in the last 30 / 90 days, and who.

**Signed-in summary** at the top: active visitors, visits and downloads in the last 30 days, and the most downloaded documents.

Activity can't be edited or deleted. Anyone who can view the trust centre sees it.

## Notes (technical)

- `trust_centre_events` (company, visitor, kind, document, at, IP, user agent). Insert-only; written by the portal routes (sign-in, document bytes, NDA accept) and the request flow.
- Don't double-count a PDF viewer's range requests: one Viewed per document per visit per few minutes.
- CSV through the existing report/export service (ADR 0024) if it fits; it's a sortable table on screen (SortableTh, screen conventions).

**Done when:** a staging visit shows up as sign-in, view and download events in Activity, on the visitor and on the document, and exports.
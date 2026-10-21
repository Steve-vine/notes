---
id: 01M5CQ8MTZHBAG1FARTRQ0AEV5
created: 2026-10-20T13:15:58.175503Z
updated: 2026-10-21T09:16:47.447973Z
type: task
title: The Activity tab — who signed in, which documents they viewed and downloaded, NDAs accepted and requests made, by visitor and by document, with a CSV export
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1166
sprint: sq3fav7
blocked_by:
- 01M5CQ74BZWHT0AQSAG1SS7NEE
comments:
- id: 01M5E9TYBHD9Q4KYJ8K5WQZC2S
  author: Steve Vine
  at: 2026-10-21T03:59:46.54531Z
  text: |-
    Done — merged in two parts: #1184 and #1186.

    - **Activity**, newest first: Signed in, Viewed, Downloaded, Accepted NDA, Asked for access and Asked for a new link, each with who, their organisation and the document.
    - A summary of the last 30 days sits at the top: active visitors, visits, downloads and the most-downloaded documents.
    - Filter by visitor, organisation, document, kind and date range. Filters stay in the address, so a filtered view can be bookmarked or shared.
    - **Export CSV** exports every matching row. The screen itself shows the newest 2,000.
    - On a visitor: their last visit and a timeline of everything they did.
    - On a document: "Who has read …" for the last 30 and 90 days.
    - A new-link request in Requests now says what the visitor downloaded while their access lasted: three documents with their latest download, then "and N more", or "Downloaded nothing."
    - Activity is permanent: it can't be edited or deleted.

    My calls:
    - Reopening the same document several times in one visit counts as one view per 5 minutes, so the numbers reflect reading rather than clicking. Every download counts.
    - "Asked for a new link" is recorded only when a request is actually created. Asking again while one waits, or an ask that's refused, adds nothing.
    - Each entry keeps its own copy of who did it, so a request from someone who never became a visitor still reads correctly.
assignee: steve
label:
- feature
priority: medium
task_status: done
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
---
id: 01M7R345XZ85ZSDPTXW24JMWY1
created: 2026-11-18T19:46:17.151385Z
updated: 2026-11-19T01:23:23.487094Z
type: task
title: 'Library reader: the details under the title show the document''s Domain'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1975
sprint: s2q1gxe
blocked_by:
- 01M7QV0XWQ5RFSZ6A4EWXE6AG5
comments:
- id: 01M7RGQY19YSMKQEKE9XXXYF42
  author: Steve Vine
  at: 2026-11-18T23:44:15.913507Z
  text: |-
    Merged: PR #1974, merge ba1da238. No migration; the reader's data now includes the document's domain.

    What changed for a reader: the row of details under a document's title now reads Domain · Reviewers · Approved by · Next review. The domain's name links to its folder in the Library (from COM-1966). A document with no domain shows "—". A decision record's row is unchanged. The name is always the domain's current one, so a rename shows straight away.

    Assumptions you may want to overturn:
    - While a domain is disabled, its Library folder is hidden. The reader then shows the domain's name as plain text, with no link.
    - I didn't add Domain to the "Document control" block at the foot of the reader. It's in the row under the title only.
- id: 01M7RPDE6ZF9F1CX40G8X77PGA
  author: Steve Vine
  at: 2026-11-19T01:23:23.486896Z
  text: |-
    Pre-UAT (staging 25f02b9c, E2E Admin A): **Passed**.
    - The row under the title reads Domain · Reviewers · Approved by · Next review, e.g. "Access Control" or "Information Security Governance". Clicking the domain opens its Library folder.
    - A document with no domain shows "Domain —". Decision DEC-10's row is Decided by · Decided, with no Domain.
    - The link reads well in dark mode. At 390 px the row wraps cleanly.
    - Not tried: renaming a real domain on staging. The automated tests cover the name following a rename.
    Screenshots: ~/compass-uat/library/COM-1975/.
assignee: steve
label:
- improvement
priority: medium
task_status: review
---
Steve, testing the Library (18 Nov): "In the section below the title where we have REVIEWERS, APPROVED BY, NEXT REVIEW - Can you also add DOMAIN"

## What changes
- The row of details under a document's title in the reader reads **Domain · Reviewers · Approved by · Next review**, with Domain first since it says what the document is about. It shows the domain's name, e.g. "Information Security Governance".
- Clicking the domain name opens that domain's folder in the Library (COM-1966's fixed domain folders).
- A document with no domain shows "—", as the other details do when empty.
- Decision records have no domain, so their row (Decided by · Decided) is unchanged.
- The domain follows a rename or a delete, as COM-1966's folders do; the reader always shows the current name.

## Implementation notes
- The reader's data (`LibraryReadingOut`, `api/v1/library_reader_schemas.py`) has no domain today. Add `domain: {id, name} | None` (or `domain_id` + `domain_name`), filled from the content's domain; null for decisions. Regenerate OpenAPI + `schema.d.ts`.
- `libraryFolders/ReaderPage.tsx` `Facts`: prepend `['Domain', …]` for content; render it as a link to the domain folder's Library URL (whatever COM-1966 settles on); plain text if that isn't available.
- Optionally add Domain to the "Document control" block at the foot of the reader (`DocumentControl`) too, for symmetry; keep the house-style PDF untouched unless Steve asks.
- **On the chain** (API change: new field on the reader response). Build after COM-1966 so the link target exists.

## Done when
- Reading a policy in the reader shows DOMAIN with its domain name beside Reviewers, Approved by and Next review, and clicking it opens that domain's Library folder.
- Renaming the domain changes the name shown; a document without a domain shows "—"; a decision record's row is unchanged.
- Light and dark mode; the row still wraps cleanly at narrow width.
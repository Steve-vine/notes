---
id: 01M5CQ89NJHJJWJ8YX5E5ZE6JC
created: 2026-10-20T13:15:46.738735Z
updated: 2026-10-20T20:49:01.266645Z
type: task
title: Certification badges on the trust centre overview — ISO 27001, SOC 2, Cyber Essentials and the rest, each shown while its uploaded certificate is in date and gone the day it expires
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1165
sprint: sq3fav7
blocked_by:
- 01M5CQ74BZWHT0AQSAG1SS7NEE
assignee: steve
label:
- feature
priority: medium
task_status: active
---
Sprint 81, Trust Centre Portal (ADR in COM-1157). Builds on COM-1159 (certificate scheme on a document) and COM-1162.

## What people see

**On the portal:** a row of badges at the top of the overview, one per scheme the company holds a current certificate for: "ISO 27001 · valid until Mar 2027". Clicking a badge goes to that certificate in Documents (or, if the certificate is restricted and the visitor hasn't been given it, shows "Ask <contact email> for the certificate").

A badge is there only while a **Certificate** document for that scheme is shown and in date. When the certificate expires or is hidden, the badge goes with it. A renewed certificate keeps the badge.

Two certificates of the same scheme (e.g. two entities) show one badge with the later date.

**In the module:** Documents shows which certificates are driving a badge, and a preview of the badge row as visitors see it.

Badges are simple text-and-icon tiles in Compass's style, not the certification bodies' logos (their logos have usage rules Compass can't check).

## Notes (technical)

- Derived, no new table: shown, unexpired `trust_centre_documents` with category Certificate, grouped by scheme.
- The scheme list lives in one place, shared with COM-1159's picker. "Other" uses the document's name as the badge text.

**Done when:** uploading an in-date ISO 27001 certificate shows its badge on staging; setting its valid-until to yesterday removes it.
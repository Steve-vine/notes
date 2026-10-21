---
id: 01M5CQ89NJHJJWJ8YX5E5ZE6JC
created: 2026-10-20T13:15:46.738735Z
updated: 2026-10-21T02:46:42.550979Z
type: task
title: Certification badges on the trust centre overview — ISO 27001, SOC 2, Cyber Essentials and the rest, each shown while its uploaded certificate is in date and gone the day it expires
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1165
sprint: sq3fav7
blocked_by:
- 01M5CQ74BZWHT0AQSAG1SS7NEE
comments:
- id: 01M5E5N2N6M8BMKRJN5E08N4CB
  author: Steve Vine
  at: 2026-10-21T02:46:40.038355Z
  text: |-
    Done — merged in PR #1181.

    - A row of badges sits at the top of the visitor's overview, e.g. "ISO 27001 · valid until Mar 2027".
    - A scheme gets a badge while one of its certificates is uploaded, shown and in date. The badge goes the day after the certificate expires, or as soon as it's hidden or removed. Uploading a renewal brings it back. There's nothing to maintain by hand.
    - Two certificates for one scheme give one badge, with the later date. An "Other" certificate shows its own name.
    - Clicking a badge goes to its certificate in Documents. If the certificate is restricted and the visitor wasn't given it, they see "Ask security@… for the ISO 27001 certificate."
    - In the Documents tab, each certificate behind a badge says "Shows the ISO 27001 badge", and a "Badges on the overview" card previews the row.

    My calls:
    - Badges are an icon and text, never a certification body's own logo, because those logos have usage rules.
    - A badge shows even when its certificate is restricted. The visitor learns the certification exists, and the badge tells them who to ask for the certificate.
assignee: steve
label:
- feature
priority: medium
task_status: review
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
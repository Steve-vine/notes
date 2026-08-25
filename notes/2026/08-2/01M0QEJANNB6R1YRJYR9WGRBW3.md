---
id: 01M0QEJANNB6R1YRJYR9WGRBW3
created: 2026-08-23T13:57:07.893296Z
updated: 2026-08-25T18:43:23.644054Z
type: task
title: 'Vendors list: a Certified badge — green all valid, amber expiring ≤30 days, red expired, blank when none'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 394
sprint: sbph5q5
comments:
- id: 01M0R5AZ0JWGDSAAKFZ3ZZGT3E
  author: Steve Vine
  at: 2026-08-23T20:35:03.826046Z
  text: |-
    Done — PR #399 (branch feature/com-394-certified-badge), stacked on #398 because both regenerate `schema.d.ts`.

    Built to the shape in the task: `certification_status` on `VendorOut`, derived at read time in `core/vendor_reads.py` by one grouped query (`certification_status_by_vendor`) alongside flags/reviews/engagements, so the register keeps its fixed round-trip count. The portal gets it through the shared reads, as expected.

    The whole rule is `min(valid_until)` per vendor: SQL's `min` skips NULLs, so a vendor whose certificates never expire comes back with a row and no date — valid, nothing to chase. Otherwise the earliest expiry decides: `< today` expired, `<= today+30` expiring, else valid. Red > amber > green falls out of taking the earliest date rather than needing precedence logic.

    Two decisions worth recording:
    - **Teal, not green,** for valid. It's the same "this is fine" the register already uses for compliant and approved; a second good-news colour would read as a different kind of good news.
    - **"Expiring soon", not "Expiring".** The bare word reads as a permanent state; the badge exists to say there is a month left to act.

    No certifications stays blank (`null`), not a fourth colour — the register has no basis for a judgement there.

    Tests: integration test walking one vendor none → valid → the 31-day/30-day boundary → expired, then back down as certificates are removed, plus the batched register answer; the portal register test asserts the field arrives there; frontend tests for the badge, the wording, the blank cell, and the portal sub-row keeping its columns aligned now the table is one wider.
assignee: steve
company: null
label:
- feature
priority: medium
task_status: done
---
The vendors list (admin register and user portal) says nothing about certifications; you open each vendor to learn ISO/SOC2 posture.

## Change

Add a **Certified** column to both lists, carrying a badge derived from the vendor's certifications (`vendor_certifications.valid_until`, ADR 0039 §7):

- **red** — any certification has expired (`valid_until` < today)
- **amber** — none expired, but any expires within the next 30 days
- **green** — certifications exist and all are valid (a null `valid_until` never expires, so it counts as valid)
- **blank** — the vendor has no certifications

Red > amber > green precedence.

## Shape

- Backend: `certification_status: "valid" | "expiring" | "expired" | null` on `VendorOut`, derived at read time in `core/vendor_reads.py` — one batched `certifications_by_vendor`-style query alongside flags/reviews/engagements, so the register keeps its fixed round-trip count. Shared reads mean the portal (`api/v1/portal.py`) gets it for free.
- Frontend: badge column in `pages/VendorsPage.tsx` and `vendors/PortalVendorsPage.tsx`; regen `schema.d.ts`.
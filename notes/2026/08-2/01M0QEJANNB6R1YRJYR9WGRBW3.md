---
id: 01M0QEJANNB6R1YRJYR9WGRBW3
created: 2026-08-23T13:57:07.893296Z
updated: 2026-08-23T14:03:56.658225Z
type: task
title: 'Vendors list: a Certified badge — green all valid, amber expiring ≤30 days, red expired, blank when none'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 394
sprint: sbph5q5
assignee: steve
label:
- feature
priority: medium
task_status: todo
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
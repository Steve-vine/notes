---
id: 01KZRTW1YX84XH9W982B3SBKJF
created: 2026-08-11T16:35:42.173254Z
updated: 2026-08-11T16:35:42.173254Z
type: task
title: Rename Application → Business Application
label: chore
priority: medium
assignee: steve
task_status: backlog
project: 01KX671DATY39VW6GWK3M2T3DN
number: 653
---
**Do this first.** The `application` table has ZERO rows today, so this is a type/table rename with no data migration and no entity re-typing. It stops being free the moment anyone confirms a proposal.

- Entity type `application` (asserted layer) → `business-application`; `application` table → `business_application`
- API `/api/v1/applications` → `/api/v1/business-applications`; regenerate OpenAPI + api-types
- Frontend route, nav entry (`components/nav.ts`), page + tests
- `_NON_MEMBER_TYPES` → `("business-application", "business-service", "group")`

**The 92 discovered `application` entities keep their type** — they are genuinely applications: Cloudflare 30, Twilio 17, Claude 5, GitHub 5, M365 service health 35. None are Azure App Services.

**Fix the confusion this caused.** Estate shows 92 "Applications" while the Applications page shows zero, with nothing on screen distinguishing them — that is why they were unrecognisable. Show the operator on the Estate row (0073 §5: "external-ness is an attribute — who operates it — not a type"), and have the Business Applications page state plainly that it lists asserted ones.

Also decide: do the 30 Cloudflare **edge locations** ("Cloudflare — Ashburn, VA (IAD)") belong in the estate at all? They are points of presence, not applications — status-page granularity leaking through the register.
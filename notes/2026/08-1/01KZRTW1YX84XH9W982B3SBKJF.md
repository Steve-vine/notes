---
id: 01KZRTW1YX84XH9W982B3SBKJF
created: 2026-08-11T16:35:42.173254Z
updated: 2026-08-13T19:00:02.760492Z
type: task
title: Rename Application → Business Application
project: 01KX671DATY39VW6GWK3M2T3DN
number: 653
sprint: sj9fsph
comments:
- id: 01KZS9VC3Z87VWVWGPPCSADZJY
  author: Steve Vine
  at: 2026-08-11T20:57:28.447036Z
  text: |-
    Done — PR #605, merged to main as e210f02. Migration 0128.

    The rename is through the entity type, table (+ PK/FK/unique constraints), proposal kind, module, API prefix, frontend route, nav, page and panel. `_NON_MEMBER_TYPES` drops `application`, which is what makes an externally-operated application an eligible **member** per ADR 0096 §6. `Impact.applications` → `business_applications` on the API too, so ISE-656 doesn't have to carry a rename alongside the walk fix.

    **The migration test earned its place twice** — both faults would have surfaced in the staging pre-upgrade hook, not in review:
    1. The proposal-kind CHECK is *replaced*, not widened, so swapping it before moving the rows fails on any estate that has ever raised one (a CHECK is validated against existing rows at CREATE time). Constraint off → rows move → constraint on.
    2. **`audit_event` is append-only, enforced by a trigger.** I had the migration rewriting the three audit action names; it can't, and shouldn't — the log records what happened under the name in force at the time. Old rows stay as they are; only new writes use the new spelling.

    The test itself pins the assertion the migration exists to survive: the asserted entity re-types and the discovered one does not. A naive `WHERE type='application'` would have swallowed all 92.

    **Two judgement calls worth flagging:**

    - **`entity_layer` unchanged.** Both `application` and `business-application` still map to the `application` layer. Moving the discovered ones to `resource` would sweep 92 SaaS entities into the tag-compliance rule ("every Resource carries exactly one of `app` or `project`") and mint 92 gaps nobody can ever close.
    - **Cloudflare edge locations: they don't belong in the estate** — a point of presence is not an application, and it's status-page granularity leaking through the register. **No code written, deliberately.** They're there because someone ticked those services in the Cloudflare registration; `tracked_services` already controls it, so the fix is to untrack them, not to add a filter. A filter would have to recognise them by name — exactly the name-based reasoning this sprint's design got wrong twice. Untick them on staging and they retire on the ordinary lifecycle.

    Also fixed the confusion the task called out: Estate rows now carry an **External** badge from `operated_by` (already filterable, already returned on the read — just never rendered), and the Business Applications page states plainly that it lists the asserted ones and points at the Estate for the rest.
assignee: steve
label:
- chore
priority: high
task_status: done
tech: null
---
**Do this first.** The `application` table has ZERO rows today, so this is a type/table rename with no data migration and no entity re-typing. It stops being free the moment anyone confirms a proposal.

- Entity type `application` (asserted layer) → `business-application`; `application` table → `business_application`
- API `/api/v1/applications` → `/api/v1/business-applications`; regenerate OpenAPI + api-types
- Frontend route, nav entry (`components/nav.ts`), page + tests
- `_NON_MEMBER_TYPES` → `("business-application", "business-service", "group")`

**The 92 discovered `application` entities keep their type** — they are genuinely applications: Cloudflare 30, Twilio 17, Claude 5, GitHub 5, M365 service health 35. None are Azure App Services.

**Fix the confusion this caused.** Estate shows 92 "Applications" while the Applications page shows zero, with nothing on screen distinguishing them — that is why they were unrecognisable. Show the operator on the Estate row (0073 §5: "external-ness is an attribute — who operates it — not a type"), and have the Business Applications page state plainly that it lists asserted ones.

Also decide: do the 30 Cloudflare **edge locations** ("Cloudflare — Ashburn, VA (IAD)") belong in the estate at all? They are points of presence, not applications — status-page granularity leaking through the register.
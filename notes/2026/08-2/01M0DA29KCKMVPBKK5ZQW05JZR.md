---
id: 01M0DA29KCKMVPBKK5ZQW05JZR
created: 2026-08-19T15:26:03.884818Z
updated: 2026-08-19T15:26:03.884818Z
type: task
title: Engagements gain a title — column, backfill and the amendment path
label: feature
priority: medium
assignee: steve
task_status: todo
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 286
---
Engagements have no name. Every surface that has to identify one labels it by `scope` — a paragraph of prose describing what the vendor does for us (ADR 0039 §5), which is the unit the approval criteria judge, not a label. Give the engagement a title and let scope go back to being scope.

Backend only; the four forms that collect it and the surfaces that display it follow in the next tasks.

- [ ] **`vendor_engagements.title`** — `Text`, NOT NULL. Sits alongside `scope`, which is unchanged.
- [ ] **Migration 0080** (head is 0079): add nullable → backfill every existing row from the first line of its `scope`, truncated to 80 characters → set NOT NULL. Backfilling rather than defaulting empty is the COM-219 / migration 0058 precedent: nothing renders blank on upgrade, and no existing engagement changes what it appears to be.
- [ ] **`vendor_onboarding_requests.proposed_title`** — `Text`, nullable, in the same migration. A title is proposable like any other engagement field; null still means "unchanged" (ADR 0040 §5).
- [ ] **Overlay and application**: `proposed_title` joins the projected engagement the approval rules see and is applied on approval. **No approval rule judges the title** — the criteria (`min_sensitivity`, `min_criticality`, data types) are untouched, and it should stay that way: a rename must not re-trigger an approval area.
- [ ] **Schemas**: `title` on engagement create / update / out, required on create; `proposed_title` on the amendment request schema and on the request out payload.
- [ ] The **new-vendor** and **new-engagement** paths write the title straight onto the engagement they create — `vendor_onboarding_requests.engagement_id` is NOT NULL, so the engagement exists at submission and only amendments need the proposed column.
- [ ] OpenAPI regenerated → `schema.d.ts`, no drift (the push-to-main backstop checks it).
- [ ] Tests: the backfill leaves no null and no empty title; create rejects a missing title; an amendment proposing a title applies it on approval and leaves it alone when null; a title-only amendment requires no new approval areas.
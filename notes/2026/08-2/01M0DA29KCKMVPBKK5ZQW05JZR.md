---
id: 01M0DA29KCKMVPBKK5ZQW05JZR
created: 2026-08-19T15:26:03.884818Z
updated: 2026-08-20T13:49:43.335286Z
type: task
title: Engagements gain a title — column, backfill and the amendment path
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 286
sprint: sbph5q5
comments:
- id: 01M0DTSK1EG7ZFVRQ3KQEF48HZ
  author: Steve Vine
  at: 2026-08-19T20:18:24.430356Z
  text: |-
    Shipped in PR #284, merged to main as 931cf02.

    `vendor_engagements.title` (Text, NOT NULL) and `vendor_onboarding_requests.proposed_title` (nullable — null still means "unchanged").

    **Migration is 0083, not 0080.** The task was written against head 0079; the recert work (COM-281…284) landed 0080–0082 in between, so this took the next free number. Added nullable → backfilled from the first line of each scope, trimmed and capped at 80 characters → set NOT NULL, per the COM-219 / migration 0058 precedent. The backfill carries a COALESCE/NULLIF floor for a whitespace-only scope: that is the one row a bare LEFT(...) would backfill empty, and the NOT NULL could not catch it.

    `title` joined `_PROPOSABLE` and `ProjectedEngagement` so an approved rename lands. No rule kind reads it, so a rename triggers no approval area — covered by a test rather than a comment. Schemas: required on `VendorEngagementCreate` / `VendorOnboardingEngagementIn`, optional on the update and amendment schemas, present on `Out` and on `VendorEngagementSummaryOut` (the portal register sub-rows). The two explicit constructions — `vendor_reads.engagement_out()` and the onboarding `detail()` rebuild — carry it.

    Frontend note: the four forms did not ask for a title yet, so this PR bridged them through a `titleFromScope()` helper using the identical first-line-capped-at-80 rule, keeping the tree compiling. COM-287 deleted it.

    Tests: the backfill over plain / multi-line / 120-character / whitespace-only scopes; create rejects a missing and a blank title; an amendment applies a proposed title and leaves it alone when null; a title-only amendment requires no new approval area. Full backend suite green (554 integration tests).
assignee: steve
label:
- feature
priority: medium
task_status: done
---
Engagements have no name. Every surface that has to identify one labels it by `scope` — a paragraph of prose describing what the vendor does for us (ADR 0039 §5), which is the unit the approval criteria judge, not a label. Give the engagement a title and let scope go back to being scope.

Backend only; the forms that collect it and the surfaces that display it follow in the next tasks.

- [ ] **`vendor_engagements.title`** — `Text`, NOT NULL, alongside `scope` (unchanged). No revision mirror needed — there is no engagement snapshot table (`vendor_revisions` covers the vendor only).
- [ ] **Migration 0080** (head is 0079): add nullable → backfill every existing row from the first line of its `scope`, truncated to 80 characters → set NOT NULL. Backfilling rather than defaulting empty is the COM-219 / migration 0058 precedent: nothing renders blank on upgrade, and no existing engagement changes what it appears to be.
- [ ] **`vendor_onboarding_requests.proposed_title`** — `Text`, nullable, same migration. Fields there are typed columns, not JSON, so this is one more column beside `proposed_scope`. Null still means "unchanged" (ADR 0040 §5).
- [ ] **`core/vendor_approval.py`** — add the pair to `_PROPOSABLE` and the field to `ProjectedEngagement`; that tuple drives both `projected_engagement()` and `apply_amendment()`, and its comment already says to extend it whenever the engagement gains a field.
- [ ] **No approval rule judges the title.** `min_sensitivity`, `min_criticality` and the data-type criteria are untouched — a rename must not re-trigger an approval area. Worth a test rather than a comment.
- [ ] **Schemas** (`api/v1/schemas.py`): `title` on `VendorEngagementCreate` (required) / `Update` / `Out`, on `VendorOnboardingEngagementIn`, and on **`VendorEngagementSummaryOut`** — the portal register sub-rows read that one. `proposed_title` on `VendorEngagementAmendmentIn`.
- [ ] **The two explicit constructions**, which a splat won't carry: `core/vendor_reads.py` `engagement_out()`, and `api/v1/vendor_onboarding.py` `detail()`, which rebuilds `VendorEngagementAmendmentIn` from the `proposed_*` columns field by field. The engagement create/update routes splat `model_dump()` and need no change.
- [ ] The **new-vendor** and **new-engagement** paths write the title straight onto the engagement they create — `vendor_onboarding_requests.engagement_id` is NOT NULL, so the engagement exists at submission and only amendments need the proposed column.
- [ ] OpenAPI regenerated → `schema.d.ts`, no drift (the push-to-main backstop checks it).
- [ ] Tests: the backfill leaves no null and no empty title; create rejects a missing title; an amendment proposing a title applies it on approval and leaves it alone when null; a title-only amendment requires no new approval areas.
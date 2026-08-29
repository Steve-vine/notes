---
id: 01M1702RR7CD377NNJECTP64YR
created: 2026-08-29T14:51:48.871305Z
updated: 2026-08-29T19:05:27.530343Z
type: task
title: Admins can add and remove risk appetite categories
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 516
sprint: s2fcksg
blocked_by:
- 01M16ZSV0QE99PYNPBGER8B1DS
comments:
- id: 01M17EK220PMAVQESM5KNFF0FV
  author: Steve Vine
  at: 2026-08-29T19:05:22.752159Z
  text: |-
    Done — PR #522, merged to main as bf7ac8f.

    POST and DELETE on /risk-rubric/appetite, following the content_types precedent, plus Add category and per-row Remove on Admin ▸ Rubrics.

    The re-seed trap is handled and both halves are now pinned in the code:
    - the seed importer's existence check stays deliberately unfiltered by deleted_at, with a comment saying not to tidy a filter into it;
    - every appetite read used for scoring (risks.py, risk_treatments.py, GET /appetite) excludes soft-deleted rows, or a removed category would keep scoring risks.

    test_a_removed_category_survives_the_next_deploy deletes a category, re-runs the importer, and asserts it stays gone — which is the test that would have caught this going wrong in production rather than on the next release.

    Rules as specified: default can never be removed (refused, and the button is disabled rather than hidden so the reason is findable); a category in use is refused with its count; the admin types a display name and the server slugs it.

    One thing the ticket left open that needed deciding: a removed category can be added back. The unique index spans removed rows, so a naive collision check would have made a deletion permanent — an admin who removed one by mistake could never restore it. A soft-deleted row is revived instead.

    Two decisions worth recording:

    No revision row on delete. Creation writes revision 1 so the history is not empty. Deletion does not: a revision snapshots what the threshold *was*, and a removal does not change the threshold — duplicating the last row would misrepresent it. risk_appetites is already in _AUDITED_TABLES and _was_soft_deleted maps deleted_at null→set to ActivityAction.deleted, so the removal is recorded with its actor for free (ADR 0023). Adding an action column to the revisions table just for this seemed the wrong trade.

    The error envelope. The API returns {error: {type, message, detail}}, so the count in a 409 is nested. The pattern used elsewhere in Admin reads a top-level `detail`, finds nothing, and falls back to a generic line — which would have thrown away the informative half of every refusal here. This screen reads the envelope properly, with a test pinning it. Worth knowing that the same accessor appears in DataRubricSection; not touched here, it is a separate change with its own testing.

    Migration applied and reversed against a real incrementally-migrated database, not just a fresh one.

    Ready for smoke test on staging.
assignee: steve
company: null
label:
- feature
priority: medium
task_status: review
---
Today the risk appetite categories are fixed. `api/v1/risk_rubric.py:176-231` exposes only `GET /appetite`, `PATCH /appetite/{category}` and the revisions endpoint — no create, no delete. The admin screen (`admin/RiskRubricSection.tsx:331-359`) edits `max_residual_score` and `statement` on rows that already exist. A new category can only arrive through a change to `seed/risk_rubric.py` and a redeploy, which is how **AI** appeared unannounced (COM-482).

Make the taxonomy admin-owned: add a category, remove one.

## Follow the content-types pattern

`content_types` is the precedent — a **seeded** taxonomy that is also admin-creatable and deletable. `api/v1/content_types.py:162-182`:

```python
in_use = db.scalar(select(ContentItem.id).where(ContentItem.type_id == ctype.id, ...).limit(1))
if in_use is not None:
    raise APIError("Content type is in use — disable it instead of deleting",
                   status_code=409, error_type="conflict")
ctype.deleted_at = datetime.now(UTC)
```

Two things it gets right that this needs for the same reasons:

**Refuse to delete a category in use.** `Risk.category` is free text with **no foreign key** (`models/risk.py:56-58`) and `core/risk_scoring.py:31-40` silently falls back to the `default` appetite for anything it doesn't recognise. So a hard delete doesn't error — it quietly re-judges every risk in that category against a different tolerance, with nothing on screen to say so. The delete must count risks holding that category and refuse with a 409 naming the number.

**Soft-delete, don't hard-delete.** `risk_appetites` has no `SoftDeleteMixin` today, so this needs a migration adding `deleted_at`. It matters beyond the usual reasons — see below.

## The re-seed trap

`import_risk_rubric` (`seed/risk_rubric.py:81-84`) is *"idempotent and non-destructive"* — **insert any missing row**. The Helm post-upgrade job runs it on **every deploy**. So a hard-deleted seeded category (`security`, `financial`, `ai` …) comes straight back on the next release, and the admin's deletion silently undoes itself.

A soft delete fixes this for free: the row still exists, so insert-if-absent skips it. Two things to confirm while building:

- the importer's existence check must look at **all** rows, soft-deleted included, or it will resurrect them anyway;
- `appetite_for()` and `GET /appetite` must **exclude** soft-deleted rows, or a deleted category keeps scoring risks.

## Rules

- **`default` can never be deleted** — `appetite_for()` falls back to it, so removing it breaks scoring for every unrecognised category. Refuse with a clear message, don't just hide the button.
- Creating a category takes the name, a max residual score and an optional statement — the same fields `PATCH` already accepts. `category` is `String(64)`, unique and indexed.
- Slug vs label: values are lowercase slugs today (`ai`, `reputational`). Decide whether the admin types a display name that gets slugged, or types the slug directly. Slugging is friendlier and keeps `AI` displaying correctly, but needs a collision check against soft-deleted rows too.
- Category changes are already revisioned (`GET /appetite/{category}/revisions`) — creation and deletion should land in that history rather than appearing from nowhere.

## Depends on [[COM-514]]

The raise-a-risk dropdown is a hardcoded list. Until that is data-driven, an admin can create a category that nobody can then select — the feature would be inert. COM-514 first.

## Verify
Create a category, raise a risk against it, confirm it scores against its own tolerance. Delete an unused category — gone, and still gone after a redeploy. Attempt to delete one holding risks — refused, with the count. Attempt to delete `default` — refused.

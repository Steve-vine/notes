---
id: 01M0AE656MS3Z78GGQQM8BKJ17
created: 2026-08-18T12:40:21.460909Z
updated: 2026-08-25T18:43:20.766416Z
type: task
title: Amend-and-validate never patches the existing object — adopt-by-name swallows the correction
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 246
order: 2.0
sprint: s5gwx0s
comments:
- id: 01M0BDH9W40XGQX5ER03V4CDNF
  author: Steve Vine
  at: 2026-08-18T21:48:12.548136Z
  text: |-
    Fixed and merged to main (PR #255, CI green).

    The executor now branches on amends_request_id for joiner/group_create: the target object is resolved from the original request's ledger (group_created/user_created rows; joiner falls back to the original subject's directory_user_id) and PATCHed in place — only the fields that actually differ. New ledger kinds user_updated/group_updated (migration 0071). The mirror row carries the correction immediately, and a no-change amendment reports "already matches — nothing to change" instead of implying a write happened. Mover/leaver amendments keep their state-diff semantics, which were already correct.

    Both reproduction shapes are now regression tests: same-name description amendment (PATCH + ledger row asserted on the fake tenant), rename amendment (renames the original, asserts exactly one group — no duplicate), and the joiner display-name amendment. Batch amendments match subjects by UPN/group name; a single-subject original is unambiguous even when the matching key is the field being fixed; genuinely ambiguous matches fail the subject with a clear message rather than guessing.

    Deploys to staging with the sprint batch.
assignee: steve
company: null
label:
- bug
priority: high
task_status: done
---
Smoke finding, Sprint 34 (2026-08-18). Reproduced twice on staging (requests bd693148→e2569fed and 756ac6d7→936e9e7f).

An expedited `group_create` was amended-and-validated with a corrected **description** (same name). `_execute_group_create`'s idempotency lookup (`GET /groups?$filter=displayName eq '<name>'`) found the group the original created, **adopted it as already-applied and never PATCHed it** — subject `applied`, amendment `executed`, original `amended`, zero tenant-side writes (ledger confirms: no change rows for the amendments). The validator believes their correction landed; it didn't. Adopt-by-name is correct for at-least-once *creation* but wrong for *amendment* semantics — and the inverse hurts too: an amendment changing the **name** would create a second group instead of renaming, and a joiner amendment correcting a display name no-ops the same way (adopt-by-UPN, no patch).

Proposed fix in `tasks/access_execute.py`:
- When `request.amends_request_id` is set, resolve the **target object from the original request's ledger** (`access_changes` row: `group_created`/`user_created` → object id) and **PATCH** it (displayName/description; joiner display fields) instead of create-or-adopt; mirror the change immediately; write a new ledger `change_kind` (e.g. `group_updated` / `user_updated` — enum + migration).
- Where nothing actually changed, the outcome must say so ("already matches — nothing to change"), never imply the correction applied.
- Tests: amendment-changes-description → PATCH asserted on the fake tenant + ledger row; amendment-changes-name → rename not duplicate; joiner display-name amendment.

This undermines the §6 "two humans have seen the end state" guarantee, hence high priority.

Refs: ADR 0045 §6; `_execute_group_create` / `_execute_joiner`; `amend_request` in `api/v1/access_requests.py`.
---
id: 01M101XTAR3PD4WDR95CGCMD3N
created: 2026-08-26T22:09:22.776267Z
updated: 2026-09-01T13:55:51.903571Z
type: task
title: Every membership remembers where it came from — provenance, and 1,500 users who start unattributed
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 447
sprint: snq23hz
comments:
- id: 01M12NSRBC7DT0Z3A5KXZQPWT8
  author: Steve Vine
  at: 2026-08-27T22:35:10.059915Z
  text: |-
    Done — merged to main as 47a5885 (PR #463). Full CI green.

    Compass now records **why** each membership exists. Nothing on screen yet.

    **The record.** `governed_memberships`, one row per (principal, group) — a membership is one fact and it has one reason, so it is tenant-wide like the mirror it describes rather than duplicated per company. Carries `role_derived | exception | unattributed`, its source (`business_role_id` or `request_id`), and `attributed_at` — when the *reason* was recorded, since the mirror cannot know when the membership began. `company_id` is denormalised from the source and is NULL exactly when unattributed, because no company's governance has claimed it (the `unrequested_changes` NULL-means-tenant-wide idiom). `principal_id` has no FK, for the reason `DirectoryRoleAssignment.principal_id` has none: the holder is a mirrored user *or* a mirrored group, so there is no one table to point at. Audited.

    **Unattributed and exception stay firmly apart**, per the ADR — the values are distinct in the enum and nothing collapses them.

    **Two writers, one module** (`core/membership_provenance.py`) rather than each keeping its own opinion. The sync reconciles on both the full and delta passes: anything the mirror holds and the record does not becomes unattributed; a record whose membership has gone is deleted. Execution stamps at the point of the write — `_grant_role_derived` / `_revoke_membership` replaced the bare adds and removes at the joiner, mover, joiner-amendment, leaver and both recert-removal call sites.

    One thing that had to change to make attribution possible: `_active_role_group_ids` returned a *union* of group ids, which cannot say which role explains a given group. It is replaced by `role_group_map` (group → the role granting it), attributing a multiply-mapped group to the lowest role id so a re-run does not flip the record between two equally true answers.

    **The number.** `GET /api/v1/directory/membership-coverage?company=<id>` → explained / unattributed / total / percent. `explained` is the company's; `unattributed` is the tenant's shared backlog. COM-454 puts it on the dashboard.

    **No backfill.** Migration 0128 is additive and lands the table empty; the first sync fills it, everything unattributed. Expect a large unattributed count and 0% coverage on the first pass after deploy — both correct.

    Tests went into the existing fake-tenant harnesses rather than a third one: sync side in `test_directory_sync.py` (first sync attributes nothing; devices and contacts get no rows since they are not principals; a resync creates nothing and does not churn `attributed_at`; a vanished membership takes its record), execution and endpoint in `test_access_requests.py`.
assignee: steve
label:
- feature
priority: high
task_status: done
---
The keystone of COM-446, and the first thing built — everything else in the sprint is unsafe without it.

Compass reads membership from live Entra state, which cannot tell someone in Finance Approvers *because they are an Accounts Payable Clerk* from someone in Finance Approvers *because somebody asked in March*. Both are just membership. Build exceptions before provenance exists and the first mover to run silently deletes every exception ever granted.

## What changes

Nothing on screen yet. Compass gains a record of **why** each governed membership exists.

## Scope

**Three provenance values, and the third matters as much as the other two:**

- **role-derived** — the person holds a business role that grants this group
- **exception** — approved through a request, with the requester, approver and reason attached
- **unattributed** — true before Compass governed it, and nobody has yet said why

Keep unattributed and exception firmly apart. An exception was decided; unattributed was inherited. Collapse them and you lose the ability to tell access somebody reviewed from access nobody has ever looked at — which is the whole point of the record.

**Where it lives.** A membership fact per (directory user or group, directory group) that Compass governs, carrying its provenance, its source (which business role, or which request), and when it was attributed. Existing patterns: company-scoped, audited, ADR 0015 mixins.

**Reconciliation on sync.** The mirror is the truth about *what* the memberships are; this record is the truth about *why*. A membership that appears in the mirror with no record becomes **unattributed** — that is the backfill and the steady state, not a special case. A membership that disappears takes its record with it.

**Execution writes provenance.** Every `_add_member` in `tasks/access_execute.py` already knows why it is adding — a joiner's roles, a mover's new role set, a recert removal. Stamp it at the point of the write rather than inferring it afterwards.

**The number.** A count of explained vs unattributed membership, per company. It is the metric that makes anyone finish the migration and the thing an auditor wants to see moving. Expose it on the API here; COM-454 (the coverage tool) puts it on the dashboard.

## The migration

No backfill script that guesses. Every existing membership lands as **unattributed** on the first sync after deploy, and that is the correct answer — 1,500 users with no history is the honest launch state, drained later by the coverage tool and recertification.

## Tests

Integration tests against real Postgres: a membership gains a record on first sync as unattributed; an executed joiner writes role-derived; a membership vanishing from the mirror takes its record; a re-run of the sync creates nothing new. Plus the count endpoint over a mixed set.
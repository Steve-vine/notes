---
id: 01M14W593XNB6MF34DCTT2F9QM
created: 2026-08-28T19:04:47.997635Z
updated: 2026-08-29T09:38:29.237058Z
type: task
title: Mirror the facts the standard reports need
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 492
sprint: s42ntc9
comments:
- id: 01M16E51QNJ12DC8FX0TRQB9E0
  author: Steve Vine
  at: 2026-08-29T09:38:29.236899Z
  text: |-
    Done — PR #496 (branch feature/com-492-mirror-report-facts), migration 0143_mirror_report_facts.

    What landed:

    - **directory_users** gains job_title, department, employee_id, on_premises_sync_enabled, assigned_license_skus, password_policies, last_password_change, external_user_state, plus last_sign_in / last_non_interactive_sign_in / sign_in_observed_at.
    - **directory_devices** gains device_ownership (company/personal/unknown enum) and management_type.
    - **directory_groups** gains visibility (public/private/hidden_membership), expiration_datetime, renewed_datetime.

    Absent-is-not-false is enforced structurally, not by convention: every column nullable with no server default; a delta object that *omits* a key leaves that column alone while a key present and null clears it (otherwise one display-name delta would wipe every job title in the mirror). password_policies turned out to need three states rather than two — Graph reports "default policy, password expires" as a JSON null, which is a positive answer — so it stores "" for read-and-empty and keeps null for never-read.

    Sign-in activity is a separate hourly sweep (tasks/sign_in_sweep.py) as the task called for. sign_in_observed_at is stamped on every account the sweep reads whether or not Graph had a sign-in, which is what keeps "never signed in" apart from "not yet read". A 403 is recorded on the status singleton with its reason (the role_eligibility_available shape); a 500 deliberately is not, because an outage is not a missing licence.

    One thing the task did not anticipate: a stored deltaLink carries the $select it was minted with, so widening the select in code would have changed nothing until the nightly backstop happened to run — the new columns would have sat null for up to a day while the delta pass reported success. Added mirror_select_version on the status singleton, which forces exactly one full pass on a bump; there is a test asserting *exactly* one.

    Also in the PR: GraphError gains graph_status (what Graph replied, as against http_status, which is what our API should return) so the sweep can tell a permanent refusal from a blip; parse_graph_datetime moves to core/graph.py now two task modules need it.

    No API surface and no UI — these are catalogue fields, and the catalogue is COM-487. OpenAPI drift check is clean.

    **Needs confirming on the tenant:** the sign-in columns require Entra ID P1. The code degrades visibly without it (the status row says unavailable, and no account is stamped, so nothing reads as dormant) rather than reporting an empty directory — but if the licence is not there, Inactive users ships showing "unavailable".
assignee: steve
company: null
label:
- feature
priority: high
task_status: active
---
Discovery finding, 2026-08-28. The mirror holds seven facts about a person — display name, UPN, mail, enabled, type, created, vanished — and that is the binding constraint on the report library. Groups and devices are better covered but each has a governance field missing.

Everything below is a field on data the sync **already fetches every 15 minutes**: one line in the relevant `$select`, one column, one catalogue entry. No new permission, no new call, with the single exception noted at the end.

**`DirectoryUser`**

- **`last_sign_in`** and **`last_non_interactive_sign_in`**, from Graph `signInActivity` — the blocker on *Inactive users*. Needs `AuditLog.Read.All`, which the app already requests (`core/graph.py`), and Entra ID P1 on the tenant: confirm the licence before starting.
- **`on_premises_sync_enabled`**. We mirror this for *groups* and not for people, so Compass cannot tell a cloud account it can disable from a synced one it cannot. A leaver that silently no-ops is the worst failure in the module.
- **`job_title`**, **`department`**, **`employee_id`** — what lets any report be scoped to a part of the business.
- **`assigned_licenses`** — *enabled but unlicensed*, and dormant accounts still being paid for. Store the SKU ids; resolving them to names is a later nicety, not a blocker.
- **`password_policies`** (does the password expire?) and **`last_password_change`** — *accounts whose password never expires* is the classic finding, and today it is invisible.
- **`external_user_state`** — we know who is a guest, not which invitations were never accepted. Stale invitations are a standing access-review item.

**`DirectoryDevice`**

- **`device_ownership`** (company or personal) and **`management_type`** — BYOD exposure. We hold managed/compliant and cannot separate a corporate laptop from someone's phone.

**`DirectoryGroup`**

- **`visibility`** (public or private) — public groups holding data.
- **`expiration_datetime`** and **`renewed_datetime`** — groups past their lifecycle date.

**The one wrinkle: `signInActivity` is not returned by `/users/delta`.** It cannot ride the existing delta pass, so it needs a separate periodic sweep over `/users` — hourly is plenty for a field measured in days. Give it its own task rather than bolting a full pass onto the delta path, which ADR 0045 §3 deliberately made cheap. Everything else on this list rides the existing passes.

A user whose sign-in has never been observed must report as **never signed in**, distinct from **not yet synced** — an inactive-users report that quietly counts unsynced accounts as dormant is worse than no report. The same rule applies to every field here: absent is not the same as false, and the catalogue must be able to say so.
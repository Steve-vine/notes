---
id: 01M14W593XNB6MF34DCTT2F9QM
created: 2026-08-28T19:04:47.997635Z
updated: 2026-08-29T09:25:36.069893Z
type: task
title: Mirror the facts the standard reports need
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 492
sprint: s42ntc9
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
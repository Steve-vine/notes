---
id: 01M14W593XNB6MF34DCTT2F9QM
created: 2026-08-28T19:04:47.997635Z
updated: 2026-08-28T19:05:58.011186Z
type: task
title: Mirror the user facts the standard reports need
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 492
sprint: s42ntc9
assignee: steve
company: null
label:
- feature
priority: high
task_status: todo
---
Discovery finding, 2026-08-28. The mirror holds seven facts about a user — display name, UPN, mail, enabled, type, created, vanished — and three of the four standard reports fall out of what is already there. **Inactive users does not**: we mirror when a *device* last signed in and never when a *person* did.

Add to `DirectoryUser`:

- **`last_sign_in`** and **`last_non_interactive_sign_in`**, from Graph `signInActivity`. Needs `AuditLog.Read.All`, which the app already requests (`core/graph.py`), and Entra ID P1 on the tenant — confirm the licence before starting.
- **`on_premises_sync_enabled`**. We mirror this for *groups* and not for users, which means Compass cannot tell a cloud account it can disable from a synced one it cannot. A leaver that silently no-ops is the worst failure in the module.
- **`job_title`**, **`department`**, **`employee_id`** — the fields that let a report be scoped to a part of the business, and the ones every governance reader asks for second.

**`signInActivity` is not returned by `/users/delta`.** It cannot ride the existing delta pass, so it needs a separate periodic sweep over `/users` — hourly is plenty for a field measured in days. Design it as its own task rather than bolting a full pass onto the delta path, which ADR 0045 §3 deliberately made cheap.

Users whose sign-in has never been observed must report as *never signed in*, distinct from *no data yet* — an inactive-users report that quietly counts unsynced accounts as dormant is worse than no report.
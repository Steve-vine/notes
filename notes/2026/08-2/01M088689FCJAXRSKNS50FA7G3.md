---
id: 01M088689FCJAXRSKNS50FA7G3
created: 2026-08-17T16:17:04.303307Z
updated: 2026-08-17T19:57:32.359119Z
type: task
title: JML backend — requests, maker-checker approval, Graph execution
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 239
sprint: s5gwx0s
blocked_by:
- 01M0885ZWABQ8TF6MGZAJGSF20
assignee: steve
label:
- feature
priority: medium
task_status: active
---
Full-lifecycle JML (sprint decision) with **no Graph write outside this path**.

* **Request entity**: company-scoped, `kind = joiner | mover | leaver | group_create`, **`approval_mode = standard | expedited`**. Standard lifecycle `draft → pending_approval → approved → executing → executed | failed` (+ `rejected`, `cancelled`); expedited lifecycle `submitted → executing → executed → pending_validation → validated | amended` — one module-level transitions map covering both, enforced in the router (ADR 0039 §2 — no engine). **Batch-aware**: a request holds one-or-many subjects (users are provisioned in batches — sprint decision), each subject carrying its own per-item execution outcome so one failure doesn't poison the batch.
* **Maker-checker, two orderings**: standard — approver must differ from requester, enforced server-side, approval recorded (who/when). Expedited (2026-08-17 amendment) — requester = approver = executor, recorded explicitly on the request; submission executes immediately (role-gated to `access_engineer`); a **validator ≠ requester** must then validate or amend-and-validate within the SLA (default 5 business days; overdue via the reminders engine). An amendment is a linked corrective request executing through this same path; validating closes the pair. This is the blast-radius control from ADR 0045 — and evidence for CIS 6 / ISO A.5.18 either way: pre-approval or documented retrospective review.
* **Execution**: idempotent Celery task taking the request id (IDs not objects, JSON only, at-least-once safe — re-running skips already-applied subjects by checking current directory state first). Per kind:
  * **Joiner** — Graph create user (UPN/display name/usage location), generated temp password + `forceChangePasswordNextSignIn`, then group adds resolved from the assigned business role(s). The temp passwords are returned as a **one-time password list** on the execution result: held encrypted, viewable exactly once, then destroyed — never logged (redaction list), never re-readable.
  * **Mover** — diff current memberships vs the new role set; apply adds/removes to **managed** (matrix-mapped) groups only; unmanaged memberships untouched, listed for information.
  * **Leaver** — `accountEnabled = false`, `revokeSignInSessions`, remove all managed-group memberships. No delete — disabled accounts are the recoverable, auditable end state.
  * **Group create** — Graph create security group (name, description, owners); optionally attach to a business role in the matrix on creation. Available in both approval modes — incident-time work creates groups too.
* Requests join `_AUDITED_TABLES`; execution also writes explicit per-subject result rows (what changed in the tenant, when, under which approval or validation) — the tenant-side evidence the activity log can't carry. Expedited requests and their validation records are first-class in that trail, and the expedited:standard ratio is derivable from it.

Refs: ADR 0045, 0006, 0023; `core/graph.py`, `core/vendor_approval.py` (approval-shape prior art), `tasks/reminders.py`.
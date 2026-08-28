---
id: 01M1539868BE8QNCSYNQJYXNGF
created: 2026-08-28T21:09:18.152976Z
updated: 2026-08-28T21:10:19.500385Z
type: task
title: Mirror applications and service principals
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 498
sprint: s5cyp1z
assignee: steve
company: null
label:
- feature
priority: medium
task_status: todo
---
The non-human half of the tenant, which Compass currently cannot see at all.

Two related objects, and the distinction matters — an **application** is the registration (owned here, defines the app), a **service principal** is the identity in this tenant (may be someone else's application, consented into ours). Governance questions land on both, and a mirror that merges them cannot answer either.

Mirror, on the existing sync's cadence:

- **Applications**: app id, display name, sign-in audience (single tenant, or *any Microsoft account*), created, owners, and the **password and certificate credentials** with their start and expiry.
- **Service principals**: app id, display name, whether it is ours or a gallery/third-party app, enabled, whether it is a managed identity, owners, and its own credentials and expiries.

Needs **`Application.Read.All`** — a new application permission. It needs admin consent, and a new grant does not reach the worker until it restarts (the health card goes green before the token does).

**This closes a gap the mirror already admits to.** `DirectoryRoleAssignment` records a principal type of `other` precisely because a directory role can be held by a service principal the mirror does not carry — so *who holds Global Administrator* can currently be counted but not fully named. Once service principals are mirrored, resolve those holders and let the role screens name them.

Vanished handling follows the existing mirror rule: marked, never deleted, so old report runs keep resolving.
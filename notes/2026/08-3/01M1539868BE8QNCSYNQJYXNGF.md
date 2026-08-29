---
id: 01M1539868BE8QNCSYNQJYXNGF
created: 2026-08-28T21:09:18.152976Z
updated: 2026-08-29T17:03:34.214301Z
type: task
title: Mirror applications and service principals
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 498
sprint: s5cyp1z
comments:
- id: 01M16X7TX169Z4HNS3V8ZH7X79
  author: Steve Vine
  at: 2026-08-29T14:02:09.185137Z
  text: |-
    Done — PR #507, merged to main (de1f31e).

    Two tables, not one. Applications (the registration) and service principals (the identity in this tenant) are mirrored separately, with their owners and their password/certificate credentials and expiry dates on either kind. Both reads ride the existing 15-minute sync, read in full on the delta pass as well as the full crawl — applications are counted in hundreds where users are counted in thousands, so a complete read is a handful of requests and there is no second delta dialect to keep right.

    Objects are marked when they leave the tenant and never deleted, so an old report run still resolves the name it printed. Credentials and owners are current-state facts and go when they go — a secret somebody rotated away would otherwise sit in "expired credentials still in place" for ever. An owner the mirror cannot recognise is kept and counted rather than dropped, because dropping it would turn an owned application into an "applications with no owner" finding.

    Nothing is stored as a verdict: expiry is a date the catalogue counts from, "is it ours" is left unknown when Graph did not say rather than guessed, and an object with no credentials has no rows at all — which is what lets "no expiry" be told from "no credential".

    This closes the gap the mirror already admitted to. A directory role held by a service principal could be counted but not named. It now has a name and a type of its own: the role page lists the applications holding the role and says whether each is ours or a third party's, and the access graph draws it by name instead of a hex string. "Unresolved" survives and now means what it says.

    **Needs a new admin consent before it does anything on staging.** `Application.Read.All` on the compass-access app registration (Azure portal → App registrations → API permissions → Microsoft Graph → Application). Until it is granted the applications library is empty and the Integrations card says so — deliberately, because an empty library and a tenant with no applications look identical. Note the grant does not reach the worker until it restarts, so the health card goes green before the data arrives. Setup instructions updated in `scripts/entra/README.md`.

    Smoke test: Access Control → Directory Roles → a role held by an application, once the grant is in place.
assignee: steve
company: null
label:
- feature
priority: medium
task_status: done
---
The non-human half of the tenant, which Compass currently cannot see at all.

Two related objects, and the distinction matters — an **application** is the registration (owned here, defines the app), a **service principal** is the identity in this tenant (may be someone else's application, consented into ours). Governance questions land on both, and a mirror that merges them cannot answer either.

Mirror, on the existing sync's cadence:

- **Applications**: app id, display name, sign-in audience (single tenant, or *any Microsoft account*), created, owners, and the **password and certificate credentials** with their start and expiry.
- **Service principals**: app id, display name, whether it is ours or a gallery/third-party app, enabled, whether it is a managed identity, owners, and its own credentials and expiries.

Needs **`Application.Read.All`** — a new application permission. It needs admin consent, and a new grant does not reach the worker until it restarts (the health card goes green before the token does).

**This closes a gap the mirror already admits to.** `DirectoryRoleAssignment` records a principal type of `other` precisely because a directory role can be held by a service principal the mirror does not carry — so *who holds Global Administrator* can currently be counted but not fully named. Once service principals are mirrored, resolve those holders and let the role screens name them.

Vanished handling follows the existing mirror rule: marked, never deleted, so old report runs keep resolving.
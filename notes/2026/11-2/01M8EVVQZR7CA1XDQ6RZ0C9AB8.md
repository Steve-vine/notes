---
id: 01M8EVVQZR7CA1XDQ6RZ0C9AB8
created: 2026-11-27T16:01:52.63207Z
updated: 2026-11-27T16:01:52.63207Z
type: task
title: 'Action integrations: a new kind of integration that can make changes, defined on screen. The first type is a SQL Server database'
label: feature
assignee: steve
priority: high
task_status: todo
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2194
---
**On the chain** (new tables and API). ADR 0185 (COM-2192).

## What people see
- **Admin ▸ Integrations** gets a new section, **Action integrations**: "Connections scripts use to make changes in other systems." It sits beside Collection integrations, which stay read-only.
- **Add an action integration** asks what kind it is. **This sprint has one: SQL Server database.** The screen is laid out for more kinds later (a web service such as Cloudflare's API, signed in like a Collection integration; then whatever PowerShell and Python scripts need).
- **A SQL Server database** has:
  - name and description;
  - an owner (who gets told when it stops working);
  - server address and port (default 1433);
  - database;
  - sign-in: a SQL login (user name and password) **or** a Windows account through Kerberos, as Compass already uses for AD;
  - "Encrypt the connection" (on by default) and "Trust this certificate" (a CA certificate can be pasted, as for a Collection integration).
- **The password is entered once and never shown again**, like every other integration's. Changing it means typing a new one.
- **What it can change is what the login has been granted** in that database. The screen says so plainly: "Compass can do whatever this login is allowed to do. Grant it only what your scripts need."
- **Test connection** signs in and runs nothing, reporting "Connected as compass_svc to CRM on sql01: SQL Server 2022" or the reason it couldn't.
- **Reaching it**: Compass assumes the server can be reached (at Moneypenny, Twingate does that). A private address must be on **Admin ▸ Integrations ▸ Internal addresses**, approved by an administrator, exactly as for a Collection integration. Until it is, Test connection says which address needs approving.
- **Shown with each integration**: which scripts use it, and when it was last used and tested.
- **It can't be deleted while a published script uses it.** It can be switched off, and then scripts using it fail with "The CRM database integration is switched off".
- Everything is in the activity log.

## Notes (technical)
- New model (e.g. `ActionIntegration` with `kind`, settings JSONB, `secret_encrypted` via `core/secretbox.py`). Global, not per company, unless an existing integration pattern says otherwise; check `collection_integration.py` and follow it. Rights: *Manage integrations*.
- **SQL Server driver in the worker image**: `pymssql` (FreeTDS, wheels) or `pyodbc` + `msodbcsql18` (Microsoft's apt repo). Decide in the PR; prefer what supports Kerberos with the existing gssapi/krb5 setup and TLS with a custom CA. Dockerfile change, arm64 too (see the binfmt memory).
- Reuse `core/collection/internal.py` for address approval and pinning (refuse metadata, loopback and cluster ranges).
- The ADR 0147 §9 rule: nothing names a service. The `kind` is a generic protocol ("sql_server"), not a product someone uses.
- Database queries run only on the worker (the execution queue), never in the API process.

**Done when:** on staging, an admin adds a SQL Server action integration pointing at a test database, Test connection reports the server and login, the password can't be read back, and an unapproved private address is refused with the reason.
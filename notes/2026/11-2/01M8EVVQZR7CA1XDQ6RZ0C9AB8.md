---
id: 01M8EVVQZR7CA1XDQ6RZ0C9AB8
created: 2026-11-27T16:01:52.63207Z
updated: 2026-11-28T00:23:59.104138Z
type: task
title: 'Action integrations: a new kind of integration that can make changes, defined on screen. The first type is a SQL Server database'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2194
sprint: snt3b17
blocked_by:
- 01M8EVTSMYCWN977F49XWV61RH
comments:
- id: 01M8F7SBRH2PJQRW6NKX9HADYA
  author: Steve Vine
  at: 2026-11-27T19:30:17.489628Z
  text: |-
    Built: PR #2199, merged to main as 1860e670 (not on staging yet; it goes with the sprint deploy).

    What's there:
    - Admin ▸ Integrations has a new Action tab, beside Collection and Core: connections that scripts use to make changes in other systems.
    - Add an action integration: one kind for now, SQL Server database. You give the address and port (not an instance name), the database, a SQL login and a password (entered once, never shown again). Encryption is on by default, with the certificate checked against the name you typed, and you can paste a CA certificate if needed.
    - Test connection signs in from the worker and says which login, database and server it reached: "Connected as compass_svc to CRM on SQL01: SQL Server 2022 (16.0…)". It changes nothing. When it can't connect, it says why: an unapproved private address (pointing at Internal addresses), unreachable, a wrong password, a missing database, or an untrusted or wrong-name certificate.
    - The page says plainly that "Compass can do whatever this login is allowed to do". You can switch it off or delete it. Its password appears in the Secrets register (default company).
    - Proven against a real SQL Server 2022, including encryption with a pasted CA.

    For you to look at:
    - Windows (Kerberos) sign-in isn't in. Proving it needs a SQL Server joined to a domain, and none was available. SQL logins work.
    - "Which scripts use it" and "can't be deleted while a script uses it" arrive with COM-2195.
    - For pre-UAT I'll put a small test SQL Server in staging, for the E2E Test Company only.
- id: 01M8FRK4C0QQ69P493T5ZNA2WG
  author: Steve Vine
  at: 2026-11-28T00:23:59.103904Z
  text: |-
    Pre-UAT, staging 20261127-2345 (cb5b5e49f), as E2E Admin A: **Passed.**

    1. Admin ▸ Integrations ▸ Action ▸ Add: SQL Server database "E2E test CRM database", pointing at the staging test server (sqlserver-test.compass.svc.cluster.local:1433, CRM_TEST, login compass_svc, Encrypt off because its certificate is self-signed). Saved. The page says "Compass can do whatever this login is allowed to do…" and "Not encrypted: the password and everything a script sends can be read on the network."
    2. Test connection, before approving the address → "Couldn't connect: …is a private address Compass hasn't been allowed to reach. An administrator can approve an internal address under Admin ▸ Integrations ▸ Internal addresses".
    3. Approved the address under Internal addresses, tested again → "Connected as compass_svc to CRM_TEST on sqlserver-test-…: SQL Server 2022 (16.0.4325.4)".
    4. The password can't be read back; the page shows only when it was set. It also shows the password's last four characters, the same way Collection integrations show a key's ending.

    Screenshots: ~/compass-uat/scripting/COM-2194/.
assignee: steve
label:
- feature
priority: high
task_status: review
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
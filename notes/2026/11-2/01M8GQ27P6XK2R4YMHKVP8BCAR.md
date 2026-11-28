---
id: 01M8GQ27P6XK2R4YMHKVP8BCAR
created: 2026-11-28T09:16:31.302973Z
updated: 2026-11-28T09:16:31.302973Z
type: task
title: 'Action integration of the Web/API family: a web service scripts can change things in, signed in the ways a Collection integration can be'
task_status: todo
label: feature
priority: high
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2227
---
**On the chain.** After the Scripting phase 2 ADR and the Web/API-or-Server task.

## What people see
- **Admin ▸ Integrations ▸ Action ▸ Add ▸ Web/API**: a web service's address and sign-in, set up as a Collection integration's are:
  - API key in a header (or several parts in several headers), bearer token, basic, OAuth client credentials, or app sign-in;
  - fixed headers;
  - a test request.
- It reads **Can change things**, with the same warning as a SQL one ("Compass can do whatever this key is allowed to do. Grant it only what your scripts need"), an owner, and an entry in the Secrets register. The key is entered once and never shown again.
- **Test connection** makes the test request and says what answered ("Signed in to api.cloudflare.com: 200"). It changes nothing.
- A private address must be approved under Internal addresses, as for every integration.
- Scripts that use it are the PowerShell and Python tasks: a SQL script can't. The integration lists the scripts that use it, and can't be deleted while one does.

**Done when:** on staging, an admin adds a Web/API action integration for a test API, Test connection reports it, and the key can't be read back.
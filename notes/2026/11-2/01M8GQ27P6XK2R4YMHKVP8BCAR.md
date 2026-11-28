---
id: 01M8GQ27P6XK2R4YMHKVP8BCAR
created: 2026-11-28T09:16:31.302973Z
updated: 2026-11-28T09:49:24.431612Z
type: task
title: 'Action integration of the Web/API family: a web service scripts can change things in, signed in the ways a Collection integration can be'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2227
sprint: s09wwd3
assignee: steve
label:
- feature
priority: high
task_status: todo
---
**On the chain.** After the Scripting phase 2 ADR (COM-2225) and the Web/API-or-Server task (COM-2226).

## What people see
- **Admin ▸ Integrations ▸ Action ▸ Add ▸ Web/API**: a web service's address and sign-in, set up as a Collection integration's are:
  - API key in a header (or several parts in several headers), bearer token, basic, OAuth client credentials, or app sign-in;
  - fixed headers;
  - a test request.
- It reads **Can change things**, with the same warning as a SQL one ("Compass can do whatever this key is allowed to do. Grant it only what your scripts need"), an owner, and an entry in the Secrets register. The key is entered once and never shown again.
- **Test connection** makes the test request and says what answered ("Signed in to api.cloudflare.com: 200"). It changes nothing.
- A private address must be approved under Internal addresses, as for every integration.
- **How it's used:** a PowerShell or Python script (COM-2231, COM-2232) builds an API call. **Compass sends it to this integration with its key**, so the script never sees the key, and reads the answer back. A SQL script can't use it. The integration lists the scripts that use it, and can't be deleted while one does.

**Done when:** on staging, an admin adds a Web/API action integration for a test API, Test connection reports it, the key can't be read back, and a generator script's API call to it is sent and answered.
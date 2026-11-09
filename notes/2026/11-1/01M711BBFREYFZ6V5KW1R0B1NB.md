---
id: 01M711BBFREYFZ6V5KW1R0B1NB
created: 2026-11-09T20:52:43.12852Z
updated: 2026-11-09T20:53:06.87555Z
type: task
title: 'Chat tools: add and change a Collection integration — an assistant defines a SaaS service from its docs, sets its owner and fetches its logo, under the same rules as the on-screen form'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1661
sprint: sjvqrdg
blocked_by:
- 01M711A9RCC3BXNEBD320M5PK4
assignee: steve
label:
- feature
priority: high
task_status: todo
---
Part of the change recorded in COM-1659. Today an assistant can only list Collection integrations.

## What the person can ask for

- **"Set up Cloudflare as a Collection integration."** The assistant reads Cloudflare's API docs itself and adds the service: name, what it reads (a sentence), docs link, address, sign-in method, paging, any fixed headers, test read and a logo address. It says what it's about to add before it calls the tool. The answer gives the service's page link and the steps to make the most limited read-only key, preferring one owned by the account or organisation (COM-1658). The key is entered on screen, never in chat.
- **"Change Cloudflare's test read to /zones"**, or any other field. The assistant changes only the fields asked for. If accounts exist, it runs their tests again, as saving on screen does, and reports what each test said.
- **"Make Jo the owner of the GitHub integration."** The owner gets the integration's Fix sign-in and Grant permission actions.
- **A logo:** the assistant gives an image address and Compass fetches it, as **Fetch logo** does on screen. Uploading a file stays on screen.
- **Refusals in words:** the form's own rules apply, and their messages come back as the reason. That covers an address that isn't https or isn't public, a sign-in or paging style that isn't on the list, a reserved header, a name already taken, and an Accept header that isn't JSON (COM-1640).
- **Needs Manage integrations.** Without it, the tools aren't offered, as with every tool (ADR 0109).

## Done when

- New tools sit beside `posture_list_collection_integrations`, with names chosen in the PR:
  - add a service;
  - change a service;
  - set its owner;
  - fetch its logo.
- Every write is `always_ask` and recorded in Activity as the person, via Polaris.
- The add and change tool descriptions carry the definition rules: the fixed sign-in and paging lists, GET only, https, a test read that works for every kind of key with no per-account values in it, and when Accept may be set. Wording should match COM-1658's define prompt, so the assistant and Polaris give the same answer.
- No tool takes a key or returns one or its hint.
- The list tool's description no longer says creating and changing stay on screen; it says the key does.
- The server instructions' Collection paragraph says the same.
- Tests:
  - each tool round-trips through the API in-process, the way the other chat tool tests do;
  - a refused definition comes back as the form's message;
  - the tools are hidden without Manage integrations;
  - the pinned tool-count and tool-name tests are updated.
- **Pre-UAT on staging**, through a connected assistant: add a test service (e.g. "E2E Cloudflare (test)"), change its test read, set its owner and fetch its logo. Check each change in Activity as via Polaris, then remove the service on screen.

## Notes

- **Independent:** tools only, calling the existing `/api/v1/collection-integrations` routes (create, PUT, owner, icon/fetch). No migration and no API change.
- Where: `assistant/tools/posture_collection.py` (or a new `posture_collection_admin.py` if it grows), and the server instructions text.
- Follow ADR 0143's per-area tool counts: this adds about four tools to Posture (49 today), which matters for the Copilot per-area agents (sr3v2fq).
- Builds on COM-1659. COM-1658 holds the shared test-read wording; if it lands first, reuse its text.
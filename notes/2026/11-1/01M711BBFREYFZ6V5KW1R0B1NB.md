---
id: 01M711BBFREYFZ6V5KW1R0B1NB
created: 2026-11-09T20:52:43.12852Z
updated: 2026-11-09T22:08:02.723663Z
type: task
title: 'Chat tools: add and change a Collection integration''s settings — an assistant sets up a SaaS service from its docs, fixes its settings when a test fails, sets its owner and fetches its logo'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1661
sprint: sjvqrdg
blocked_by:
- 01M711A9RCC3BXNEBD320M5PK4
comments:
- id: 01M714JXE0GR17QEDSSCVDGV0C
  author: Steve Vine
  at: 2026-11-09T21:49:16.60848Z
  text: |-
    **Done: merged to main in PR #1668.**

    **What an assistant can now do** (needs Manage integrations; Polaris asks before each one; no tool takes or shows a key or username):
    - **Set up a service:** `posture_add_collection_integration` takes its name, what it reads, address, sign-in, paging, headers, test read, docs link and, optionally, a logo address. The answer gives the link and says to add the account and its key on the integration's page.
    - **Put one right:** `posture_update_collection_integration` changes only the settings given. Every account is tested again and the answer says what each test said, so the fix is checked at once.
    - **Set the owner:** `posture_set_collection_integration_owner` takes a name or "me", from people who can manage integrations, as the screen's picker does.
    - **Fetch a logo:** `posture_fetch_collection_integration_logo`.
    - **The list** (`posture_list_collection_integrations`) now shows each service's settings, so the assistant can see what it's changing.
    - **The tool descriptions and Polaris's instructions** carry the same test-read and key rules as COM-1658, and say that accounts and keys are only added on screen and never asked for in chat.

    **Test:** the Cloudflare case end to end against real Postgres:
    - the service is set up with `/user/tokens/verify`, and the account is added on screen;
    - the test fails with "Invalid API Token (1000)";
    - the assistant changes only the test read to `/zones`, and the account signs in;
    - the form's refusals (a reserved header, a name already taken) come back in words;
    - someone without Manage integrations isn't offered the tools.

    **To look at on staging** (after the sprint's deploy): ask a connected assistant to "set up a test Collection integration", change its test read, and set you as owner. Each change should show in Activity as you, via Polaris. Your claude.ai connector may need reconnecting before it sees the new tools.
- id: 01M715N953WS38885V4XD47XW5
  author: Steve Vine
  at: 2026-11-09T22:08:02.723354Z
  text: |-
    **Pre-UAT: Passed** (staging 793eb4e7, 2026-11-09 22:05 GMT, through the staging MCP as the E2E setup administrator).

    Steps and what was seen:
    1. **Offered tools:** all five are present (add, update, set owner, fetch logo, and COM-1662's test). None is read-only.
    2. **Add:** `posture_add_collection_integration` set up "E2E GitHub check (test)" (api.github.com, bearer, test read `/user`, an API-version header, a logo address). It answered with the settings and the link, said "Add an account and its key on the integration's page", and reported "Logo fetched". On screen the GitHub logo shows.
    3. **Fix:** with the account failing ("Bad credentials"), `posture_update_collection_integration` changed only the sign-in, key header and test read. It reported `changed: key_header, sign_in, test_path`, state connected, and the account "signed in. The test read answered with: id, node_id, name, full_name…".
    4. **Refusals:** an Authorization header came back as "Extra headers: Compass sets Authorization itself". With nothing given: "Nothing to change".
    5. **Owner "me":** answered E2E setup.
    6. **Activity:** "created" and "updated" entries as E2E setup, via assistant. The update lists the before and after of sign_in, key_header and test_path, and the logo change. The owner was already E2E setup (whoever creates an integration owns it), so that call changed nothing and recorded nothing.

    Cleaned up: the service was deleted. Your claude.ai connector may need reconnecting to see the new tools.

    A small thing, not a defect: an untouched paging setting comes back with each empty field listed as null. It's noise in the assistant's answer only.
assignee: steve
label:
- feature
priority: high
task_status: review
---
Part of the change recorded in COM-1659. Today an assistant can only list Collection integrations. The accounts and their keys stay on screen; this task covers the service's settings.

## What the person can ask for

- **"Set up Cloudflare as a Collection integration."** The assistant reads Cloudflare's API docs itself and adds the service: name, what it reads (a sentence), docs link, address, sign-in method, paging, any fixed headers, test read and a logo address. It says what it's about to add before it calls the tool. The answer gives the service's page link and the steps to make the most limited read-only key, preferring one owned by the account or organisation (COM-1658). The person then adds the account and its key on screen, as they do after the wizard today.
- **"Cloudflare's test is failing — sort it out."** The assistant reads the failure (COM-1662), works out from the docs what's wrong in the settings, says what it will change, and changes only those fields. In today's case, that's the test read from `/user/tokens/verify` to `/zones`. Saving runs every account's test again, as saving on screen does, and the assistant reports what each test said. When the key itself is the problem, it says what to do on screen instead.
- **"Make Jo the owner of the GitHub integration."** The owner gets the integration's Fix sign-in and Grant permission actions.
- **A logo:** the assistant gives an image address and Compass fetches it, as **Fetch logo** does on screen. Uploading a file stays on screen.
- **Refusals in words:** the form's own rules apply, and their messages come back as the reason. That covers an address that isn't https or isn't public, a sign-in or paging style that isn't on the list, a reserved header, a name already taken, and an Accept header that isn't JSON (COM-1640).
- **Needs Manage integrations.** Without it, the tools aren't offered (ADR 0109).

## Done when

- New tools sit beside `posture_list_collection_integrations`, with names chosen in the PR:
  - add a service;
  - change a service's settings;
  - set its owner;
  - fetch its logo.
- Every one is `always_ask` and recorded in Activity as the person, via Polaris.
- The list tool also returns each service's settings (address, sign-in method, paging, headers, test read, docs link), so the assistant can see what it's changing. It never returns a key, username or key hint.
- The add and change tool descriptions carry the settings rules: the fixed sign-in and paging lists, GET only, https, a test read that works for every kind of key with no per-account values in it, and when Accept may be set. Wording should match COM-1658's define prompt, so the assistant and Polaris give the same answer.
- The list tool's description and the server instructions' Collection paragraph no longer say that creating and changing stay on screen. They say the accounts and their keys do.
- Tests:
  - each tool round-trips through the API in-process, the way the other chat tool tests do;
  - a refused setting comes back as the form's message;
  - the tools are hidden without Manage integrations;
  - no tool output contains a key hint or username;
  - the pinned tool-count and tool-name tests are updated.
- **Pre-UAT on staging**, through a connected assistant: add a test service ("E2E Cloudflare (test)"), change its test read, set its owner and fetch its logo. Check each change in Activity as via Polaris, then remove the service on screen.

## Notes

- **Independent:** tools only, calling the existing `/api/v1/collection-integrations` routes (create, GET detail, PUT, owner, icon/fetch). No migration and no API change.
- Where: `assistant/tools/posture_collection.py` (or a new `posture_collection_admin.py` if it grows), and the server instructions text.
- Follow ADR 0143's per-area tool counts: this adds about four tools to Posture (49 today), which matters for the Copilot per-area agents (sr3v2fq).
- Builds on COM-1659. COM-1658 holds the shared test-read wording; if it lands first, reuse its text.
---
id: 01M711BSM4E0CWXXMQYNPKJG6M
created: 2026-11-09T20:52:57.604302Z
updated: 2026-11-09T20:53:07.282733Z
type: task
title: 'Chat tools: a Collection integration''s accounts — an assistant adds an account waiting for its key and hands back the link to enter it, renames an account, and runs its test'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1662
sprint: sjvqrdg
blocked_by:
- 01M711AQKWZRB75FCZ7158HMV8
- 01M711BBFREYFZ6V5KW1R0B1NB
assignee: steve
label:
- feature
priority: high
task_status: todo
---
Part of the change recorded in COM-1659. The assistant handles the accounts; the key is always entered by a person on screen.

## What the person can ask for

- **"Add a Cloudflare account for Test Company called Cloudflare - Staging."** The assistant says what it will add, then adds the account without a key, so it shows **Waiting for its key** (COM-1660). The answer gives the link that opens the account with its key field ready, plus the steps to make the key (the read-only rights to tick, preferring an account-owned key). The assistant never asks for the key, and says so if the person offers to paste one.
- **When the service signs in with a username or client ID beside the secret** (basic, digest, client credentials), the username is also entered on screen. A public key or client ID is sometimes a credential in its own right, so it's safer kept with the secret (my call).
- **"Has the key gone in? Test it."** The assistant runs the account's test and reports the result in plain words: Connected, and what the test read answered with, or why it failed. Asked for a waiting account, it says the key hasn't been entered yet and gives the link again. For a failed test, the assistant may propose a change to the service with COM-1661's change tool, e.g. a test read that works for any key.
- **"Rename the account to Cloudflare - Production."** Renaming only, never the key, the username or the company.
- **Health stays as it is**: `posture_list_collection_integrations` shows each account's health, now including Waiting for its key.
- **Needs Manage integrations**, plus write access to the account's company for adding.

## Done when

- New tools (names chosen in the PR):
  - add an account (waiting for its key, returns the link);
  - rename an account;
  - test an account.
- Adding and renaming are `always_ask`. Testing is a read of the service: don't mark it `always_ask`, but say so in its description.
- All are recorded in Activity as the person, via Polaris.
- No tool takes or returns a key, username, secret or secret hint. A test proves it: the tools' input schemas have no such field, and their outputs never contain the hint.
- The list tool shows Waiting for its key for a waiting account.
- Tests:
  - add, then the account is waiting with a link;
  - testing a waiting account says so and doesn't call the service;
  - testing a connected one reports the result;
  - rename;
  - the permission and company-access refusals;
  - the pinned tool-count and tool-name tests are updated.
- **Pre-UAT on staging**, through a connected assistant, in E2E Test Company:
  - add an account to a test service and confirm it shows Waiting for its key on screen;
  - enter a key on screen from the link (the "E2E GitHub public (test)" service ignores its key, so any value passes);
  - ask the assistant to test it, and check it reports Connected;
  - check Activity, then remove the account on screen.
- **For Steve:** a real Cloudflare account token through this flow.

## Notes

- **Stacks on COM-1660:** it needs its keyless add. The tools themselves change no API shape. It also builds on COM-1661, which owns the shared tool-description wording.
- Where: `assistant/tools/posture_collection.py` (or the new admin module from COM-1661); routes `POST /collection-integrations/{id}/accounts`, `PATCH /accounts/{id}`, `POST /accounts/{id}/test`.
- The account link's form comes from COM-1660.
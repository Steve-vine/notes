---
id: 01M711AQKWZRB75FCZ7158HMV8
created: 2026-11-09T20:52:22.780524Z
updated: 2026-11-09T20:52:22.780524Z
type: task
title: A Collection account can wait for its key — added without one, it shows "Waiting for its key" with an Enter the key button, and is neither tested nor read until a person enters it
task_status: todo
priority: high
label: feature
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1660
---
Part of the change recorded in COM-1659: an assistant may add an account to a Collection integration, but never its key. Today an account can't exist without its key, so this task makes room for one that is waiting.

## What the person sees

- **On the integration's page**, an account added without a key shows **Waiting for its key**, not a health state, with an **Enter the key** button. That button opens the same key field as **Change key** today. Saving the key runs the test straight away, as adding an account on screen does now.
- **The integration's state** counts a waiting account as not set up yet: "Not set up" while every account is waiting, otherwise its usual state. The Integrations tile says "1 account waiting for its key".
- **Nothing reads a waiting account:** not the scheduled collection, Collect now, the test read, samples or Polaris's design job. Checks that read every account of the service skip it, and a waiting account doesn't make a check broken.
- **The integration's owner gets an action:** "Enter the key for Cloudflare - Staging". It goes when the key is entered or the account is removed, and follows ADR 0137 (one action per thing).
- **The on-screen Add account form** still asks for the key, as it does today. Only an assistant (COM-1662) adds an account without one.
- **Every account has its own address**, so a link can open its integration page with that account's key field ready. The assistant returns this link.

## Done when

- An account can be saved without a key, and shows as above.
- Entering the key on a waiting account saves it write-only (ADR 0141 §2), shows the last four characters, and runs the test.
- A waiting account is skipped by collection and design, and doesn't break checks. The owner's action appears and clears.
- Tests (integration, real Postgres):
  - add without a key, then enter the key, then the test runs;
  - collection skips a waiting account;
  - the action appears and clears;
  - the screen's add form still refuses an empty key.
- **On staging:** an account added through the API with no key shows Waiting for its key. Entering the key from the link makes it Connected.

## Notes

- **On the chain:** a migration makes `collection_accounts.secret_encrypted` nullable (append-only; never edit a merged one), and the API changes, so regenerate `schema.d.ts`. The add-account body gets an optional secret, refused when missing unless the request is via an assistant: decide in the PR whether "via assistant" is the right gate or simply "secret optional" with the form requiring it.
- Where:
  - `models/collection_integration.py`;
  - `api/v1/collection_integrations.py` (`add_collection_account`, `AccountOut` gains a waiting flag);
  - `core/collection/accounts.py` and `runner.py` (skip a waiting account);
  - `core/actions/collection_problems.py` (the new action);
  - the frontend under `integrations/collection/` (the account row, Enter the key, deep link).
- Any new Celery task needs a label (TASK_LABELS).
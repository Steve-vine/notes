---
id: 01M6HRDWN120NZEAANE1FAWVTZ
created: 2026-11-03T22:28:12.577459Z
updated: 2026-11-03T22:28:12.577459Z
type: task
title: Leavers — when someone's leaver request completes, the secrets they own lose their owner, are flagged "Owner left" and need a rotation within 14 days; the leaver request lists them, and the GitHub keys and tokens they added
priority: medium
task_status: todo
label: feature
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1578
---
Sprint "Secrets - New Module" (ADR 0141, COM-1563). Builds on COM-1577. The library already expects it: "Shared credentials the leaver knew are changed as part of the process."

## What people see

- **When a leaver request completes** in Access Control, every secret the leaver owns:
  - **loses its owner**;
  - is flagged **Owner left**, with the name and the date;
  - becomes **due for rotation in 14 days**, whatever its own due date. If it was already due sooner, the sooner date stands.

  Its one action, *Secret · Rotate*, goes to the holders of *Manage secrets* (it's ownerless, COM-1567), with the reason **"Owner left on 3 Nov (ACR-41) — set a new owner and rotate"**. Setting a new owner moves the action to them. Recording the rotation clears the flag.
- **On the leaver request page**, a **Secrets** card shows:
  - the secrets they owned (SEC-N, linked);
  - with GitHub connected (COM-1575): **deploy keys they added** and **fine-grained tokens that belong to them**, where Compass can match their GitHub login to them.

  Tokens are personal, so the card says **"Revoke these in GitHub"**. A tracked token that's revoked shows as gone on the next read.
- **Before the leaver completes**, the card already shows on the request, so the approver sees what will need doing.
- **Changing the 14 days** is on Secrets ▸ Settings: "When an owner leaves, rotate within [14] days".

## Notes (technical)

- Hook into the point where a leaver access request reaches completed, in the same transaction as its other completion effects. Make it idempotent: a retried completion mustn't double the history entry.
- Store the override due date on the secret (`owner_left_on`, `rotate_by`). `core/secrets/due.py` takes the earlier date.
- **GitHub login → person:** use the organisation's SAML SSO identities, if the org uses SSO and the App can read them. Check what permission that needs first. If a read-only App can't see them, leave GitHub matching out, say so on the card ("Compass can't tell which GitHub account is theirs"), and note it in the PR. Never guess from names.

**Chain:** on the chain (migration and API).

**Done when:** on staging, in E2E Test Company:
- completing a leaver for a test user who owns SEC-1 clears the owner, shows Owner left, and puts *Rotate* on E2E Admin's Actions due in 14 days;
- setting a new owner moves the action;
- recording a rotation clears the flag;
- the leaver request's Secrets card listed SEC-1 before it completed.
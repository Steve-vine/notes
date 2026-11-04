---
id: 01M6HRDWN120NZEAANE1FAWVTZ
created: 2026-11-03T22:28:12.577459Z
updated: 2026-11-04T07:45:58.534131Z
type: task
title: Leavers — when someone's leaver request completes, the secrets they own lose their owner, are flagged "Owner left" and need a rotation within 14 days; the leaver request lists them, and the GitHub keys and tokens they added
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1578
sprint: sjrd5gz
blocked_by:
- 01M6HRDDYKFY29A2FE32PBQBBF
comments:
- id: 01M6JJEZKG6B6JVZHRT5T5RH05
  author: Steve Vine
  at: 2026-11-04T06:03:11.344018Z
  text: |-
    Merged to main in PR #1593.

    **What's in it**
    - **When a leaver request completes**, every secret the leaver owned:
      - loses its owner;
      - shows **Owner left** on the secret's page (who, when, and the request, linked) and on the register;
      - must be rotated within **14 days**, unless it was already due sooner. Next due reads "because its owner left".
    - **Its one action** (*Secret · Rotate*) goes straight to whoever manages secrets, whatever the reminder lead time, titled "… — Owner left on 3 Nov (ACR-41) — set a new owner and rotate".
      - Setting a new owner moves the action to them ("… — rotate").
      - Recording a rotation clears the flag and the action.
    - **Leaver request page:** a **Secrets** card, for people who can see secrets.
      - Before the request completes it lists what the leaver owns, which will need rotating.
      - After, it lists what the request left ownerless, marked Owner left.
    - **GitHub:** with GitHub connected, the card says "Compass can't tell which GitHub account is theirs. In GitHub, revoke the tokens that belong to them and check the deploy keys they added." Matching a GitHub login to a person needs the organisation's SAML identities, and a read-only App can't read those. Compass doesn't guess from names.
    - **Secrets ▸ Settings** has a new field: "When an owner leaves, rotate within [14] days".
    - A retried completion changes nothing more (tested).
    - Under the hood this is one "rotate sooner than the schedule" mechanism, which COM-1579's incidents use too.

    **Couldn't check:** completing a real leaver. E2E Test Company has no directory, so pre-UAT uses a seeded completed leaver.
- id: 01M6JQ0G0XXWJFK0M6NSRRKC5Z
  author: Steve Vine
  at: 2026-11-04T07:22:39.517041Z
  text: |-
    **Pre-UAT: Partly passed** (staging, E2E Test Company).
    - **Passed:**
      - Secrets ▸ Settings shows "When an owner leaves, rotate within [14] days" beside the reminder lead time.
      - The API reads 14 by default.
      - A leaver request's page shows the **Secrets** card. On the Browser smoke's rejected leaver (ACR-93) it says "They own no secrets.", which is right: that person isn't a Compass user who owns any.
    - **Couldn't check:**
      - The card listing a real owner before the leaver is decided needs a leaver for a directory person who is also a Compass user. E2E Test Company has no directory.
      - The seeded completed leaver (new owner moves the action, rotation clears the flag) needed a database write, which was blocked.
      - Both are covered end to end by `test_secret_leavers.py`.
    - **For Steve:** on a company with a directory, raise a leaver for someone who owns a secret. The card lists it before you decide; once it completes, the secret shows Owner left and is due in 14 days.

    Screenshots: `~/compass-uat/sprint-105/COM-1578/settings-tab.png`, `leaver-request-secrets-card.png`.
assignee: steve
label:
- feature
priority: medium
task_status: done
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
  - with GitHub connected (COM-1575, COM-1581): **deploy keys they added** and **fine-grained tokens that belong to them**, where Compass can match their GitHub login to them.

  Tokens are personal, so the card says **"Revoke these in GitHub"**. A tracked token that's revoked shows as gone on the next read.
- **Before the leaver completes**, the card already shows on the request, so the approver sees what will need doing.
- **Changing the 14 days** is on Secrets ▸ Settings: "When an owner leaves, rotate within [14] days".

## Notes (technical)

- Hook into the point where a leaver access request reaches completed, in the same transaction as its other completion effects. Make it idempotent: a retried completion mustn't double the history entry.
- Store the override due date on the secret (`owner_left_on`, `rotate_by`). `core/secrets/due.py` takes the earlier date.
- **GitHub login → person:** use the organisation's SAML SSO identities, if the org uses SSO and the App can read them. Check what permission that needs first. If a read-only App can't see them, leave GitHub matching out, say so on the card ("Compass can't tell which GitHub account is theirs"), and note it in the PR. Never guess from names.
- E2E Test Company can't complete a leaver: it has no directory, and the Browser smoke's leaver journey is raised to be rejected. Cover the completion in an integration test, and give pre-UAT a seeded completed leaver.

**Chain:** on the chain (migration and API).

**Done when:**
- An integration test completes a leaver who owns a secret: the owner is cleared, Owner left shows, *Rotate* is due in 14 days for the *Manage secrets* holders, and a retried completion changes nothing more.
- On staging, in E2E Test Company:
  - a leaver request raised for a test user who owns SEC-1 shows SEC-1 on its Secrets card before it's decided;
  - with the seeded completed leaver, setting a new owner moves the action, and recording a rotation clears the flag.
- Completing a real leaver is **Couldn't check** in pre-UAT. Steve checks it on a company with a directory.
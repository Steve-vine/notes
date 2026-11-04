---
id: 01M6HREQY849F5X4RK913AW8QV
created: 2026-11-03T22:28:40.520369Z
updated: 2026-11-04T04:53:08.495538Z
type: task
title: Incidents — an incident lists the secrets used by, or kept with, its affected systems, and "Ask for rotation" puts each on its owner's Actions with the incident as the reason and a date chosen there
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1579
sprint: sjrd5gz
blocked_by:
- 01M6HRDWN120NZEAANE1FAWVTZ
assignee: steve
label:
- feature
priority: medium
task_status: active
---
Sprint "Secrets - New Module" (ADR 0141, COM-1563). Builds on COM-1578. It follows the Incident Register (ADR 0116).

## What people see

- **A Secrets card on the incident**, for anyone who can see the incident and has *View secrets*. It lists the secrets:
  - **used by** any of the incident's affected systems; and
  - **kept with** them: a stored copy in a cloud account or vault that Inventory ties to an affected system.

  Each row shows SEC-N, the owner, its last rotation, and whether a rotation is already in progress.
- **Ask for rotation** (needs *Manage secrets*, or handling the incident):
  - Choose all or some of the secrets, and a **rotate-by date** (2 days by default).
  - Each secret's one action becomes *Secret · Rotate*, due by that date, with the reason **"Incident INC-7 · Suspected key leak in billing-api"**. A Rotate already open is brought forward, never duplicated (ADR 0137).
  - The incident's timeline records "Asked for 4 secrets to be rotated by 5 Nov".
- **Progress on the card.** "3 of 4 rotated". Each row shows how its rotation is known: recorded, confirmed or seen.
- **The secret's page** shows the incident in its history, linked.
- **Closing isn't blocked.** An incident can close with rotations still outstanding. The card shows them, and the incident's review can record them.

## Notes (technical)

- Affected systems come from `IncidentAsset`. "Kept with" uses each store entry's account/vault resource, matched to the affected technology assets through Inventory's discovered links, where one exists. Without a link, it's left out rather than guessed.
- A rotation request is a `secret_rotation_request` row (secret, reason kind, incident_id, rotate_by, asked_by). It's satisfied by the next rotation after asked_at. `core/secrets/due.py` takes the earliest open rotate_by.
- Fold COM-1578's leaver override into the same table (reason kind `owner_left`), so there's one mechanism for "rotate sooner than the schedule".

**Chain:** on the chain (migration and API).

**Done when:** on staging, in E2E Test Company:
- an incident with an affected test system that SEC-1 and SEC-2 use lists both;
- Ask for rotation by tomorrow puts *Rotate* on each owner's Actions with the incident as the reason;
- recording one rotation shows "1 of 2 rotated" on the incident;
- the incident's timeline has the request.
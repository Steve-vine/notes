---
id: 01M6HREQY849F5X4RK913AW8QV
created: 2026-11-03T22:28:40.520369Z
updated: 2026-11-04T07:22:43.90751Z
type: task
title: Incidents — an incident lists the secrets used by, or kept with, its affected systems, and "Ask for rotation" puts each on its owner's Actions with the incident as the reason and a date chosen there
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1579
sprint: sjrd5gz
blocked_by:
- 01M6HRDWN120NZEAANE1FAWVTZ
comments:
- id: 01M6JK8YR1GFR1232XKTCZV2FY
  author: Steve Vine
  at: 2026-11-04T06:17:22.433727Z
  text: |-
    Merged to main in PR #1594.

    **What's in it**
    - **A Secrets card on the incident** (in Respond), for anyone who can see the incident and has View secrets. It lists the secrets:
      - **used by** an affected system ("Used by Billing API"); or
      - **kept with** one: a copy read from a cloud account where Inventory has attached a resource to an affected system ("Kept in the same AWS account as Billing API"). Without that link a copy is left out, never guessed.

      Each row shows the owner, last rotated, and the rotation's state: *By 6 Nov*, *Rotated · recorded / confirmed / seen*, or *In progress*.
    - **Ask for rotation** (Manage secrets, or handling incidents; the incident must still be open). Choose the secrets (all by default) and a rotate-by date (two days by default).
      - Each one's single action becomes *Secret · Rotate*, due then, titled "… — Incident INC-7 · Suspected key leak in billing-api", for its owner (or whoever manages secrets).
      - Asking again brings the date forward, never a second action.
      - The timeline records "Asked for 2 secrets to be rotated by 5 Nov".
    - **Progress:** "1 of 2 rotated" on the card.
    - **The secret's history** names the incident. A restricted incident is named by its reference only, there and in the action title.
    - Closing the incident isn't held up by what's still to rotate.

    **Also fixed here (from COM-1566):** a control's Secrets evidence of operation counted "M secrets" across every company's rotations. It now counts the company's own (regression test added).

    Tested by `test_secret_incidents.py`, plus the restricted-incident and closure suites (all 312 incident tests pass).
- id: 01M6JQ0MA3X9F4QWA87DD9MDAM
  author: Steve Vine
  at: 2026-11-04T07:22:43.907338Z
  text: |-
    **Pre-UAT: Passed after a fix** (staging ecb35d20, E2E Test Company).
    - INC-46 was recorded with web-1 as an affected system. Its Secrets card lists SEC-2 and SEC-3, both "Used by E2E pre-UAT 102 web-1".
    - **Ask for rotation** by tomorrow:
      - the card read "0 of 2 rotated";
      - SEC-2's owner E2E Admin A and SEC-3's owner E2E Analyst each got *Secret · Rotate*, due 5 Nov, titled "— Incident INC-44 · …" (the earlier incident's request is the earliest open one);
      - the timeline says "Asked for 2 secrets to be rotated by 5 Nov".
    - Recording SEC-3's rotation made the card read "**1 of 2 rotated**" (SEC-3 "Rotated · recorded") and cleared SEC-3's action.
    - **Defect found and fixed (COM-1582):** on the first run (INC-44), SEC-2 had been rotated minutes before the ask and counted as already done. Fixed in PR #1597, and the re-check above is after the fix.

    Screenshot: `~/compass-uat/sprint-105/COM-1579/incident-44-secrets-card.png` (taken before the fix).
assignee: steve
label:
- feature
priority: medium
task_status: review
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
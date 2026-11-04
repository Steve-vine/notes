---
id: 01M6HR7ZNGB841CC92QNPYP697
created: 2026-11-03T22:24:59.05689Z
updated: 2026-11-04T07:22:03.822456Z
type: task
title: Reminders — the owner gets "Secret · Rotate" on their Actions a set time before a secret is due (30 days unless changed in Settings), due on the due date; one action per secret, cleared by the rotation; an ownerless secret's goes to the people who manage secrets
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1567
sprint: sjrd5gz
blocked_by:
- 01M6HR7GWBC172W0YXKPD44V5G
comments:
- id: 01M6J5Y9SF38P2PHYQJDV0TTTC
  author: Steve Vine
  at: 2026-11-04T02:24:21.807345Z
  text: |-
    Done: PR #1581 merged, migration 0776.

    What's there:
    - **Secret · Rotate** on the owner's Actions from the company's lead time before a secret is due (30 days by default), due on its due date and red once past. It opens the secret.
    - **Secret · Renew before it expires** when the expiry is what sets the date.
    - **One row per secret.** It clears when the rotation is recorded, the secret is retired, or a change moves the date outside the lead time.
    - **No owner:** the row goes to the **Secrets team**, whoever holds *Manage secrets* (or whoever Admin ▸ Actions names). Its title says "no owner, set one".
    - **Nothing for:** a secret that isn't due yet (long-lived or not), one that needs a date, one with no schedule, or anything not registered.
    - **Secrets ▸ Settings** tab, for *Manage secrets*: "Remind owners this many days before a secret is due" (0–365). The register now has tabs.
    - Mail follows the action as it does everywhere else. There's no separate notification.

    My calls:
    - **Amber from 7 days before the date,** as Vulnerabilities does. Red once it's past.
    - **Managers see every secret's row,** not only the ownerless ones (ADR 0137 §3, as every module does). *My actions* shows a person their own.

    To test on staging (after the sprint deploys), in E2E Test Company:
    1. A secret due in about 20 days is on its owner's Actions; one due in about 40 isn't.
    2. Set the lead time to 60 on Settings: the second appears.
    3. Record a rotation on the first: it leaves.
    4. Clear a secret's owner: it shows on E2E Admin's Actions as the Secrets team's.
    5. A long-lived secret that isn't due is on nobody's Actions.
- id: 01M6JPZD5EACHT331HA822917F
  author: Steve Vine
  at: 2026-11-04T07:22:03.822265Z
  text: |-
    **Pre-UAT: Passed** (staging, E2E Test Company).
    - While overdue, SEC-2 put **Secret · Rotate** on its owner E2E Admin A's Actions, due 30 Sep 2026 (overdue). Recording the rotation cleared it.
    - SEC-3's action (asked by an incident) is on E2E Analyst's Actions, titled with the incident, due tomorrow.
    - One action per secret throughout: SEC-3 was asked about by two incidents and still had one action.
    - Secrets ▸ Settings shows "Remind owners this many days before a secret is due: 30".

    Screenshots: `~/compass-uat/sprint-105/COM-1567/analyst-actions.png`, `COM-1578/settings-tab.png`.
assignee: steve
label:
- feature
priority: high
task_status: review
---
Sprint "Secrets - New Module" (ADR 0141, COM-1563). Builds on COM-1566.

## What people see

- **Secret · Rotate** appears on the owner's Actions **30 days before** the secret is due, and is due on its due date. It reads: "SEC-12 · Stripe live key (billing-api) — due 14 Dec". It opens the secret.
  - If the expiry is what's driving the date, it reads **"Secret · Renew before it expires"**.
- **Recording the rotation clears it** (COM-1566). So does retiring the secret, or a change that pushes the due date outside the lead time.
- **One action per secret** (ADR 0137). Later tasks turn the same action into *Confirm rotation* or *Finish rotation*. It's never a second one.
- **No owner?** The action goes to the holders of *Manage secrets* as a role-owned action, with "No owner — set one" as part of it.
- **Settings tab** (for *Manage secrets*): **Remind owners [30] days before a secret is due**.
- **What never raises an action:** a Long-lived secret that isn't due, a secret marked "Needs a date", a retired secret, and anything on Discovered that nobody has registered.
- Mail follows the action as it does everywhere else (ADR 0055). There's no separate notification.

## Notes (technical)

- Declare a new action source in `core/actions/secrets.py` (ADR 0055/0137 pattern: declare the source, don't write a notify()). Due-state comes from `core/secrets/due.py`.
- Lead time lives in a new `secrets_settings` row per company.
- A daily sweep only if the action source can't be computed on read. If a Celery task is added, add its TASK_LABELS entry (memory: new Celery task needs a label).

**Chain:** on the chain (migration and API).

**Done when:** on staging, in E2E Test Company:
- a secret due in 20 days is on its owner's Actions; one due in 40 days isn't;
- setting the lead time to 60 brings the second one in;
- recording a rotation clears it;
- a secret whose owner is cleared shows on E2E Admin's Actions as role-owned;
- a Long-lived secret that isn't due is on no one's Actions.
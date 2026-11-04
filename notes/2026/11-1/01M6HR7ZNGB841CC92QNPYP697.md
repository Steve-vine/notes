---
id: 01M6HR7ZNGB841CC92QNPYP697
created: 2026-11-03T22:24:59.05689Z
updated: 2026-11-04T01:39:17.439038Z
type: task
title: Reminders — the owner gets "Secret · Rotate" on their Actions a set time before a secret is due (30 days unless changed in Settings), due on the due date; one action per secret, cleared by the rotation; an ownerless secret's goes to the people who manage secrets
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1567
sprint: sjrd5gz
blocked_by:
- 01M6HR7GWBC172W0YXKPD44V5G
assignee: steve
label:
- feature
priority: high
task_status: active
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
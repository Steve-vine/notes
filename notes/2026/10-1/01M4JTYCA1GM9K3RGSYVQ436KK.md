---
id: 01M4JTYCA1GM9K3RGSYVQ436KK
created: 2026-10-10T12:00:00.833462Z
updated: 2026-11-25T23:05:18.383634Z
type: task
title: Trusted accounts — changes made by an account an Access admin trusts are recorded, not sent for validation
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 902
assignee: steve
label:
- feature
priority: medium
task_status: active
---
**On the chain** (migration + API). Independent of the COM-850 group of tasks.

The original ask (10 Oct): let external automated systems work without every change they make landing on the validation screen. Today the only control is an on/off switch per kind of change (ADR 0082), which explicitly left finer exceptions to "a later layer". This is that layer.

Steve's decisions (25 Nov):
- The accounts are ones already in Compass's list. A couple of scripts make changes from time to time.
- Their changes are **recorded, not validated**.
- Trust covers **anything the account does**.

## What people see

- **Access Control ▸ Admin ▸ Validation** gains **Trusted accounts**, under *What Compass watches*.
  - Someone who can explain or reverse unrequested changes adds an account, picked from Compass's list of accounts, with a **reason** (required).
  - An app can be picked as well, since a script often signs in as one rather than as a user.
  - The list shows each account, its reason, and who added it and when. Removing one is a single action.
  - Adding and removing both go in the activity log.
- A change made by a trusted account goes to **Recorded changes**, not **Unrequested changes**, labelled "Made by trusted account *svc-hr-script* — *reason*". It never needs validating, never appears in anyone's Actions, and never goes overdue. That applies to everything the account does, admin roles included.
- **Timing:** Microsoft reports who made a change minutes to hours later. So a trusted account's change can sit briefly in Unrequested changes, then move to Recorded changes by itself once Compass learns who made it.
- **Only changes made in Entra can be recognised.** Changes made straight in on-prem AD or in Exchange (mailbox and list rights) don't record who made them, so they stay as today even if a trusted account made them. The Trusted accounts section says so in one line.
- **Not retroactive.** Adding an account doesn't move items already raised, which are validated as normal. Removing one doesn't bring back items already recorded.
- **Polaris** can list the trusted accounts and explain why an item was recorded. Adding and removing stay on screen.

## Notes (technical)

- **ADR 0180** (next free number), building on ADR 0082:
  - exceptions are by **who made the change**, not by object;
  - a trusted account's changes are **recorded, never hidden**;
  - only Entra-attributed changes qualify, since actor lookup stays best-effort (ADR 0045 COM-390 amendment).
- **Model:** a trusted-actor table holding the actor kind (user / app), the Entra object id (user id, or service principal id / appId), a display name kept for history, the reason, who added it and when. Audited.
  - Match on the immutable id, not the UPN, so a rename doesn't break trust.
  - If `enrich_actors` doesn't keep the initiator's object id today (it stores UPN / appId in `actor_identifier`), add it.
- **Where it applies:** in `tasks/directory_sync.py`, where `enrich_actors` / `_apply_match` attributes an item.
  - If the actor is trusted and the item is still open: move it to the `for_information` lane, record which trust entry and reason, and clear the due date.
  - The Actions queue source (`core/actions/access.py` `_unrequested_changes`) only reads the `needs_validation` lane, so the item drops off automatically.
- **API / UI:** endpoints beside `api/v1/unrequested_watch.py`. Read needs access view; change needs `access.review_unrequested`, the same as the watch switches. UI in `WatchSection.tsx`, with the account picker over the people and apps lists. Recorded-changes rows show the trusted label (`ChangedBy.tsx`).
- **Polaris:** a read tool in `assistant/tools/access_validation.py`.
- **Edge case:** the `seen_after_restore` items after a backup restore are unaffected. Trust only acts on attribution.

**Done when:** on staging:
- With a test account added as trusted, a group change made in Entra as that account moves to **Recorded changes** with the trusted label once attributed, and isn't in anyone's Actions.
- After removing the trust, the next change it makes stays in **Unrequested changes**.
- Adding and removing both show in the activity log.
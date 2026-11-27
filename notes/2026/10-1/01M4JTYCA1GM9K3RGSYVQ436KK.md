---
id: 01M4JTYCA1GM9K3RGSYVQ436KK
created: 2026-10-10T12:00:00.833462Z
updated: 2026-11-27T11:25:05.508969Z
type: task
title: Trusted accounts — changes made by an account an Access admin trusts are recorded, not sent for validation
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 902
comments:
- id: 01M8AJ3HC7NNDZVM87CGWCJVKJ
  author: Steve Vine
  at: 2026-11-25T23:54:24.519086Z
  text: |-
    Done — PR #2178, merged to main (d9b95dfa). Goes to staging with the rest of the sprint-0 batch.

    What to look at:
    - **Access Control ▸ Admin ▸ Trusted accounts** (new card under *What Compass watches*): **Add trusted account** opens a picker over people and apps from the directory. A reason is required. The list shows each account, its reason, and who added it and when. The bin icon removes one in a single action. A line says only changes made in Entra can be recognised (AD and Exchange changes are raised as usual), and that nothing already raised moves either way.
    - **Validation ▸ Recorded changes:** a change made by a trusted account moves here by itself once Microsoft says who made it, labelled "Made by trusted account *name* — *reason*". It's never in anyone's Actions and never goes overdue. Admin roles are included.
    - **Activity log:** "trusted *name*: its changes are recorded, not validated — *reason*" and "stopped trusting *name*".
    - **Polaris:** can list the trusted accounts, and a recorded change says why it was recorded. Adding and removing stay on screen.

    Decided while building:
    - Trust applies to changes **raised after** the account was added. A change raised before, even if Microsoft only names its maker later, is still validated as normal.
    - Trusted accounts is its own card directly under *What Compass watches*, with its own link (`#trusted-accounts`) that Polaris uses.

    Technical: migration 0926 (the trusted accounts table; each unrequested change now keeps the Entra id of whoever made it, plus the trust's name and reason); ADR 0180; matched on the Entra id (an app also by its application id), never the sign-in name; new Polaris tool access_list_trusted_accounts. The item's due date is kept but nothing reads it once the item is recorded.
- id: 01M8AWJCEHE456JZZR96FMERMJ
  author: Steve Vine
  at: 2026-11-26T02:57:16.75327Z
  text: |-
    **Pre-UAT: Passed (on screen) · Couldn't check (the Entra half)** — staging 30d00690, 26 Nov 02:47, as E2E Admin A.

    Passed:
    - Access Control ▸ Admin ▸ **Trusted accounts** card is under *What Compass watches*, with the Entra-only and not-retroactive lines.
    - **Add trusted account**: the picker found "Accounts User (Accounts@MP7400.onmicrosoft.com · Disabled)"; *Trust this account* stayed disabled until a reason was given. Added with the reason "E2E pre-UAT check of COM-902 — removed straight after"; the list showed it with "E2E Admin A, 26 Nov 2026, 02:47".
    - **Stop trusting Accounts User** removed it in one click; the card went back to "No trusted accounts".
    - Activity log: "trusted Accounts User: its changes are recorded, not validated — …" and "stopped trusting Accounts User", both as E2E Admin A.

    Couldn't check — needs a real change in Entra, for Steve:
    1. Trust the account a script signs in as (or a test account).
    2. Have it change the membership of a group a business role maps (an unmapped group lands in Recorded changes anyway, so it proves nothing).
    3. After Microsoft reports who made it (minutes to hours), the item should move from Unrequested to **Recorded changes**, labelled "Made by trusted account … — reason", and not be in anyone's Actions.
    4. Stop trusting it; its next change should stay in Unrequested changes.

    Screenshots: ~/compass-uat/sprint-0/COM-902/
assignee: steve
label:
- feature
priority: medium
task_status: done
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
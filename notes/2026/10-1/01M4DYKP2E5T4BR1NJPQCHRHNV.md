---
id: 01M4DYKP2E5T4BR1NJPQCHRHNV
created: 2026-10-08T14:27:52.526869Z
updated: 2026-10-09T16:25:17.172866Z
type: task
title: The move form always shows Account details — a move can change a job title or manager without changing a role
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 872
sprint: sme8esk
blocked_by:
- 01M4DTGAG6GYPPRJ294BK42TV9
- 01M4DWZRQS9T0JXAGJHRP0FXYB
comments:
- id: 01M4EQFZ1S4FVGH7JH5QDXS00C
  author: Steve Vine
  at: 2026-10-08T21:42:45.049644Z
  text: |-
    Done — PR #873, merged to main 2026-10-08. Not yet on staging (deploys with the rest of the sprint).

    What changed:
    - On a move request, Account details is there as soon as a person is chosen, showing what the account says now.
    - A move can be raised with only detail changes — a new job title, a new manager — with the roles untouched. It goes through approval like any other move.
    - Changing the Primary role still offers that role's defaults. Not changing it pre-fills nothing.
    - A move that changes nothing can't be raised: the button stays off and the form says "Nothing is changed yet — change a role, an account detail or a group to raise this move."
    - The "No roles after this move" confirmation now only appears for someone who holds roles and is losing all of them.
    - The request page says "Unchanged — they keep …" under Role change when the roles are left alone.
    - At approval, Account details is shown for every move. Putting the Primary role back no longer throws the detail changes away; an approver who doesn't want them removes them.

    Decision record: ADR 0095 (supersedes the part of ADR 0090 that tied details to a change of primary role).

    One departure from the task: "nothing to change" is a rule of the form, not of the API. Compass itself raises moves whose change isn't visible on the person (editing a role's groups does), so the API still accepts one.

    Not checked: how the window scrolls with 30+ fields now the section is always open — worth a look in the smoke test.

    To check on staging after deploy: open a move, change only the job title and manager, raise and approve; both change in the directory, roles and groups are untouched, the account stays in its OU.
- id: 01M4GEN8YSSNRBEZ9SCW32EBZ2
  author: Steve Vine
  at: 2026-10-09T13:46:50.713164Z
  text: 'On staging 2026-10-09 (5161e64a). Not checked in a browser: how the move window scrolls now Account details is always open.'
assignee: steve
label:
- feature
priority: medium
task_status: done
---
Asked for by Steve testing access control on staging, 2026-10-08: "The Joiner fields are only shown if a role is changed. It's possible that one of these fields could be the only change required and the role stays the same, e.g. job title / manager. Always display the Joiner fields and accept a mover change that only changes some of these fields rather than a role."

**Blocked by COM-863** (the form reads what the account says now from the mirror — without it this section opens blank) and **COM-871** (same component; land that first).

## What people see

- On a move request, **Account details is always there** once a person is chosen — not only after the Primary role is changed.
- Each field opens on **what the account says now**. Change one and it is marked as changed; put it back and it isn't.
- **A move can be raised with only detail changes** — new job title, new manager, roles untouched. It goes through approval like any other move, and the request page shows each detail before → after.
- When the Primary role *is* changed, the new role's default values are offered exactly as today. When it isn't, nothing is pre-filled over what the account says.
- **A move that changes nothing can't be raised.** The button stays off until a role, a detail (or, later, a group) differs, and the form says so.
- With roles unchanged the form doesn't warn about roles being taken away, and the account stays where it is.

Not in this task: changing the display name or sign-in name (a rename is its own kind of change), and the fields a person can't have because their directory doesn't hold them.

## Decision record

ADR 0090 ("A mover's account details follow the primary role") ties a detail change to a change of primary role, and the API enforces it. This task ends that tie. Write a short ADR that supersedes that part — do not edit 0090: details may change on any move; the primary role only decides which **defaults** are offered.

## How (implementation)

**Backend**
- `api/v1/access_requests.py` ~line 398–413: when `account_details` is sent and the primary doesn't change, it raises 422 "account details change with the primary role — this request leaves their primary role as it is". Remove that refusal; keep `snapshot()` as is — it already drops fields that match the account and records before → after.
- The branch above it (`account_details is None` → keep the stored snapshot only if the primary changes) decides what a correction at the approval gate keeps; make it keep stored details regardless of the primary.
- "Nothing to change": a mover whose role set equals what is held, with an empty details snapshot (and no group changes), is refused with a plain message — today a no-op mover is accepted. Check `_settle_mover_primary` and the mover branch of `_validate_subjects`.
- The run: confirm the details step runs when the role set is unchanged — find where the mover run applies `account_details` (`plan_ad` / `plan_entra`) and that it isn't inside the "primary changed" / `_move_with_primary` path.
- `GET /access-requests/mover-details`: `primary` is already optional; with none, it returns current values and no defaults. Good as is.

**Frontend**
- `access/RaiseRequestModal.tsx`: `details` is rendered under `primaryChanged` (~line 835) and the details query is keyed on the changed primary (~line 189, 777). Show the section whenever a person is chosen; pass the primary only when it changed.
- `MoverAccountDetails.tsx` / `moverDetails.ts`: the "changed" set is already "differs from what the account says"; make sure an untouched form sends **no** details rather than every current value.
- `complete` for a mover (~line 286): true when roles differ **or** any detail differs. The "this removes all their roles" confirm (~line 329) must not fire for a details-only move.
- Request page (`RequestDetailPage.tsx`): a details-only move has no role before/after to show — it should read as "Roles: unchanged", not as an empty or alarming diff.
- A long list (an admin can choose 30+ fields) — check the modal scrolls sensibly with the section always open.
- OpenAPI drift script (the 422 leaves the route's contract; docstring changes drift `schema.d.ts`).

## Done when

- [ ] Open a move for a person: Account details shows, filled with current values, before any role is touched.
- [ ] Change only the job title and manager, raise, approve: both are changed in the directory, the roles and groups are untouched, the account hasn't moved OU.
- [ ] The request page shows the two details before → after and says the roles are unchanged.
- [ ] Changing nothing leaves Raise disabled with a reason.
- [ ] Changing the Primary role still offers that role's defaults.
- [ ] An approver correcting a detail at the gate on a details-only move keeps the other details.
- [ ] ADR accepted.
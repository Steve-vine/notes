---
id: 01M4DW6ATAYW7MHNHYEKBZ76MF
created: 2026-10-08T13:45:37.866001Z
updated: 2026-10-08T13:45:42.992465Z
type: task
title: A leaver request sets the leave date on the person's Entra account — and the user's record shows it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 868
sprint: sme8esk
blocked_by:
- 01M4DVPERSX4PXNJ1VGMFB1EMM
assignee: steve
label:
- feature
priority: low
task_status: todo
---
Asked for by Steve, 2026-10-08. Entra holds a **leave date** on each account (`employeeLeaveDateTime`) — the date the person left, or is due to leave, the organisation; the counterpart of the hire date. Compass runs the leaver, so Compass should stamp it, and hold it in the mirror with the rest (COM-863).

**Blocked by COM-867** (the mirror's read-only facts and where they show on a user's record), and so by COM-863 and COM-866.

## What people see

- **When a leaver request runs, the person's Entra account gets its leave date** — the request's "Run at" time if it had one, otherwise the moment it ran. Nobody types a date; there is no new field on the leaver form. (Assumption, mine — say if a separate "last working day" is wanted instead.)
- The request's notes say so: "Leave date set to 14 Oct 2026".
- **A user's record shows Leave date**, beside the hire date, once the mirror has it.
- A retried leaver doesn't move a leave date it already set.
- **If Compass hasn't been given the permission**, the leaver carries on exactly as today and its notes say "Leave date not set — Compass hasn't been granted permission to set it". No to-do is raised, nothing fails. Admin ▸ Integrations names the missing permission as optional, not as a fault.
- Active Directory has no leave date. In an AD-only setup none of this appears.

## Steve's side

Grant the Entra app registration **`User-LifeCycleInfo.ReadWrite.All`** (application permission, admin consent). Microsoft keeps the leave date behind its own permission — `User.ReadWrite.All` does not cover it. After granting, the worker needs a restart before it takes effect (the token is cached — the health card goes green first).

## Prove first

**Can it be set on a synced account?** 93% of the estate is synced from AD, and the cloud refuses most writes to a synced account. The leave date is not one of the attributes AD normally supplies, so Graph may accept it — but this is not confirmed. Before building, PATCH `employeeLeaveDateTime` on one synced test account on staging with the permission granted.
- Accepted → set it for every Entra account, synced or not.
- Refused → set it for cloud-only accounts; for a synced one the notes say "Leave date not set — this account is managed in Active Directory", and tell Steve, because that makes this task worth much less than it looks.

## How (implementation)

**The write.** In the leaver run (`tasks/access_execute.py`, `_leaver_disable` — beside `revokeSignInSessions`, which already runs for every account that exists in Entra): `PATCH /users/{id}` with `{"employeeLeaveDateTime": "<ISO 8601 UTC>"}`. Value: `request.scheduled_for` or now. Read the current value first and leave it if already set (idempotent retry; and a date somebody set by hand is theirs). Ledger entry + note, as the other leaver steps do. Follow the routing rule: decide from configuration (is the permission granted?) *before* the write; a write-time error with the permission granted is "broke" → Failed + Retry like any other step, not a silent skip.

**The permission is optional.** Every entry in `REQUIRED_ENTRA_APP_ROLES` (`core/graph.py:540`) fails the health check when missing; adding this there would turn every existing install's card red. Add a separate optional set, reuse the same consented-roles lookup the health check does (`graph.py:448–471`), and have the card list an ungranted optional permission with what it would enable. Cache the answer with the health result so the leaver run doesn't look it up per person.

**The mirror.** Add `employeeLeaveDateTime` to the read-only list (COM-867) under Details/Account state, kind date — **only while the permission is granted**. Check what Graph does when it is in `$select` without the permission (null, or a 403 for the whole page?) and on `/users/delta`; the sync must never fail because an optional grant is missing. Because the attribute list is fingerprinted (COM-863), granting the permission changes the list and forces the one full pass that fills it. Compass's own write patches the mirror straight away, like any other detail it sets.

**Delete after N days.** A leaver's account may be deleted later (`delete_after_days`); the leave date goes with it. Nothing to do — but the mirror blanks a vanished person's details (COM-863), so the record stops showing it then too.

OpenAPI drift script if the health card's schema gains the optional list.

## Done when

- [ ] Synced-account question answered on staging and recorded here.
- [ ] A leaver run on staging sets the leave date; the notes say so; Entra shows it.
- [ ] A scheduled leaver gets its "Run at" time, not the time it was approved.
- [ ] A retry leaves the date alone.
- [ ] Without the permission: the leaver completes, the notes say why the date wasn't set, the Entra card lists the permission as optional, and the directory sync still runs clean.
- [ ] The user's record shows Leave date within 15 minutes of a change made in Entra, and immediately after Compass sets it.
- [ ] AD only: no leave date anywhere, no Graph call attempted.
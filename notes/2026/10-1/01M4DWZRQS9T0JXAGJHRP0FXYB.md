---
id: 01M4DWZRQS9T0JXAGJHRP0FXYB
created: 2026-10-08T13:59:31.321818Z
updated: 2026-10-08T15:11:24.399357Z
type: task
title: The move form lists only the groups the move will really remove — not every role-granted group the person happens to be in
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 871
sprint: sme8esk
comments:
- id: 01M4DYNS84DAZ2QXMBN9EA343H
  author: Steve Vine
  at: 2026-10-08T14:29:01.315851Z
  text: 'Follow-ons on the same form, asked for by Steve 2026-10-08, all waiting on this task: COM-872 (Account details always shown; a details-only move), COM-873 (sections renamed; remove/restore manual groups), COM-874 (add a group). The heading rename to "Membership diff (managed groups)" and "Manual groups (n)" belongs to COM-873, not here. Build the widened mover-preview response with COM-873/874 in mind: it will also carry each manual group''s description, why it is held, and whether it can be removed.'
assignee: steve
label:
- bug
priority: high
task_status: active
---
Found by Steve testing access control on staging, 2026-10-08 (`4131ac79`): "On the mover request, before any new role is even selected, there are quite a few groups listed for removal — is this because they're associated with business roles that the user isn't in?"

## What happened

Open a move request for a person and, before anything is changed, **Membership diff (managed groups only)** already shows a row of red "− group" badges.

## Why — Steve's reading is right

The red list is every group the person is in that **some** business role in the company grants, minus the groups granted by the roles in the form's two fields. So a person who is in a group that belongs to a role they don't hold — put there by hand, or before roles existed — sees it listed for removal, on every move, before they touch anything.

## And the list is wrong

**The request will not remove those groups.** When a move runs, a membership goes only if Compass recorded it as *granted by a role the person is losing*. A membership in a role's group that the person holds some other way — unexplained, or an approved exception — is kept, and named in the request's notes as kept. That rule replaced exactly this sweep (ADR 0061 §3, COM-448); the form was never brought into line.

So today the form:
- shows removals that won't happen — with nothing changed, the run removes nothing at all;
- files those groups under "to be removed" when they belong under "this move leaves them as they are", which the form does have (COM-855) but only fills with groups no role grants;
- may put someone off raising a move, or let an approver believe access was taken away that is still there.

## Cause

`access/RaiseRequestModal.tsx`, `MoverDiff` (~line 747–760): computed in the browser as

```
desired        = groups of the roles in the form
currentManaged = the person's groups where `managed` is true
removes        = currentManaged − desired
```

`managed` (from `GET /directory/users/{id}/groups`, `api/v1/directory.py:934`) means "mapped to any business role of this company" — nothing to do with whether *this person* holds it through a role.

The run (`tasks/access_execute.py:1597–1610`) uses `business_role_holdings.plan_mover`: remove where provenance is role-derived **and** the granting role is one the person no longer holds; keep exceptions; keep unexplained unless the request explicitly drops them (the form offers no way to drop one today).

## Fix

One rule, asked of the server, used by both — the form must not re-derive it.

- Extend the existing `GET /access-requests/mover-preview` (it already takes the person and the chosen primary) to take the full role set and return what `plan_mover` would decide: **adds**, **removes**, **kept exceptions**, **kept unexplained**. Reads only; same function the run calls, so the two cannot drift again.
- The form shows adds and removes from that answer. Groups that are role-granted somewhere but kept go under the existing "leaves them as they are" block with their Unexplained / Exception badge (`MoverStayingGroups.tsx` — its filter is `!group.managed`, which is what hides them today).
- With nothing changed, the diff reads "No managed-group changes."
- Check the request page the approver sees (`RequestDetailPage.tsx`) — if it draws its own before/after from the same `managed` flag, it has the same fault; fix it from the same source.
- Removals the run would turn into a to-do or refuse (on-premises, privileged — `_writable_group_ids`) are out of scope unless trivial; note what the preview does with them.
- OpenAPI drift script; page tests that stub `/access-requests/mover-preview` need the wider shape.

## Done when

- [ ] Opening a move for a person and changing nothing shows no removals.
- [ ] Taking a role away lists exactly the groups that role granted them — and after the request runs, exactly those are gone (checked on staging against one person).
- [ ] A group some other role grants, which the person holds unexplained, is shown as staying, with its badge — never in red.
- [ ] An approved exception is shown as staying.
- [ ] The approver's view of the request agrees with the form.
- [ ] Test: the form's lists come from the preview response; no set arithmetic on `managed` remains in `MoverDiff`.
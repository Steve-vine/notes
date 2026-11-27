---
id: 01M8EJKFE8BWRYP2MP0AB83A12
created: 2026-11-27T13:20:04.5521Z
updated: 2026-11-27T13:24:05.805092Z
type: task
title: Adopt unrequested changes automatically (privileged changes excepted) — a switch on Access Control ▸ Admin, with the choice to adopt everything already waiting
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2189
sprint: smq8t5s
assignee: steve
label:
- feature
priority: high
task_status: todo
---
**On the chain** (migration for the setting and an "adopted automatically" mark; API). Independent of the rest of sprint 128.

Steve's decision (27 Nov 2026): until everyone holds business roles, access is still kept up to date by hand in AD and Entra. That produces a constant stream of unrequested changes needing validation. He wants Compass to adopt them by default while that's the case, and to be able to clear the backlog in one go. **Privileged changes are left out**: they always wait for a person to validate them.

## What people see
- **The switch:** **Access Control ▸ Admin ▸ Validation** gains **Adopt unrequested changes automatically**, under *What Compass watches*.
  - It's off by default. Anyone who can explain or reverse unrequested changes can switch it.
  - The switch's description says: "Privileged changes still need validating: directory roles, groups that grant Entra roles, and AD's protected admin groups and accounts."
- **What counts as privileged** (never adopted automatically):
  - a person gaining or losing an **Entra directory role**;
  - a membership change to a **group that grants an Entra role**;
  - a change to a **group or account AD protects**: Domain Admins, Enterprise Admins, Schema Admins, Administrators, Account Operators and the other built-in admin groups, groups nested in them, and their members' accounts.
- **Switching it on** asks for confirmation: "Turn on automatic adoption? From now on every unrequested change is adopted as soon as Compass finds it, apart from privileged ones. There are **37** waiting now (**5** of them privileged, which will still need validating) — adopt the other **32** too?" There are three buttons:
  - **Yes, adopt the 32 and turn on**
  - **Turn on, leave them all for review**
  - **Cancel**
- **While it's on:**
  - Each new unrequested change that would need validation, and isn't privileged, is **adopted the moment Compass finds it**, with the comment "Adopted automatically — automatic adoption switched on by Steve Vine on 27 Nov 2026".
  - It never appears in anyone's Actions and never goes overdue.
  - It stays visible on Validation under the adopted changes, marked **Adopted automatically**, so the record of what changed outside Compass is complete.
  - **Privileged changes** are raised exactly as today: in *Unrequested changes*, in Actions, with their due date.
- **Banner:** a yellow line at the top of Validation while it's on: "Unrequested changes are being adopted automatically, apart from privileged ones — switched on by Steve Vine on 27 Nov 2026." The Admin switch shows the same.
- **Switching it off** goes back to today's behaviour for new changes. Items already adopted stay adopted.
- **Activity log:** switching on, switching off, and "adopted 32 waiting changes" are all recorded. Each automatic adoption is recorded against the item as made by Compass under the setting, never as a person.
- **Unchanged:**
  - What Compass watches: the per-kind switches still decide what's raised at all.
  - Trusted accounts (COM-902).
  - *For information* changes, which never needed validating.
  - Adopting changes nothing in AD or Entra. To undo something adopted, raise a normal request.

## Notes (technical)
- **Setting:** stored with the watch configuration (`models/unrequested_watch.py` / `core/unrequested_watch.py`), with who switched it on and when. API beside `api/v1/unrequested_watch.py`. Read needs access view; change needs `access.review_unrequested`. The preview for the dialog returns the waiting count and the privileged count; the bulk adopt returns the number adopted.
- **"Privileged" — one helper,** in `core/privileged_access.py` beside the existing "what counts as privilege" rules, so every surface agrees:
  - kinds `directory_role_gained` / `directory_role_lost`;
  - a membership item whose group grants an Entra role (`is_assignable_to_role`, or granting roles in the mirror);
  - an item whose group or account is AD-protected.
  - **AD protection:** until COM-2179 lands, match the built-in protected groups by their well-known AD location and name (CN=Builtin, and the admin groups in CN=Users), plus groups nested in them, from the AD mirror. Once COM-2179 lands, use its protection marker. Leave a note to switch over.
- **Where it acts:** where an `UnrequestedChange` is created in the `needs_validation` lane (`tasks/directory_sync.py`, `mailbox_sync.py`, `list_sender_sync.py`, `ad_sync.py`).
  - If the setting is on and the item isn't privileged, transition straight to `adopted`, with `validated_at` now, `validated_by` null, `auto_adopted = true`, and the comment above.
  - `adopt_item` today requires a person; add a system path rather than faking a user.
- **Bulk adopt on switching on:** every open `pending_validation`, non-privileged item in the `needs_validation` lane, in one transaction, the same marking, with one activity entry carrying the count.
- **Actor lookup:** the later actor lookup (`enrich_actors`) still fills "Changed by" on auto-adopted items, so evidence keeps who made the change. Check it doesn't only look at `pending_validation` items, or widen it.
- **Polaris:** read tools say an item was adopted automatically and that the setting is on. Switching it stays on screen.
- **Evidence:** export and validation evidence show "adopted automatically under the setting switched on by X on date".

**Done when:** on staging:
- Switching it on with waiting changes offers to adopt the non-privileged ones and names how many privileged ones stay; **Yes** clears only those, marked *Adopted automatically*.
- A new ordinary unrequested change found while it's on is adopted at once and never reaches Actions. A new directory-role change still appears for validation.
- Switching it off brings back normal validation for the next one.
- The banner and the activity log entries appear.
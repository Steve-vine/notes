---
id: 01M8EJKFE8BWRYP2MP0AB83A12
created: 2026-11-27T13:20:04.5521Z
updated: 2026-11-27T13:20:10.833308Z
type: task
title: Adopt unrequested changes automatically — a switch on Access Control ▸ Admin, with the choice to adopt everything already waiting
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

Steve's decision (27 Nov 2026): until everyone holds business roles, access is still kept up to date by hand in AD and Entra. That produces a constant stream of unrequested changes needing validation. He wants Compass to adopt them by default while that's the case, and to be able to clear the backlog in one go.

## What people see
- **The switch:** **Access Control ▸ Admin ▸ Validation** gains **Adopt unrequested changes automatically**, under *What Compass watches*. It's off by default. Anyone who can explain or reverse unrequested changes can switch it.
- **Switching it on** asks for confirmation: "Turn on automatic adoption? From now on every unrequested change is adopted as soon as Compass finds it. There are **37** waiting now — adopt those too?" There are three buttons:
  - **Yes, adopt all 37 and turn on**
  - **Turn on, leave the 37 for review**
  - **Cancel**
- **While it's on:**
  - Each new unrequested change that would need validation is **adopted the moment Compass finds it**, with the comment "Adopted automatically — automatic adoption switched on by Steve Vine on 27 Nov 2026".
  - It never appears in anyone's Actions and never goes overdue.
  - It stays visible on Validation under the adopted changes, marked **Adopted automatically**, so the record of what changed outside Compass is complete.
- **Banner:** a yellow line at the top of Validation while it's on: "Unrequested changes are being adopted automatically — switched on by Steve Vine on 27 Nov 2026." The Admin switch shows the same.
- **Switching it off** goes back to today's behaviour for new changes. Items already adopted stay adopted.
- **Activity log:** switching on, switching off, and "adopted 37 waiting changes" are all recorded. Each automatic adoption is recorded against the item as made by Compass under the setting, never as a person.
- **Unchanged:**
  - What Compass watches: the per-kind switches still decide what's raised at all.
  - Trusted accounts (COM-902).
  - *For information* changes, which never needed validating.
  - Adopting changes nothing in AD or Entra. To undo something adopted, raise a normal request.

## Notes (technical)
- **Setting:** stored with the watch configuration (`models/unrequested_watch.py` / `core/unrequested_watch.py`), with who switched it on and when. API beside `api/v1/unrequested_watch.py`. Read needs access view; change needs `access.review_unrequested`. The bulk adopt returns the count, for the dialog.
- **Where it acts:** where an `UnrequestedChange` is created in the `needs_validation` lane (`tasks/directory_sync.py`, `mailbox_sync.py`, `list_sender_sync.py`, `ad_sync.py`).
  - If the setting is on, transition straight to `adopted`, with `validated_at` now, `validated_by` null, `auto_adopted = true`, and the comment above.
  - `adopt_item` today requires a person; add a system path rather than faking a user.
- **Bulk adopt on switching on:** every open `pending_validation` item in the `needs_validation` lane, in one transaction, the same marking, with one activity entry carrying the count.
- **Actor lookup:** the later actor lookup (`enrich_actors`) still fills "Changed by" on auto-adopted items, so evidence keeps who made the change. Check it doesn't only look at `pending_validation` items, or widen it.
- **Polaris:** read tools say an item was adopted automatically and that the setting is on. Switching it stays on screen.
- **Evidence:** export and validation evidence show "adopted automatically under the setting switched on by X on date".

**Done when:** on staging:
- Switching it on with waiting changes offers to adopt them; **Yes** clears them, marked *Adopted automatically*.
- A new unrequested change found while it's on is adopted at once and never reaches Actions.
- Switching it off brings back normal validation for the next one.
- The banner and the activity log entries appear.
---
id: 01M8EJKFE8BWRYP2MP0AB83A12
created: 2026-11-27T13:20:04.5521Z
updated: 2026-11-27T20:09:12.631007Z
type: task
title: Adopt unrequested changes automatically (privileged changes excepted) — a switch on Access Control ▸ Admin, with the choice to adopt everything already waiting
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2189
sprint: smq8t5s
comments:
- id: 01M8F3AB3PBQRET5H8P8DBA2F9
  author: Steve Vine
  at: 2026-11-27T18:12:10.99814Z
  text: |-
    Done — merged to main in PR #2194 (ADR 0186). Not on staging yet; it goes with the sprint.

    What changes:
    - Access Control ▸ Admin ▸ What Compass watches has a new switch, Adopt unrequested changes automatically. It's off by default. Anyone who can explain or reverse unrequested changes can switch it.
    - Switching it on asks first. It says how many changes are waiting and how many of those are privileged, and offers:
      - "Yes, adopt the N and turn on"
      - "Turn on, leave them all for review"
      - Cancel
      If nothing non-privileged is waiting, it offers just Turn on / Cancel.
    - While it's on, each new unrequested change that isn't privileged is adopted the moment Compass finds it. It's marked "Adopted automatically — automatic adoption switched on by <name> on <date>". It never reaches Actions and never goes overdue.
    - Privileged changes still wait for a person, as today. Privileged here means:
      - directory roles;
      - groups that grant an Entra role, including creating or deleting one;
      - groups or accounts AD protects, e.g. an admin account added to an ordinary group.
      This is a little wider than your text, on purpose: the cost of a mistake is an admin change adopted unseen.
    - Validation shows a yellow banner while it's on, and has a new Adopted changes section. It lists changes adopted by a person (with their name) and those adopted automatically. The section is always shown.
    - The activity log records switching on, switching off, "adopted N waiting unrequested changes automatically", and each automatic adoption as made by Compass.
    - The setting covers every company, so the counts and "adopt what's waiting" are tenant-wide.
    - Switching it off keeps what was already adopted.

    Notes:
    - The ADR is 0186. 0185 went to the Scripting sprint, whose ADR has landed on main.
    - Polaris reads show "Adopted automatically" and report the setting.

    Checks:
    - New integration tests cover:
      - who may switch it;
      - the dialog counts;
      - adopting only non-privileged waiting changes;
      - new changes adopted, with each privileged kind still raised;
      - not in Actions;
      - switching off;
      - the log lines;
      - Polaris.
    - Frontend tests cover the dialog, the banner and the Adopted changes section.
    - Unit suite and the unrequested-change suites (46) pass.
    - All CI jobs passed. One unrelated registers test flaked on its first run and passed on rerun.

    For Steve to check: the wording above, and that the wider "privileged" rule is what you want.
- id: 01M8FA0M5P6P53XTGN6KMTDN1D
  author: Steve Vine
  at: 2026-11-27T20:09:12.630536Z
  text: |-
    Pre-UAT on staging 30786db4f: Passed (the switch, its dialog, Cancel, and the Adopted changes section); Couldn't check (switching it on and what follows).

    Steps and what I saw, as E2E Admin A:
    - Access Control ▸ Admin ▸ What Compass watches: the switch "Adopt unrequested changes automatically" is off. Under it: "Privileged changes still need validating: directory roles, groups that grant Entra roles, and AD's protected admin groups and accounts."
    - Clicking the switch opens "Turn on automatic adoption?": "From now on every unrequested change is adopted as soon as Compass finds it, apart from privileged ones. There are 364 waiting now (27 of them privileged, which will still need validating) — adopt the other 337 too?" The buttons are Cancel, "Turn on, leave them all for review" and "Yes, adopt the 337 and turn on". I pressed Cancel, and the switch stayed off.
    - Validation has no banner, which is right while it's off. It has a new "Adopted changes" section (54): "Unrequested changes someone explained and adopted, and those Compass adopted automatically while that was switched on." The rows show "Observed … — adopted …", who made the change, and the comment ("OK").
    - Small point: the rows say "adopted 5 Sep 2026, 14:42" with no "by <name>". The build comment says person-adopted rows carry their name. These older items may simply not record who adopted them; worth a glance.

    Couldn't check (each would adopt real items in the tenant-wide queue):
    - Yes clearing only non-privileged items, marked "Adopted automatically";
    - new changes adopted at once, with a directory-role change still raised;
    - switching it off;
    - the banner;
    - the activity-log lines.

    Screenshots: ~/compass-uat/sprint-128/COM-2189/ (01 the switch, 02 the dialog, 03 Adopted changes).
assignee: steve
label:
- feature
priority: high
task_status: review
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
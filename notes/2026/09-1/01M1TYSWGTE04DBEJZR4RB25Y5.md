---
id: 01M1TYSWGTE04DBEJZR4RB25Y5
created: 2026-09-06T08:54:17.882445Z
updated: 2026-09-06T11:54:40.475154Z
type: task
title: work can be taken but never given — there is no way to assign anything to a colleague
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 575
sprint: s2fcksg
comments:
- id: 01M1V944VB36X8N4ZKS424J6N1
  author: Steve Vine
  at: 2026-09-06T11:54:39.850917Z
  text: |-
    Done — PR #585, merged to main.

    Who a record may be given to is now the permission that already governs writing it: an assessment to `posture.record_assessments`, a gap to `posture.manage_gaps`, a risk and its treatment plans to `posture.manage_risks`, a vendor review action to `vendors.manage_register`.

    `GET /users/directory` gained a `permission=` filter rather than a second endpoint — it is already `require_internal` and already serves the narrow id/name/job-title payload, so an assessor can call it from the screen they are assessing on. The answer is derived from the permissions a person's roles carry, never role names. An unknown permission is refused with a 422 rather than quietly returning everybody, so a typo in a picker cannot publish the staff list. As the task predicted, the portal question settled itself: vendor contacts hold no posture permission.

    One `OwnerPicker` (form) / `OwnerSelect` (table cell) now serves the assessment panel, risk detail, the add-treatment dialog, the vendor review-action dialog, and the Gaps screen. Gaps needed the most: it showed an owner and would not let you change it at all, not even to yourself.

    Two decisions worth recording:

    - **Assign to me stayed.** One click for the common case, as the task asked.
    - **An owner who loses the permission keeps the work.** The picker stops offering them, but the record goes on naming them — resolved from the *full* directory rather than the permission-filtered one, so a role change never makes an owned record read as unowned. There is a test pinning that.

    The Gaps Owner column now names the person. It read "You", "Unassigned", or — for anybody else — the word "Assigned", which is not something remediation can be chased with; COM-576 notes the same problem from the gap page's side.

    **Vendor detail was one place, not two.** The vendor's own owner picker already existed and is governed by the ADR 0049 §6 ownership rule via `can_own_vendors` — a different and correct question — so it is untouched. The review-action dialog was the one that only offered "Assign to me".

    On the notification question the task left open: checked, and nothing new was added. The actions queue and the digest already carry newly-owned work to its owner (ADR 0055), so a second channel would have been duplicate mail.

    Backend tests hit real Postgres; full frontend suite green.
assignee: steve
label:
- feature
priority: high
task_status: review
---
Found by Steve on staging, 2026-09-06, on the assessment panel — and it is not confined to controls.

**Nothing in Compass can be assigned to another person.** Every ownership control in the app offers exactly two things: *Assign to me*, and clear. You can claim work or drop it; you cannot give it to a colleague. Accountability has to be volunteered.

That is the case on the **assessment panel** (Steve's report), on a **risk** in two places, and on a **vendor** in two more. **Gaps are worse**: the Gaps screen shows an owner column and offers no way to change it at all, not even to yourself — status and target date are editable there, ownership is read-only.

**The API has always supported it.** Assessments, gaps and risks all accept any user as the owner, on create and on update. This is a missing picker, not a missing capability — which is why it is one task rather than five.

## Why this matters more than it looks

Ownership is not decoration here. The Actions queue has an Owner column and an "Owned by me" filter; the nightly mail chases owners by name; unowned work is attributed to a whole module precisely because nobody has taken it (ADR 0055 §4). The entire chasing apparatus assumes somebody can be made accountable for a piece of remediation — and today the only person who can do that is the person volunteering.

For a governance tool, "the manager cannot assign the remediation" is close to the centre of the job.

## Who is assignable

**Steve's call, 2026-09-06: whoever holds the appropriate permission.** Stated as a rule that needs no list maintaining: *a record may be assigned to anyone who holds the permission that already governs writing that record.*

- a control assessment → `posture.record_assessments`
- a gap → `posture.manage_gaps`
- a risk → `posture.manage_risks`
- a vendor → whatever already gates editing the vendor; take it from the write guard rather than naming a constant here.

So the picker is **per subject, not one global list**, and it must be computed from the permissions a person's roles actually carry — roles are admin-defined now (ADR 0067), so any hardcoded role name goes stale the first time somebody edits one.

This also disposes of the portal worry for free: vendor contacts and portal users hold no posture permission, so they cannot appear against a company's governance record. Nothing extra to exclude.

## The constraint that shapes the build

**The existing users endpoint cannot back this picker.** `GET /users` is gated on `admin.manage_users` and returns every account — so an assessor with `posture.record_assessments` would get a 403 from the very screen they are assigning on, and an admin would get vendor contacts in the list.

What is needed is a small, narrowly-scoped endpoint: *who holds this permission* — id and display name only, nothing else about the account — callable by anyone entitled to edit the subject they are assigning. The query is already expressible: accounts, through their roles, to the permissions those roles carry. Active accounts only.

**An owner who later loses the permission keeps the work.** The picker stops offering them; nothing reassigns or clears retrospectively. Silently dropping an owner because their role changed would remove accountability without anybody deciding to — and the record would then read as unowned when it is not.

## What changes

One shared owner picker, used everywhere ownership is shown:

- **The assessment panel** — the reported case, and the one to build against.
- **Risk detail** (two places), **vendor detail** (two places) — the same three lines each; do them in the same pass or the identical complaint arrives one screen later.
- **The Gaps screen** — needs an assign control where today there is none.

*Assign to me* stays. It is the common case and it is one click; a picker that makes claiming your own work a three-step search would be a downgrade.

Assigning work to somebody is also a thing they should learn about. Whether that means a notification is a judgement call — the actions queue and the digest already carry newly-owned work to its owner, so it may already be covered. Check before adding a second channel.

## Related

- ADR 0055 §4 — unowned work is real work; ownership is what the chasing hangs on.
- ADR 0067 — roles are combinations of permissions an admin defines, which is why the list is derived from permissions rather than role names.
- COM-564 / COM-566 / COM-568 / COM-569 / COM-570 — the same panel.

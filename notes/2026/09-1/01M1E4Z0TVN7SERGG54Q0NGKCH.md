---
id: 01M1E4Z0TVN7SERGG54Q0NGKCH
created: 2026-09-01T09:31:49.979044Z
updated: 2026-09-01T09:31:58.825775Z
type: task
title: the portal boundary means the same thing on both screens that can cross it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 557
sprint: sz42uhw
assignee: steve
company: null
label:
- improvement
priority: high
task_status: todo
---
Spotted by Steve on staging, 2026-09-01: Recertifier (Portal), Vendor Approver (Portal) and Vendor Contact (Portal) are greyed out on Admin → Users and cannot be added or removed — but the same three can be added and removed freely on the Entra group → role mapping panel.

Both halves are deliberate, and each is defensible on its own. Granting a portal role to one person is owned by the screen that owns the relationship — the vendor, the approval area, the recertification — not by the Users screen. Conferring one by group membership is how a whole department of vendor contacts gets provisioned at all, which is the mapping's whole job.

Put side by side, the pair is wrong in two ways.

**It leaves the boundary open where it matters most.** ADR 0067 §3 makes portal access structural because "one mis-tick would put an outside vendor inside internal Compass". The Users screen enforces that one person at a time. The mapping panel enforces nothing — and one edit there moves *everybody* in a group. Worse, it does it without friction: mappings get a confirmation step when the roles confer a dangerous or Access Control permission, and a portal role confers almost no internal permissions, so it sails through the check that exists. The screen with the larger blast radius is the one asking fewer questions.

**And the Users screen never says why.** Three options greyed out with no explanation is indistinguishable from a broken control — which is exactly how Steve read it. A refusal that cannot be understood gets reported as a bug every time.

## Decision to make

**Proposed: keep the mapping's power, make it deliberate.** Provisioning a department of vendor contacts by group is a real need and should stay. What it should not be is quiet:

- A mapping that confers a portal role is treated as privileged in its own right — the confirmation step already exists, it just isn't asked here — and says plainly what it does: *everyone in this group is an outside user; they reach the vendor portal and never internal Compass.*
- The mapping list marks those mappings so a portal group is legible at a glance among the internal ones.
- The Users screen keeps its refusal and explains it: greyed out because this role is granted from the vendor, approval-area or recertification screen, with a pointer to which one.

The alternative is to refuse portal roles on the mapping panel too, and provision vendor departments some other way. That closes the boundary completely, and I do not think it is right — it removes the only bulk route in and replaces it with nothing.

## Implementation

- `sso_mappings.py`: `_is_privileged` asks the roles' *permissions*, which is why a portal role slips past it. Add "confers a portal role" as a second reason to require confirmation, and give it its own wording — the current copy talks about dangerous permissions, which is not what this is.
- `_confirm_privileged` already names the blast radius (the roles granted, the count of affected users); a portal mapping should say the count too, since that is the number of people being moved outside.
- `admin/UsersSection.tsx` / `roleHooks.ts`: the picker already receives `is_portal`; it needs to carry the reason to the option so the grey has a tooltip rather than being silent.
- Worth checking the reverse case while in there: what happens to an internal colleague who is in a group mapped to a portal role — the derived-roles recompute would hand them a portal grant and, if it is their only one, put them on the outside. That is the mis-tick ADR 0067 §3 describes, arriving through the door this task is about.

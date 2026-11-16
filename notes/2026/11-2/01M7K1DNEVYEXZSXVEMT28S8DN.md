---
id: 01M7K1DNEVYEXZSXVEMT28S8DN
created: 2026-11-16T20:40:18.651297Z
updated: 2026-11-16T20:40:21.990535Z
type: task
title: Fields left out as sensitive are shown in the fields editor, and an administrator decides them
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1877
sprint: s7nqsy0
assignee: steve
priority: medium
task_status: backlog
---
From Steve's testing of round 2 (staging 43d03f09).

**What Steve asked for.** "Fields left out as sensitive shouldn't be a decision that only Polaris can make, these need to be accessible in the fields editor so the Admin user can make the decision." Today Polaris decides which fields are sensitive when it designs a check. Those fields are never offered in the fields editor, so nobody can see or change them on screen.

**Behaviour** (assumptions decided here, not by Steve)
- The fields editor lists every field the service returned, including the sensitive ones. A sensitive field has a **Sensitive** marker that says who decided it: "Polaris, when the check was designed" or "<person> on <date>: <reason>".
- **An administrator can:**
  - clear the marker so the field can be kept, giving a reason;
  - mark any other field sensitive, so it is left out from the next capture, giving a reason.
  Anyone else who can edit the check sees the markers but can't change them. A sensitive field can't be ticked to keep until its marker is cleared.
- **It takes effect from the next capture**, like any change to the fields kept. Past captures are not changed: a field left out was never kept, and one newly marked stays in captures already filed.
- **Recorded.** There's an Activity line on the check for each change, with the reason.
- **Polaris.** Polaris still suggests sensitive fields when it designs a check, and the person approving sees them at Review and can accept or untick them there. Polaris can't clear a marker on a live check.

**Done when**
- The behaviour above works on staging, both for a check whose sensitive fields were set by Polaris and for one an administrator marks by hand.
- The Review screen shows Polaris's suggested sensitive fields, and they can be changed before approval.
- An ADR 0142 amendment records that sensitive fields are a person's decision (an administrator's), with Polaris only suggesting them.
- Tests cover: an administrator clears and sets a marker; someone who isn't an administrator is refused; a sensitive field can't be kept; and a change applies from the next capture.

**Where** (for the builder): collection/EditFields.tsx (today `gone = check.left_out` hides them), api/v1/collected_checks.py (`left_out`, PATCH), the Review screen (collection/CollectionCard.tsx), Polaris collection tools and instructions.
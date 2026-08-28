---
id: 01M153AFZXQAKD75PMWP1Q5BX6
created: 2026-08-28T21:09:58.909966Z
updated: 2026-08-28T21:10:29.602362Z
type: task
title: Mirror conditional access policies
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 501
sprint: s5cyp1z
assignee: steve
company: null
label:
- feature
priority: medium
task_status: todo
---
The rules that decide whether a sign-in is allowed — the controls a framework assessment claims credit for, and which Compass has never read.

Mirror each policy: name, **state** (enabled, disabled, or report-only), created and last modified, and the shape of the rule — who it includes and excludes (users, groups, roles, guests), which applications it covers, the conditions (platforms, locations, client apps, sign-in risk), and what it grants or blocks (MFA required, compliant device required, block access), plus its session controls.

Needs **`Policy.Read.All`**, a new grant with the same consent-then-restart caveat as COM-498.

**Store the rule as Graph reports it, and interpret it in the catalogue — never at sync time.** The condition grammar is Microsoft's and it changes; a mirror that flattens *what this policy means* into a few columns is a translation that will be wrong quietly. Keep the structure, and derive the fields reports need (*does it require MFA*, *does it exclude anybody*, *how many users are excluded*) where they can be corrected without a resync.

The **excluded** principals are the point of mirroring this at all. Every real tenant has a break-glass account and a handful of exceptions nobody has revisited, and a list of them is the report an auditor asks for by name.
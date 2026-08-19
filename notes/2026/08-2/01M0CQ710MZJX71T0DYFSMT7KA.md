---
id: 01M0CQ710MZJX71T0DYFSMT7KA
created: 2026-08-19T09:56:35.988551Z
updated: 2026-08-19T09:56:35.988551Z
type: task
title: New group request — Description and Owner become required
assignee: steve
task_status: todo
label: improvement
priority: medium
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 277
---
On the `group_create` request, **Description** and **Owner** are now required — this settles the question COM-262 left open (it defaulted owner to optional pending Steve's call; the call is made: required).

* Raise-form validation plus the API contract (422) — and since COM-276 makes creation land straight in `pending_approval` with full validation, these rules live in the create contract itself; there is no half-formed draft to hide in.
* The COM-260 gate editors inherit the same constraints: an approver or validator can change the description or owner but never clear them — a gate edit can't produce what a request couldn't (the rule COM-260 already states, now with two more fields behind it).
* Applies to both approval modes; the expedited form requires them too — incident haste is exactly when groups get created with no description and no owner, which is the mess recert and the COM-244 adoption flow are left to clean up. That's the *why*: a described, owned group at birth is what makes the downstream governance (campaign assignment via COM-264, sensible audit labels, meaningful validation) actually work.
* Out-of-band adopted groups (COM-244) aren't blocked by this — they arrived ungoverned by definition — but the adopt flow should nudge for the missing description/owner as part of amend-and-validate.

Refs: COM-262 (owner picker — the field this makes mandatory), COM-258 (the owner-required precedent on business roles), COM-260 (gate editing), COM-276 (validation at creation), COM-264 (why owners matter).
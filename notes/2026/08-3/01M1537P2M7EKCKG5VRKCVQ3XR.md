---
id: 01M1537P2M7EKCKG5VRKCVQ3XR
created: 2026-08-28T21:08:26.836101Z
updated: 2026-08-29T10:15:46.886957Z
type: task
title: 'Who has MFA: mirror authentication method registration'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 497
sprint: s42ntc9
comments:
- id: 01M16G98XVCGBGWXBP9NMTH8PN
  author: Steve Vine
  at: 2026-08-29T10:15:44.826728Z
  text: |-
    Done and merged to main — PR #497.

    `directory_user_auth_methods`, keyed by the directory user, holding is_mfa_registered / is_mfa_capable (kept apart, as the task asked), is_passwordless_capable, the SSPR trio, methods_registered as a list, default_method, and observed_at. Fed by tasks/auth_methods_sweep.py on its own hourly beat entry.

    The "a user with no row is unknown, never no MFA" rule is carried by the table shape rather than by convention: presence of a row is the signal, so there is no boolean on DirectoryUser needing a default, and no default that would be a claim about accounts nobody has read. The booleans *inside* a row are NOT NULL DEFAULT false, which is not a contradiction — within a row that exists the sweep has read the account, and Graph omits a false flag rather than sending it. Unknown lives at the row level.

    isAdmin is mirrored as `is_admin_per_graph`. The name is deliberate: Microsoft's definition of admin here is its own, and a report asking this column who the administrators are would answer a different question from every other privileged-access screen. Cross-check, never substitute — the catalogue (COM-487) exposes the Users subject's `holds_directory_role` for the real answer.

    One thing worth flagging that the task did not call out: a pass never deletes rows for accounts Graph did not mention. If Graph pages out mid-collection, deleting the unmentioned rows would erase the MFA status of everyone on the pages that never arrived — and an erased row reads as *unknown*, which is the one value that stops a report saying anything. A partial answer would silently shrink the population every MFA report is drawn from. There is a test for it.

    Graph writes the literal string "none" for an account with no default method; normalised to null rather than shown as a method somebody chose.

    REQUIRED_ENTRA_APP_ROLES deliberately unchanged. AuditLog.Read.All is already requested and is expected to cover this; adding Reports.Read.All would turn the Integrations health card red on every tenant that does not need it. The sweep's own auth_methods_available flag is the honest place for that gap, and its reason text names the permission, the alternative grant, and the worker restart a new grant needs.

    **Still to confirm on the tenant** (alongside COM-492's P1 check): whether AuditLog.Read.All alone returns this report. If it needs Reports.Read.All that is a new grant *and* a worker restart — the health card goes green before the token does.
assignee: steve
company: null
label:
- feature
priority: high
task_status: done
---
Discovery finding, 2026-08-28. *Which accounts have no second factor* is the most-asked question in any access review, and Compass cannot answer it at all — not partly, not approximately. It is the biggest single gap in the mirror.

Graph reports it whole: `/reports/authenticationMethods/userRegistrationDetails`, one paged call, one row per user. Mirror per user:

- **is MFA registered**, and **is MFA capable** — registered but not enforced is a different finding from not registered, and the two must not be merged;
- **is passwordless capable**, **is SSPR registered / enabled / capable**;
- **the methods registered**, as a list;
- **the default method**;
- **is admin** as Graph reports it — useful as a cross-check against our own privileged-role view, never as a substitute for it.

Held on its own table keyed by the directory user, not as columns on `DirectoryUser`: it comes from a different endpoint on a different cadence, and folding it in would make a failure of the reporting endpoint look like a change to the user.

**Confirm the permission and the licence before starting.** `AuditLog.Read.All` is already requested and is expected to cover this; if the tenant needs `Reports.Read.All` instead, that is a new grant, and a new grant needs a worker restart before the token carries it. Check the Entra licence tier at the same time.

**A user with no row is *unknown*, never *no MFA*.** Reporting an unread account as unprotected produces a false finding in the one report people act on immediately, and one of those costs more trust than the report earns.

Seeded reports once the subject exists: *Users without MFA*, *Privileged users without MFA* (the one that matters), *Users with SSPR not registered*.
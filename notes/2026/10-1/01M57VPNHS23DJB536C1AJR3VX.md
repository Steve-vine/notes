---
id: 01M57VPNHS23DJB536C1AJR3VX
created: 2026-10-18T15:57:19.801955Z
updated: 2026-10-18T20:50:26.640164Z
type: task
title: 'ADR: Attestations — content is assigned to a business role on a schedule, the people who hold it read and sign it in the User Portal, each person signs a document once however many roles ask, and every signature is kept as evidence'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1092
sprint: s7s7mn9
comments:
- id: 01M58CFB5S7C9WSNM98YJG2CZZ
  author: Steve Vine
  at: 2026-10-18T20:50:25.593165Z
  text: |-
    Done: ADR 0117 written, PR #1082, all checks green. Waiting to be merged: auto mode won't let me merge without review, and I've asked you how to handle merges.

    It records your four decisions and my calls, plus a table of framework requirements against what meets each. Two things changed from the brief, both found in the code:
    - the role page is a stack of cards with no tabs, so the role gets a Content card rather than a tab;
    - sign-in uses a new portal role, "attester", which works like the asset-owner and recertifier roles. It's given and removed automatically from what a person has to sign, never by hand.
assignee: steve
label:
- brief
priority: high
task_status: review
---
Sprint 78, Attestations. Scoped with Steve on 2026-10-18. This record is the first task, and the rest wait for it.

## What Attestations is

A new module, **Attestations**, in the Modules section of the menu, per company. It records that the people a policy binds have read it, understood it and agreed to follow it, and it proves that to an auditor.

- On a **business role**, someone assigns **content** (any published policy, standard or procedure) with an **assign date** (when it opens and the email goes out), a **deadline** (days to complete) and a **cadence** (how often it repeats).
- The people who hold the role are emailed a link to the **User Portal**. There they see everything they need to sign, open each document, and **sign** to say they have read, understood and agree to it.
- **Each person signs a document once**, however many roles assign it to them.
- The module shows what is assigned by role, what is open now (with % complete and time left), and compliance by role, by content and by person.

## How it meets the frameworks

The library's **INS.2** ("confirm that they have read and understood", key ACU.2) and **INS.15** (every policy communicated with evidence, key s42.INS.5) already map these requirements. Attestations is what makes them operate.

| Requirement | Met by |
|---|---|
| ISO 27001 A.5.1 "communicated to and acknowledged by relevant personnel" · 7.3 · A.5.10 · A.6.7 | Content assigned to the roles it binds, signed by each holder |
| SOC 2 CC1.1 / CC2.2 / CC5.3: acknowledged on hire and periodically | New role-holders asked straight away; cadence repeats it |
| PCI DSS 12.1.3 "all personnel acknowledge" · HITRUST 02.d, 06.e · NIST GV.PO-01 | Every holder of the role, contractors and temps included |
| INS.2 "again when the policy changes materially" | Publishing a new version can ask everyone to sign again now |
| INS.2 "the outstanding list… followed up" | Open view's overdue list; reminders and overdue emails |
| INS.2 / INS.15 "recorded against the individual and retrievable" | Signatures are permanent, exportable, and shown on the control |

**Out of scope:** restating surviving obligations to leavers (ISO A.6.5, PEO.7); NDAs and employment terms signed outside Compass (A.6.2, A.6.6); comprehension quizzes (training stays in SAP); withholding access until someone signs.

## What Steve decided (2026-10-18)

- **Portal sign-in:** anyone who holds a role that assigns content can sign in to the User Portal, and sees only their own attestations. No group mapping is needed, so contractors and temps are covered.
- **A new version:** the publisher chooses between **sign again now** (a material change) and **at the next cycle** (a minor change).
- **Chasing:** only the person is emailed. Managers and role owners see the overdue list in the module.
- **Placement:** its own module in the sidebar. Content is assigned on the role.

## What the record has to settle (Claude's calls, not confirmed by Steve)

- **Cadence:** One-off, Monthly, Quarterly, Every 6 months, Annually. **Deadline:** 1–365 days.
- **A cycle** of a role's assignment opens on the assign date and then every cadence. It is open until its deadline. After the deadline anyone still outstanding is **overdue** and stays asked until they sign, and a late signature is marked late.
- **Sign once.** A person has one request per document, whatever roles or companies assign it (content is shared across companies). A signature counts for a role's cycle when it is of the version current when the cycle opened (or later), and it was made during the cycle or within that role's cadence before it opened. If two roles open within a few weeks of each other, the person signs once. Where several cycles are open, the request carries the earliest deadline.
- **New starters:** someone who takes on a role while its cycle is open is asked straight away, with the full deadline counted from the day they joined. That covers "at onboarding".
- **Leavers:** someone who loses the role drops out of that role's counts. Their signatures stay.
- **Sign again now:** this opens an immediate round for that document for everyone it is assigned to, with each role's deadline counted from publication.
- **A signature** needs the person to open the document, tick "I have read and understood this document and agree to follow it", and type their full name. Compass keeps the time, the exact version, the statement as worded, the typed name and how they signed in. It can never be edited or deleted.
- **Content that can be assigned** is published content only. Content that is retired or deleted stops opening new cycles, and its history stays.
- **Can't-reach people are flagged, not hidden:** anyone with no email address, or no Entra account to sign in with (AD-only directories), shows as such in the Open view.
- **Permissions:** `attestations.view` (see the module) and `attestations.manage` (assign content to roles and change assignments). Built-in Admin only; the starter roles stay frozen, as with SAP and Incidents. Signing is a portal ability that comes with being assigned, not a catalogue permission (permission catalogue, "Where the portal sits").
- **Emails:** one email per person per day listing everything newly opened, a reminder 7 days and 1 day before the deadline, then an overdue email the day after and weekly until signed.
- **The assistant** can read everything and assign content, but it never signs for anyone.

## Notes (technical)

- Write `decisions/0117-attestations.md` unless another number has landed. 0116 is the Incident Register; check every branch, not just main.
- Reuse the existing patterns: business roles are company-scoped, and holders come from `directory_user_business_roles`; content versions are immutable (`content_version`); the actions-queue source and derived mail (ADR 0055); the Evidence of operation `SOURCES` registry (ADR 0115); portal write routes must be added to the exact-set allowlist test in `tests/test_portal.py`; and audit the new tables (activity log).
- Cycles and who-is-due are computed by a Beat task. It must be idempotent and take IDs (Celery standards). Beat crontabs are wall-clock.
- Most tasks add a migration, so the stack is serial. Build in the order below; each task's blockers are set.

## Tasks (build order)

1. COM-1093 a role's Content tab: assign date, deadline, cadence; edit, stop, restart
2. COM-1094 cycles and who's due: sign once, new starters, leavers, overdue and late
3. COM-1095 Portal ▸ Attestations: to sign, read, sign, signed
4. COM-1096 portal sign-in for anyone with something to sign
5. COM-1097 emails: opened, reminders, overdue (person only), plus Actions
6. COM-1098 new version: sign again now, or at the next cycle
7. COM-1099 the module in the menu, and the Open tab
8. COM-1100 Compliance by role, content and person; a person's history
9. COM-1101 evidence: export, the content page card, Evidence of operation on INS.2 and INS.15
10. COM-1102 assistant tools (last)

**Done when:** the ADR is merged and the tasks above match it.
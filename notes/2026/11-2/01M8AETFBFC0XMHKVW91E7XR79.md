---
id: 01M8AETFBFC0XMHKVW91E7XR79
created: 2026-11-25T22:57:01.80752Z
updated: 2026-11-27T11:25:05.529213Z
type: task
title: Who's assigned to each enterprise app is held in Compass — shown on a person and reportable
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2172
comments:
- id: 01M8AP48KK40RN26689NM90C8D
  author: Steve Vine
  at: 2026-11-26T01:04:42.610903Z
  text: |-
    Done — PR #2179, merged to main (d1d5baaf). Goes to staging with the rest of the sprint-0 batch.

    What to look at:
    - **Access ▸ Reports ▸ new report:** a new subject, **App assignments**. One row per person per app per route: Application, Person, App role (*Default access* when the assignment carries no particular role), and How (*Direct* or *Through group X*). Someone assigned both ways appears twice. Filter on Application for "who can use app X?". There are extra columns for sign-in name, department, account enabled, assigned on, and whether the app requires assignment.
    - **Access ▸ Reports:** the standard report **Who can use each enterprise app**.
    - **Admin ▸ Integrations ▸ Microsoft:** the read list has a new **App assignments** row (Current / Stale since… / Never read). Read hourly at :55.
    - If the read was refused or has never run, the report says so in a yellow note above the table, in the wizard preview, and at the top of CSV, PDF and mailed copies — never an empty list that looks like nobody.
    - The person popup's Applications panel is unchanged here; COM-850 moves it onto this data.

    Found while doing this, not changed:
    - Entra doesn't pass an app assignment down to nested groups, so *Through group* means a direct member of that group. Members of groups nested inside it are not listed (that's how Entra itself behaves).
    - The existing Application permissions report shows permission IDs instead of names: the app read doesn't ask Microsoft for the role names.
    - Nothing is excluded. If the volume on production is large, the likely candidates to leave off screen are the big *Default access* lists on Microsoft first-party apps — the new Integrations row shows the count to judge by.

    Technical: migration 0928 (`directory_app_assignments` + 4 sync-status columns); hourly sweep `sweep_app_assignments` at :55; shared helper `core/app_assignments.py`; ADR 0048 amended (apps are mirrored; app assignments now are too).
- id: 01M8AWJQ17SP0YKSQH74ZRYB47
  author: Steve Vine
  at: 2026-11-26T02:57:27.591207Z
  text: |-
    **Pre-UAT: Passed (on screen) · Couldn't check (a fresh assignment)** — staging 30d00690, 26 Nov, as E2E Admin A.

    Passed:
    - Before the first read, the standard report **Who can use each enterprise app** showed the yellow "has not been read from Microsoft yet" note over an empty table.
    - The first hourly read ran at 02:55 and took 18 seconds: **3,054 assignments**. The report then filled in, e.g. "15Five · Sarah Reilly · User · Through group 15Five Users", and the note went away.
    - Admin ▸ Integrations ▸ Microsoft ▸ Configure: **App assignments — Current**.
    - A person's popup (C Forster) ▸ Applications: 35 apps from this data (COM-850).

    Couldn't check — for Steve: assign a test user to an enterprise app directly and once through a group in Entra, wait for the next :55 read, and confirm they appear twice in App assignments with the right *How*; remove one and it drops out the next hour.

    Screenshots: ~/compass-uat/sprint-0/COM-2172/
assignee: steve
label:
- feature
priority: medium
task_status: done
---
Split out of COM-850 (review of what the mirror holds). **On the chain** (migration + API). COM-850 stacks on this.

Today Compass copies every enterprise app and what each app is allowed to do, but not **who is assigned to it**. That's only read live, one person at a time, in the person popup, so "who can use app X?" can't be answered or reported. Steve's call (25 Nov): make it visible and reportable — nothing more for now.

## What people see

- **A person's popup ▸ Applications** lists each enterprise app they're assigned to, and how: *Direct* or *Through group X*. If the assignment carries an app role other than the default, it's shown ("Payroll — Approver").
- **Reports** gain a subject, **App assignments**: one row per person per app, with the app, the person, the app role, and how they got it (direct or the group). A person who is assigned both directly and through a group appears once per route. Filter by app to answer "who can use app X?".
  - A standard report, **Who can use each enterprise app**, is seeded alongside the existing standard reports.
- Read **hourly**, like sign-ins and MFA, so an assignment made in Entra shows within the hour. An app or assignment that's gone drops out.
- If the read can't be made (permission missing, Graph refusing), the Applications panel and the report say so with the reason — never an empty list that looks like "no one".
- **Not in scope:** watching app assignments for unrequested changes, recertifying them, an Apps tab, and the relationship graph. Each can follow once the data is held.

## Notes (technical)

- **Read:** `/servicePrincipals/{id}/appRoleAssignedTo` for each service principal already in `directory_service_principals`, into a new mirror table (service principal, principal id, principal type user/group/service principal, app role id + display name resolved from the app's `appRoles`, created date). `directory_app_permission_grants` is the opposite direction (what an app holds) — don't overload it.
- **Own sweep**, like `tasks/sign_in_sweep.py`: hourly, its own status row with an available/reason pair so a 403 is a stated reason, not "no assignments". Needs a `TASK_LABELS` entry (`core/task_labels.py`). Check the grant (`Application.Read.All` / `Directory.Read.All`) is already held.
- **Volume:** some first-party / consented apps carry large "Default Access" assignment lists. Measure on production via the read before deciding whether to keep them all; if one is excluded, say so on screen.
- **Through a group:** expand group assignments to people through the mirror's transitive membership, the way other subjects do; keep the group as the "how".
- **Report:** a new `Subject` in `reports/catalogue.py` added to `SUBJECTS`; seed in `seed/reports.py`; extend `tests/test_report_catalogue.py`.
- **ADR 0048** is stale: it says apps and service principals are live Graph reads, but they've been mirrored since migration 0148. Append an amendment noting that, and that app assignments are now mirrored (§6's precondition for app edges on the graph is met).
- The popup itself switches to the mirror in COM-850; this task only needs to make the data available.

**Done when:** on staging, a test user assigned to an enterprise app in Entra (once directly, once through a group) shows in the **App assignments** report within the hour, with the right route. The standard report lists the app with that person in it.
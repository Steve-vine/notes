---
id: 01M48D2JRQRN39P1YN2AQJZQHY
created: 2026-10-06T10:45:14.135607Z
updated: 2026-11-25T22:57:57.73039Z
type: task
title: A person opens instantly — the popup's roles, apps and licences come from the mirror, as of the last read
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 850
blocked_by:
- 01M8AETFBFC0XMHKVW91E7XR79
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
**On the chain** (the API response changes). Stacks on COM-2172 (app assignments held in Compass).

## Background — the review this task started as

The original ask (6 Oct): review what from AD, Entra ID and Exchange is held in the mirror versus read live (e.g. directory roles), and consider adding more. Review done 25 Nov:

- **Already mirrored:**
  - Entra, every 15 minutes: people, groups, members, devices, directory roles (active and eligible), apps, service principals and Conditional Access policies.
  - Hourly: sign-ins and MFA.
  - On-prem AD, every 5 minutes, with a full read nightly.
  - Hourly: shared-mailbox Full Access / Send As, and list senders.
- **Still read live:** only the person popup's four panels (Active assignments, Eligible assignments, Applications, Licences).
- **Gaps found, and Steve's decisions:**
  1. The popup reads live → **move it to the mirror** (this task).
  2. Who's assigned to each enterprise app isn't held → **visible and reportable** (COM-2172).
  3. Send on behalf on shared mailboxes isn't held anywhere → **governed** (COM-2173, then COM-2174).
  4. The mirror keeps current state only, no history → out of scope.

## What people see

- **Opening a person no longer waits on Microsoft.** Active assignments, Eligible assignments, Applications and Licences come from Compass's copy, like every other Access screen. The popup now always agrees with **Directory roles**, reports and recertifications for the same person.
- Each panel says how fresh it is: "As of 14:15", the last successful read. If the last read failed, or that part couldn't be read (eligible roles need Entra ID P2; the app-assignment read can be refused), the panel says so with the reason, as it does today.
- **Roles a person has activated through PIM** still show, marked with when the activation ends.
- **Licences** keep today's names and refresh every 15 minutes, as the mirror already does.
- People without an Entra account, and people who have left the tenant, show the same messages as today.

## Notes (technical)

- **Remove the live reads.** Delete `fetch_live_user_panels` / `_LivePanels` and the per-pod in-memory cache in `api/v1/directory.py` (~714–900). Build the panels from:
  - `directory_role_assignments` (active / eligible), with roles held through role-assignable groups derived at read time as elsewhere;
  - the COM-2172 app-assignment table;
  - `DirectoryUser.assigned_license_skus` with the SKU-name map the sync already reads.
- **PIM activations.** The live panel reads `roleAssignmentScheduleInstances`; the mirror reads `/roleAssignments`, and nothing confirms activated roles land there or records when they end. Check against a real activation. Then read `roleAssignmentScheduleInstances` in the role pass, carrying `assignmentType` (Activated / Assigned) and `endDateTime`, so the mirror can mark it. Keep the same degrade-with-a-reason behaviour as eligibility.
- **Response shape.** Keep `DirectoryUserPanel {available, reason, items}` so `UserDetailModal.tsx` (`AssignmentSection`) changes little; add `as_of`. Regenerate the OpenAPI schema / `schema.d.ts`.
- **Tidy.** The comment in `core/celery_app.py` that calls the 15-minute run "a full resync" is out of date.

**Done when:** on staging:
- Opening a person makes no Graph call (check the API log).
- The four panels match the person's entries on **Directory roles** and in the **App assignments** report, each showing "As of …".
- A role activated in PIM shows as activated, with its end time, within 15 minutes.
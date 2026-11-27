---
id: 01M8EGF7E86KBQ4MH6RCRQ6Z5E
created: 2026-11-27T12:42:48.13651Z
updated: 2026-11-27T17:11:11.401122Z
type: task
title: A request can give someone an Entra directory role — eligible through PIM, with an end date
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2183
sprint: smq8t5s
blocked_by:
- 01M8EGERP5KEBTQB48Q453GS5K
comments:
- id: 01M8EZTJ8BA4HG1QP2V9FZ5ZCJ
  author: Steve Vine
  at: 2026-11-27T17:11:08.299546Z
  text: |-
    Done — merged to main in PR #2195. Not on staging yet; it goes with the sprint.

    What changes:
    - A membership request has a new Directory roles part. It can:
      - make someone eligible for a directory role through PIM, with an end date (required, never permanent);
      - take a role away (active or eligible).
    - Either one makes the request privileged: an Access Admin approves it, and a second Access Manager isn't enough.
    - With Compass's app holding the role-write permission and an Access Privilege Approver approving, Compass makes the change in Entra itself and records it. Otherwise each role is an Entra to-do saying why, e.g. "Make Grace eligible for Exchange Administrator until 27 Dec 2026, in Entra". The next role read (every 15 minutes) closes it once it's seen.
    - A role Compass removed, or one a person removed for a to-do, doesn't come back as an unrequested "role lost".
    - The request page shows the roles asked for, and the user and group popups show when an eligible role ends.
    - Business roles still can't grant directory roles.

    Checks:
    - Unit suite green.
    - Request integration suites green.
    - All ten CI jobs passed.
    - A screen-convention test now lists the role end-date calendar, which sits inside the request window and so closes on Escape correctly.

    For pre-UAT on staging:
    - The to-do path is checkable on a test account.
    - Compass making the change itself needs the role-write permission in the staging tenant. If it isn't granted, that part is Couldn't check.
assignee: steve
label:
- feature
priority: medium
task_status: review
---
**On the chain** (migration + API). Stacks on COM-2182 (Compass changes roles when permitted) and COM-2181 (Access Privilege Approver).

Steve's decision (27 Nov 2026): requests can **grant** directory roles too, made **eligible through PIM**, never permanent.

## What people see
- **Change access** gains a **Directory roles** section:
  - **Make eligible:** pick a role (e.g. Exchange Administrator), how long the eligibility lasts (an end date, default 6 months), and a reason.
  - **Remove:** take away a role the person holds, active or eligible, directly assigned.
- **Eligible, never permanent:** a granted role is always eligible through PIM. The person activates it when they need it, through Entra's usual PIM activation. Compass never makes a permanent (always-active) assignment from a request.
- **Approval:**
  - Every role change needs an Access Admin, as all privileged work does today.
  - If Compass will make the change itself (COM-2182's permission is granted), it needs an **Access Privilege Approver** instead (COM-2181), and never the requester.
- **Carrying it out:** with the permission, Compass creates or removes the PIM eligibility. Without it, the change is a to-do ("Make Sam Jones eligible for Exchange Administrator until 27 May 2027, in Entra"). Either way it closes when the next Entra read sees it.
- **Afterwards:**
  - The person's popup shows the role under **Eligible assignments**, with its end date.
  - When the end date passes, Entra removes it and Compass's next read shows it gone.
  - A role granted this way is recorded as **requested**, so it never comes back as an unrequested change.
- **Business roles** still can't include directory roles (ADR 0061). Privilege is always a named, time-limited exception.

## Notes (technical)
- **Request kind:** extend `membership_change` with role grants and removals, or add a role-change kind if cleaner. New `AccessChangeKind` values for "role made eligible" and "role removed". Stamp the ledger so the unrequested-change detector suppresses them, matching on (principal, role, kind).
- **Graph:** `POST /roleManagement/directory/roleEligibilityScheduleRequests` with `action: adminAssign`, `scheduleInfo.expiration` (afterDateTime), `directoryScopeId: "/"`.
  - Removal is `adminRemove`; a direct active assignment is removed as in COM-2182.
  - The PIM policy for a role may cap eligibility length or require justification. Surface Microsoft's refusal as the failure reason, not a generic error.
- **Default length:** 6 months, with the most allowed taken from the role's PIM policy if readable, else no cap. Pin the default in config.
- **Polaris:** `access_raise_membership_change` (or a new tool) can raise a role grant; same approval rules.

**Done when:** on staging, a request to make a test person eligible for a low-privilege role for 1 month:
- needs an Access Privilege Approver when the permission is granted, and is otherwise a to-do approvable by an Access Admin;
- once done, shows on the person's Eligible assignments with its end date.

(Needs the permission in the staging tenant for the automatic half — Couldn't check if not.)
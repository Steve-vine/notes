---
id: 01M7J4CAT9X0N30SXSJWXP65NG
created: 2026-11-16T12:12:46.281351Z
updated: 2026-11-16T15:07:42.008144Z
type: task
title: 'Check page: delete a check'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1868
sprint: s7nqsy0
comments:
- id: 01M7JC77GJ3PGDR6QH2P2W1H3A
  author: Steve Vine
  at: 2026-11-16T14:29:47.666798Z
  text: |-
    Done — PR #1866, merged to main (43d03f09). Not on staging yet.

    - Delete on the check's page asks for a reason. The confirmation says what will happen and lists the workflows that use the check (WF-n, name, status). Afterwards you're returned to All checks.
    - The check stops collecting and leaves All checks and the control's Evidence tab.
    - Each of its captures stays in the Evidence register, archived on the control as "CHK-n deleted: <reason>", so the existing archive can restore one or delete it for good. A held capture (not yet confirmed) has no page in the register yet, so it goes with the check.
    - Enabled workflows that use it are disabled and left in place, with an Activity note saying why. A change waiting at Review is discarded.
    - Activity records the deletion and its reason. The CHK ID is never reused; opening it says "CHK-n was deleted on <date>: <reason>".
    - Polaris can't delete a check. It says only a person can, and gives the link.

    To check on staging: delete a throwaway check in E2E Test Company. Then look at its archived captures on the control (Archived), the disabled workflow's Activity, and that the check has gone from All checks.
- id: 01M7JECMHR58FB82H579BT634E
  author: Steve Vine
  at: 2026-11-16T15:07:42.00798Z
  text: |-
    **Pre-UAT: Couldn't check** (staging 43d03f09, E2E Test Company, E2E Admin A)

    There was no throwaway check to delete:
    - E2E Test Company's only collected check is CHK-2. Earlier UAT runs and five workflows use it, and a replacement (CHK-3) waits for it at Review. I didn't treat it as a throwaway.
    - I couldn't make a new check: the only new-check proposal (CHK-1) can't be approved ("Checks don't read Microsoft 365 through Access Control's connection…"), and no Collection account can be added to the test company.

    What I could see, without confirming:
    - CHK-2's page ▸ Delete opens "Delete CHK-2?". It says it stops collecting and leaves All checks and ACC.13's Evidence tab. It says its captures are archived on the control as "CHK-2 deleted: …" and can be put back or deleted for good from Archived, and that an audit pack keeps what it has.
    - It lists the workflows that will be disabled, with status: WF-2 (Enabled), WF-3, WF-6, WF-7 and WF-8 (Disabled). It notes that a gap one raised stays open, and that "CHK-2 isn't given to another check."
    - Reason is required: "Delete CHK-2" stays greyed out until a reason is typed. I then pressed Cancel; nothing was deleted.
    - Polaris on staging has no tool to delete a check.

    Steve to look at on staging: delete a check you don't need in Test Company (or set up E2E Test Company with a working Collection check). Then check:
    - it has gone from All checks and the control's Evidence tab;
    - its captures are under the control's Archived with "CHK-n deleted: <reason>";
    - an enabled workflow that used it is now disabled, with an Activity note;
    - the deletion and reason are in Activity;
    - opening its old link says "CHK-n was deleted on…".

    Screenshots: ~/compass-uat/s7nqsy0/COM-1868/ (delete-dialog.png, approve-chk1-attempt.png)
assignee: steve
label:
- improvement
priority: medium
task_status: review
---
Asked for by Steve while testing sprint "Automation - Workflows" on staging (2026-11-16).

## Today

A collected check can be switched off, or retired by a replacement, but never deleted. A check nobody wants stays in All checks.

## Done when

- **Delete** on the check's page (for whoever may record assessments) asks for a reason. The confirmation says what will happen and lists the workflows that use the check.
- Once deleted:
  - the check stops collecting and leaves All checks and the control's Evidence tab;
  - its CHK ID is never reused;
  - the deletion is in the activity log with the reason.
- **Its past captures aren't lost silently.** They are archived evidence on the control, with the reason "CHK-n deleted: <reason>", so the existing archive can put one back or delete it for good (COM-1738). Evidence already in an audit stays as the audit has it.
- **Workflows that use it are disabled,** with a note saying why. They are left in place, not deleted. A gap a workflow raised from the check's evidence stays open until someone closes it.
- A check with a change waiting at Review: the waiting change is discarded with it.
- Polaris can't delete a check. Asked to, it says so and gives the link.
- Tests cover:
  - delete with a reason archives the captures and disables the workflows;
  - the CHK ID isn't reused;
  - a delete without a reason is refused;
  - Polaris has no delete.

Assumed (Steve to correct): captures are archived rather than destroyed, because they may be audit evidence.

On the chain (a new API route).
---
id: 01M7J4CAT9X0N30SXSJWXP65NG
created: 2026-11-16T12:12:46.281351Z
updated: 2026-11-16T12:12:46.281351Z
type: task
title: 'Check page: delete a check'
label: improvement
assignee: steve
task_status: todo
priority: medium
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1868
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
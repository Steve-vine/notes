---
id: 01M7J4C4AK91ZKW51PGS1SB9G4
created: 2026-11-16T12:12:39.635544Z
updated: 2026-11-16T13:25:34.253188Z
type: task
title: 'Check page: edit a check from its own page — rename it, change its description and schedule, and change its reads directly or with Polaris'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1867
sprint: s7nqsy0
assignee: steve
label:
- improvement
priority: medium
task_status: active
---
Asked for by Steve while testing sprint "Automation - Workflows" on staging (2026-11-16).

## Today

A collected check's page (All checks ▸ CHK-n) is read-only. A check can be renamed, rescheduled and have its reads edited, but only from the control's Evidence tab. Its description (About, what it shows) can only be changed by Polaris.

## Done when

- **Edit** on the check's page (for whoever may record assessments) lets a person change:
  - its **name**, applied at once;
  - its **description** (About), applied at once, because it only changes how the check is described;
  - its **schedule** (frequency), applied at once, with the next capture counted from its last one, as today;
  - its **reads**, either edited directly (the same read editor and sample as the Evidence tab's) or by asking Polaris from the page. A change to reads goes to Evidence Collection ▸ Review like any change to a live check, and the page says a change is waiting.
- Every change appears in the page's Changes list, with who made it and when.
- A retired check can't be edited.
- Polaris, with the check on screen as "this check", can do the same under the same rules. A reads change still waits for a person at Review.
- Tests cover:
  - name, description and schedule changes apply at once and are logged;
  - a reads change waits for Review and the page shows it;
  - a retired check refuses edits.

On the chain (the description becomes editable through the API).
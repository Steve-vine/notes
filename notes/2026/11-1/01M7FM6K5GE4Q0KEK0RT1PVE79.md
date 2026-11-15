---
id: 01M7FM6K5GE4Q0KEK0RT1PVE79
created: 2026-11-15T12:51:32.144877Z
updated: 2026-11-15T20:08:35.2727Z
type: task
title: Test a workflow before it acts — run it against a chosen piece of evidence, or the last captures, and see what each step found and what it would have done, without changing anything
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1855
sprint: s7nqsy0
blocked_by:
- 01M7FM64QFV0446ZV7G5ENBSQX
comments:
- id: 01M7GD6R893MEYNEX76P0DSWGB
  author: Steve Vine
  at: 2026-11-15T20:08:31.75213Z
  text: |-
    Built and merged (PR #1851).

    What people get:
    - Test sits in the workflow builder's header, between Save and Enable. It works on a saved workflow, on unsaved changes, and on a new workflow before it's ever saved. People who can read workflows but not change them can test the saved version.
    - Pick what to test against: a piece of evidence (by default the latest one its trigger would see), or a check's last 10 captures, which run in the background with progress shown ("3 of 10 done"). A "status changed" trigger asks which change to pretend happened.
    - For each piece of evidence you see what each condition found, in words; what each action would do; and how that differs from today ("Would change it from Compliant to Non-compliant"). The canvas lights the path the evidence took: green blocks and joins, grey for what it didn't reach.
    - It always says "Test only. Nothing was changed." A test is kept for an hour for whoever ran it, never in the run history.
    - Enabling a workflow shows your last test of it and offers "Test first".

    Checks: CI fully green. A test confirms that every table's row count is unchanged after a test. Steve's standard-changes workflow tested against a real capture shows CHG-2231 failing and "Would set Non-compliant". Pre-UAT follows the staging deploy.
assignee: steve
label:
- feature
priority: high
task_status: review
---
Sprint "Automation - Workflows" (ADR in COM-1848). Builds on COM-1851, COM-1853 and COM-1854.

## What people see

- **Test** in the builder's header (also on a workflow's page, and for Polaris). It works the same for enabled and disabled workflows and for unsaved changes.
- **What to test against**: pick a piece of evidence (defaults to the latest one the trigger would see), or "the last 10 captures of this check". For a status-change trigger, pick a piece of evidence and the change to pretend happened.
- **The result**, per piece of evidence:
  - the path it took, highlighted on the canvas (green for the steps that matched, grey for those that didn't);
  - each condition's finding in plain words ("38 of 41 changes are on Approved standard changes (v7). Not on it: CHG-2231, CHG-2240, CHG-2251");
  - what it **would** do ("Would set Non-compliant · Would raise a gap on CHG.4: '3 standard changes not on the approved list'");
  - how that differs from today ("Today: Compliant, set by Steve Vine").
- **Nothing changes**: no status, no gap, no Actions, no email. The test is kept briefly in the builder (not in the runs history) and says so: "Test only. Nothing was changed."
- **Empty evidence** says what the workflow makes of it (carrying over COM-1628: nothing found is evidence too).
- **Before enabling**, the confirm step offers to run the test first and shows the last test's outcome if there was one.

## Notes for the builder

- The same engine as real runs, with actions in "what would happen" mode, so a test can't drift from reality.
- Bounded like real runs. Testing against 10 captures runs on Celery with progress if it's slow.

## Done when

- Testing Steve's standard-changes workflow against a real capture shows the path, the findings, the failing changes and the would-be actions, and nothing in Compass changes. A test asserts no status, gap or action was written.
- It works for unsaved edits and for a status-change trigger.
- Browser smoke runs a test from the builder.

**On the chain** (API).
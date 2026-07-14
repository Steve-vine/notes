---
id: 01KXGT6S2E4PDYSHW022V9TVBJ
created: 2026-07-14T17:18:45.838809893Z
updated: 2026-07-14T17:18:45.838809893Z
type: task
title: Full end-to-end test & remediation
task_status: backlog
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 75
---
The "fully test and finesse" pass — comprehensive **end-to-end testing across every feature**, then fix all findings.

Scope to exercise: auth (login/reset/API tokens), RBAC (admin/editor/viewer), multi-company scoping, control library + domains, assessments + evidence, gaps, risk register + treatments + heatmap + rubric/appetite, content authoring/versioning + policy PDFs, decision records, the **7 frameworks** + coverage + crosswalk + ISO SoA, global search, reminders/notifications, and the new M14 audit log / M15 reporting / M16 actions.

- [ ] Define the E2E approach (manual test script vs automated e.g. Playwright once browser deps are sorted — note: screenshots/headless were previously blocked in the build sandbox; the live deploy is the verification surface).
- [ ] Execute against the live deploy; log findings as issues.
- [ ] Remediate findings; re-verify.

Decide in M17 whether this runs before or after the candidate workstreams above.

---
*Migrated from Linear [DEV-504](https://linear.app/stevevine/issue/DEV-504/full-end-to-end-test-and-remediation) · created 2026-06-19*
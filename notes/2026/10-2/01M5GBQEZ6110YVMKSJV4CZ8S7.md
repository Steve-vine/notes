---
id: 01M5GBQEZ6110YVMKSJV4CZ8S7
created: 2026-10-21T23:11:18.502749Z
updated: 2026-10-22T19:19:34.062452Z
type: task
title: Eight tests fail in the hour after UK midnight because they take "today" from UTC
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1243
comments:
- id: 01M5GJEZDKTV4VGB14C6GM0MP0
  author: Steve Vine
  at: 2026-10-22T01:09:00.467469Z
  text: 'A ninth, found 2026-10-22 02:07 BST on PR #1222: `test_incident_actions.py::test_the_owner_decides_notifications_due_soon_then_overdue`. It expects a notification''s `due_date` to be the UTC date of `due_at` (now + 22 h); the app gives the UK date. So it fails when the run starts between about 01:00 and 02:00 UTC, when that deadline lands between 23:00 and 00:00 UTC. Fix: compare against the UK date of `due_at`.'
- id: 01M5JGVQGJJ0XTXKC264WM1JCM
  author: Steve Vine
  at: 2026-10-22T19:19:30.066042Z
  text: |-
    Done — merged in PR #1235 (tests only, nothing to deploy or smoke-test).

    All nine (the eight plus the incident-notification one from the comment) now take "today" as the UK day, the way the app counts it, instead of the UTC date. Checked locally with the clock moved: before the change six failed at 23:30 UTC, the notification one at 01:30 UTC and both frontend ones at 23:30 UTC; after it all nine pass at 23:30, 00:30 and 01:30 UTC and at the real time, and the six backend files pass in full at 23:30 UTC.

    Noticed, not changed: in the app itself, the trust centre visitor screens still take "today" as the UTC day (e.g. checking an access-until date). Between midnight and 01:00 BST a manager could be told a date is in the past when it's today. Worth a small task if you want it fixed.
assignee: steve
label:
- tech_debt
priority: medium
task_status: review
---
Found 2026-10-22 00:10 BST on PR #1219 (COM-1205), whose CI ran between 23:56 and 00:10 UTC, the first hour of the UK day. None of these are about that PR; they fail for any PR in that hour. Same family as COM-1190 and COM-1197, after ADR 0121 moved "today" to the reader's own day.

**Chain:** independent (tests only)

## Failing in that hour

Backend:
- `test_trust_centre_visitors.py::test_the_extension_email`: "sent you on 21 October" vs 22.
- `test_trust_centre_documents.py::test_expiring_evidence_is_every_managers_to_do_from_30_days`: 29 days vs 30.
- `test_incident_actions.py::test_a_required_review_is_on_the_owners_list_from_three_days_before_it_is_due`
- `test_assistant_trust_centre.py::test_nda_badges_and_activity_are_read_as_on_screen`
- `test_assistant_sap.py::test_a_repeating_entry_is_added_and_stopped`: 5 vs 4.
- `test_posture_timeline.py::test_defaults_are_twelve_months_by_month_and_a_short_range_by_week`

Frontend:
- `access/RunAtInput.test.tsx`: "does not offer a day that has gone".
- `pages/VendorDetailPage.test.tsx`: "starts an assessment: contacts ticked, two weeks by default (COM-358)", 2026-11-05 vs 11-04.

## Fix

Each test should take its expected date the way the app does (`today_here()` or the reader's day), or pin the clock to midday. Check them all with the clock set to 23:30 UTC (time-machine), as COM-1190 did.

**Done when:** all eight pass with the clock at 23:30 UTC and at 00:30 UTC.
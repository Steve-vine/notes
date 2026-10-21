---
id: 01M5DDAQYVXTMVMMK920FN2MFP
created: 2026-10-20T19:41:35.57934Z
updated: 2026-10-21T20:16:50.816656Z
type: task
title: '"Due today", "overdue" and schedules follow the person''s time zone, not the UK clock'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1186
sprint: ss8348q
blocked_by:
- 01M5DD9YEVY1YEFVQBQTP296HH
comments:
- id: 01M5F73A5CNNV27X3RNKEMKTTZ
  author: Steve Vine
  at: 2026-10-21T12:31:09.483999Z
  text: |-
    Done — PR #1204, merged 21 Oct 13:30 BST.

    - Actions counts "due today", "this week" and "overdue" by the reader's own day. A plan item due 12 Nov goes overdue for a New York reader at New York's midnight, five hours after a London reader. Exact-moment deadlines (data subject requests, incident notifications) are overdue at that moment for everyone.
    - Digest and reminder emails arrive on each reader's own night. UK readers get them at exactly the same times as before, and nobody gets two digests in a day, including across a clock change. A New York reader now gets theirs around midnight Eastern, not the evening before.
    - Report schedules, recertification schedules, attestation content on a role, and repeating plan activities each carry a time zone. It's set to the creator's and shown on the schedule ("Every week at 07:00 London time").
    - The report and recertification schedule forms have a time zone picker that starts as yours. Attestation content and plan activities show their zone but don't let you change it yet.
    - Existing schedules keep London time, so nothing moves.
    - The Incidents Overview and the posture timeline count days on the reader's clock.
    - Nightly housekeeping (retention clearing, discovery) stays on the deployment clock.

    My calls, for you to confirm:
    - Digest and reminder times follow each zone's winter clock all year. That keeps UK times exactly as they were (midnight in winter, 01:00 in summer), so other zones also get midnight in winter and 01:00 in summer. One side effect: for an hour after midnight in summer, the digest's "today" is an hour behind the Actions screen.
    - Recertifications now check hourly instead of once a night, so each zone's schedules open on that zone's night. A UK one still opens at the same time.
    - Review dates stay plain dates, with no time zone, so they never shift a day (ADR 0121 §4).
    - A few day-based screens still use the deployment's day, to avoid clashing with the screen sweep: the plan screens' own overdue flag, and the attestation and portal pages. Say if you want a follow-up task for them.
assignee: steve
label:
- improvement
priority: medium
task_status: done
---
Steve's request (2026-10-20). Implements COM-1182 §3 on the server.

**What's wrong:** everything on the server that asks "what day is it?" uses the UK clock, from one deployment-wide setting (Europe/London). For a US user, Actions' "due today" flips over at 7 pm Eastern. The daily digest is built on the UK day, and a report scheduled for 08:00 runs at 08:00 UK (03:00 Eastern).

**What it should do:**
- **Actions:** "due today", "due this week" and "overdue" on a dated item count by the viewer's own time zone. A deadline that's an exact moment (COM-1183, incident deadlines) is overdue at that moment for everyone.
- **Email digests and reminders** go out on the recipient's morning in their own zone (the existing cadence, at the same local hour), and judge "due today" by their zone.
- **Schedules** (report schedules, attestation cycles and rounds, the Security Assurance Plan's repeating activities, recertification schedules) carry a **time zone**. It's set to the creator's when the schedule is made and shown on it ("Every Monday at 08:00 London time"). Existing schedules take the deployment's current zone (Europe/London), so nothing moves when this ships.
- **Incidents' notification windows** (72 hours and so on) already count hours and don't change.
- **Background jobs** that run "nightly" (DSR retention clearing, discovery) keep running on the deployment clock. They aren't anyone's deadline.

**Behind it (technical):** replace `local_zone()` / `schedule_timezone` in `core/attestation_cycles.py`, `attestation_rounds.py`, `attestation_export.py`, `report_cadence.py`, `report_definitions.py`, `models/report_schedule.py`, `dsr_compliance.py`, `dsr_warnings.py`, `incident_export.py`, `incident_overview.py` and the Actions aggregation (plus the UTC `.date()` calls in `core/actions/incidents.py` and `posture_timeline.py`). Use the user's zone where a person is asking, and the schedule's zone where a schedule is running. Add a `timezone` column to each schedule table, backfilled to the current setting. Beat entries stay wall-clock UTC and fan out per recipient or schedule zone. Keep an eye on Beat memory (196Mi of 256Mi on staging).

**Done when:** a New York user's "due today" changes at their midnight. Their digest arrives on their morning. A schedule shows and honours its own zone. Existing UK schedules run at exactly the same times as before.
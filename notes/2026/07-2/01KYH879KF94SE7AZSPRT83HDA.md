---
id: 01KYH879KF94SE7AZSPRT83HDA
created: 2026-07-27T07:39:24.655438Z
updated: 2026-08-05T19:02:16.009458Z
type: task
title: Time in warn/alert
project: 01KX671DATY39VW6GWK3M2T3DN
number: 325
sprint: sak4nk6
comments:
- id: 01KYHXF694CAZPRY1HKRK0XCZS
  author: Steve Vine
  at: 2026-07-27T13:50:43.492171Z
  text: |-
    Done — PR #302 (feature/ise-325-component-time), stacked on ISE-324.

    Component tiles had no age, unlike the service wallboard's "for 12m". Added worst_since (the worst present signal's first_seen_at) to ComponentState + the ComponentStateRead payload (public board and authed detail), and render "for {age}" next to the level word on both the wallboard components drill-in AND the in-app components board. Server-relative (via ISE-321) so it's drift-safe. ok/unknown tiles carry no signal → show nothing.

    Regenerated openapi.json + schema.d.ts. Local gates: backend board/dashboards/evaluator + mypy + ruff green; FE build/lint/prettier + a "for 8m" assertion green. Moving to Review.
assignee: steve
label: null
priority: medium
task_status: done
---
Add the time in warn/alert indication to the components tiles, same as the main service wallboard.
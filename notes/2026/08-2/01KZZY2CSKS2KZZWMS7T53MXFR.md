---
id: 01KZZY2CSKS2KZZWMS7T53MXFR
created: 2026-08-14T10:46:16.62794Z
updated: 2026-08-14T14:32:34.765466Z
type: task
title: Incidents list screen search
project: 01KX671DATY39VW6GWK3M2T3DN
number: 708
sprint: sevhjex
comments:
- id: 01M006XDJHWCN3MCCZ1AG1TM0R
  author: Steve Vine
  at: 2026-08-14T13:20:50.769723Z
  text: |-
    Built and merged — PR #656 (squashed to main 2026-08-14).

    "1234", "IN-1234", "in 1234", "#1234" and the padded "IN-0021" all now reach IN-1234 from the incidents search box.

    `parse_incident_number` is the inverse of `incident_label` and lives beside it in `issue_labels.py`, so the two formats cannot drift — the same reason that module exists at all. It is deliberately strict: the whole term must be the reference, because "restart 1234" is prose and reading a number out of it would swap the title search the operator asked for. Digits are capped at nine (issue.number is an int4; a longer run is a ticket id or an IP).

    The number match is ORed with the title match rather than branching on it. A term that reads as a reference is often also a phrase — "500" is both — so both readings come back instead of the parser silently choosing one. The other filters still AND across unchanged.

    The placeholder now reads "Search title or IN-1234". Without it the feature is unfindable: nothing else on the screen tells an operator the box will take an id.

    Tests: the parser's accepted/rejected forms as a unit table; the endpoint against real Postgres for each typed form, the still-matches-titles OR, and ANDing with severity; the page test asserts the term goes out verbatim, since matching is the API's job.

    Gap noticed, not fixed here: the Cmd-K global search matches issues on title/description only and has the same blind spot. Left as its own task rather than a drive-by — say the word and I'll raise it.
assignee: steve
label: null
priority: medium
task_status: done
tech: null
---
The search box on the incidents screen doesn’t currently search the incident number, it should be possible to enter ‘1234’ into the box and it fine IN-1234
---
id: 01KZ125NAWBT9XBP5KR85S4NE7
created: 2026-08-02T11:01:30.588957Z
updated: 2026-08-07T10:57:31.574477Z
type: task
title: 'Tags: subheading + restyle filters to match Incidents (ISE-478)'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 483
sprint: sfv5yw0
blocked_by:
- 01KZ117G77Z9DFWS8KNYF26K55
comments:
- id: 01KZ1QWVDSE2WP7TRER2FG1AG2
  author: Steve Vine
  at: 2026-08-02T17:21:10.585144Z
  text: |-
    Done — PR #427, merged to staging (ad22ce7), staging CI green and deployed.

    Subheading now reads "Tags by signal frequency"; the window and integration controls fold into a labelled section, and the text box is the shared SearchInput with its own X clear button.

    No backend change here, deliberately: this box is a CLIENT-SIDE narrowing of the rendered cloud and does not re-fetch, because re-fetching would rebase the heat scale against the filtered subset and make a tag change colour as you type. It is the one screen where the shared search component is wired differently on purpose, so that is now stated at the call site.

    Like Events, clearing restores the 7d default window rather than emptying it.
assignee: steve
label: null
priority: medium
task_status: done
---
UI tweaks on the Tags page.

1. **Subheading** — change to: "Tags by signal frequency"
2. **Restyle** — restyle the Tags window to follow the same look and function as Incidents after ISE-478: text search box with X clear button, collapsible extended filter section on the line below, and the same styling on text and dropdown boxes.

Depends on ISE-478 (Incidents filter restyle) as the reference pattern.
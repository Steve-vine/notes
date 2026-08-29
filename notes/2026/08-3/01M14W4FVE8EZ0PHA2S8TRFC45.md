---
id: 01M14W4FVE8EZ0PHA2S8TRFC45
created: 2026-08-28T19:04:22.12683Z
updated: 2026-08-29T12:08:38.078859Z
type: task
title: 'The Reports tab: the library screen and a report''s page'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 490
sprint: s42ntc9
blocked_by:
- 01M14W44PF9GB1B05NCE4X0H9A
comments:
- id: 01M16PQYW5XR2M4NN6QF5ZQ2B3
  author: Steve Vine
  at: 2026-08-29T12:08:37.509323Z
  text: |-
    Done and merged to main — PR #503.

    The Reports tab sits after Coverage in Access Control, with the view tabs, because reading a report is reading rather than managing. The library lists this company's reports plus the shipped ones (which carry no company and appear in every library), grouped under **Standard reports** and **Written here** rather than one flat list — the backend already sorts the shipped set first, and the headings make that visible rather than merely true. Search covers the name *and* the question; a report without a question says so rather than showing a blank.

    A report's page shows the definition as a sentence — served by the API, so it is the same sentence the CSV preamble and the PDF subtitle carry — above the result table, with Run, Download, Duplicate, Edit and Delete. A standard report offers Duplicate and neither Edit nor Delete, since the next deploy would undo both and the way through is right there.

    Two things the task called for that turned out to be load-bearing rather than cosmetic:

    **The table renders the API's rendered values, not the raw ones.** An unread field reads "Unknown" and never as a blank cell that looks like "no" — which is the whole of what COM-492 and COM-497 spent their length keeping apart, and it would have been thrown away at the very last step by rendering raw nulls.

    **Truncation is an alert above the table**, not a tooltip, as the task specified.

    I also built the COM-494 History panel here rather than leaving it half-done, since this is the page that task put it on: runs newest first, each showing the definition *of the day* rather than today's, scheduled runs badged, failed runs marked with their reason, and a download link only where the file is still kept. The test asserts the history row reads "more than 30" while the live definition says "more than 90" — it would pass by accident if the panel re-rendered through today's definition.

    One behavioural fix found while building it: `useReportRun` now keeps the previous answer on screen while the next loads. The query key carries the company and the page, so without it the table blanked and reflowed on every page turn, and once on arrival when the company context resolved. The first version of the detail-page test caught it.

    `AccessControlPage.test.tsx` pins the tab list and needed the new tab adding — it did its job.
assignee: steve
company: null
label:
- feature
priority: high
task_status: done
---
A **Reports** tab in Access Control, sitting with the other view tabs.

**The library** lists every report: name, the question it answers, its subject, who wrote it, when it last ran. Standard reports are marked as such, and grouped so somebody arriving cold sees the shipped set first rather than a flat list of everything anyone has ever written. Search and filter by subject.

**A report's page** shows the definition in words a person reads — *Users, where the account is enabled and the last sign-in is more than 90 days ago* — above the result table, with Run, Download and Duplicate. The wizard (COM-491) opens from Edit.

Follows `brief/information-architecture.md` → *Screen conventions* for the page header, tab title, cards and pills. A truncated result says so on the face of the table, not in a tooltip.
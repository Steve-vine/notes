---
id: 01M57VTHCTKR8Q7VVTYS5ZG10M
created: 2026-10-18T15:59:26.618553Z
updated: 2026-10-19T20:43:50.747564Z
type: task
title: Attestations are evidence an auditor can take away — an export by period, role, content or person; "who has signed" on the content page; and the acknowledgement controls show it as Evidence of operation
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1101
sprint: s7s7mn9
blocked_by:
- 01M57VT48F8ZYXQ25TKZV4ET2W
comments:
- id: 01M58Z1GY38E06764Y9TDDFM9F
  author: Steve Vine
  at: 2026-10-19T02:14:55.683162Z
  text: |-
    Done: PR #1091, all checks green. It's now on main and re-testing before merge.

    - Export is on Attestations (the Open and Compliance tabs) and on a person's page. You pick a period, defaulting to the last 12 months, and can narrow it by roles, documents and people. You can pick several people at once, so "these 25 people" is one export. The page's own filters are already filled in.
    - It comes as Excel (a summary sheet plus the lines), CSV or PDF. Each line has the person, email, role, company, document, version, opened, due, signed at, status and the name they typed. The status is On time, Late, Outstanding, Overdue, Left the role, or Not signed — no longer asked.
    - The first page shows the period, when it was made, the filters, % compliant, who's overdue, who is included, what each status means, and the statement people signed.
    - An export is a snapshot of the moment it's made. It's built in the background and stays downloadable for 7 days by the person who made it. Making one is recorded in Activity, with counts only and no names.
    - The content page has an Attestations card for the company in the switcher. It shows which roles ask for the document and when each next round opens, how many have signed the current version, are outstanding or are overdue, and how many signed only an older version. It links to who has signed.
    - INS.2 and INS.15 on a company's assessment now show attestations as Evidence of operation, e.g. "40% compliant across 2 documents", the last round closed, the next opening and how many people are overdue. A company with nothing assigned shows an orange "No attestations assigned".

    Calls I made:
    - A period covers every request that opened in it, plus every signature made in it. The export says so on its first page.
    - The PDF is a plain table, not the house style.
    - Deleted content and roles still appear in exports, marked "(deleted)".
assignee: steve
label:
- feature
priority: medium
task_status: done
---
Sprint 78, Attestations (ADR in COM-1092). Builds on Compliance (COM-1100). It answers INS.2 and INS.15's "recorded against the individual and retrievable", and gives the auditor the population and sample they ask for.

## What people see

- **Export** on the Open and Compliance tabs, and on a person's page, as a **spreadsheet** or a **PDF**, for a chosen period and filtered by role, content or person. Each line has: person, email, role(s), document, version, opened, due, signed at, on time or late or outstanding, and the typed name. The PDF opens with a summary (period, % compliant, overdue count) and the statement people signed.
- **Content page ▸ Attestations card** (for people with `attestations.view`): which roles in this company assign it, with cadence and next round, and the **current version's** signed / outstanding / overdue counts, linking to Compliance ▸ By content.
- **Evidence of operation** on the acknowledgement controls, **INS.2** and **INS.15** (keys ACU.2 and s42.INS.5), in a company's assessment: "Attestations: 94% compliant across 12 documents; 7 people overdue; last round closed 3 Oct". It links to the module. A company with nothing assigned shows "No attestations assigned", which is itself the useful finding.

## Rules

- The export is a snapshot as at when it's made, with that time printed on it.
- Exports are recorded in the activity log, because they contain personal data.

## Notes (technical)

- Register Attestations as a source in the Evidence of operation `SOURCES` registry (ADR 0115), keyed by `CoreControl.key`, not the displayed ref (memory "Control key vs ref").
- Reuse the reports export plumbing for the spreadsheet and the house-style PDF path.

**Done when:** an auditor's "show me acknowledgements for these 25 people" is one export, the content page says who has signed it, and INS.2 and INS.15 show attestation evidence on the assessment.
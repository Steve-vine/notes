---
id: 01M57VTHCTKR8Q7VVTYS5ZG10M
created: 2026-10-18T15:59:26.618553Z
updated: 2026-10-18T15:59:48.10445Z
type: task
title: Attestations are evidence an auditor can take away — an export by period, role, content or person; "who has signed" on the content page; and the acknowledgement controls show it as Evidence of operation
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1101
sprint: s7s7mn9
blocked_by:
- 01M57VT48F8ZYXQ25TKZV4ET2W
assignee: steve
label:
- feature
priority: medium
task_status: todo
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
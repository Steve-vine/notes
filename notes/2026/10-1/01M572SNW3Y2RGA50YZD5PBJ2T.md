---
id: 01M572SNW3Y2RGA50YZD5PBJ2T
created: 2026-10-18T08:42:04.035869Z
updated: 2026-10-18T08:42:04.035869Z
type: task
title: An incident keeps its evidence — files uploaded to it, and a log of evidence held elsewhere (what, where, collected by whom and when) — and nothing can be removed once it's closed
priority: medium
assignee: steve
label: feature
task_status: todo
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1073
---
Sprint 76, Incidents - Register (ADR in COM-1063). Builds on COM-1066. It answers ISO 27001 A.5.28 and IMA.6.

## What people see

An **Evidence** card on the incident with two kinds of entry:

- **Uploaded files**: screenshots, exported logs, the vendor's report, copies of notifications. They use the same file rules as assessment and SAP evidence.
- **Evidence held elsewhere**: a row for each piece Compass doesn't hold, such as a disk image, a SIEM export or a mailbox hold. Each row records:
  - what it is;
  - where it is kept ("forensics share, case 2026-14");
  - who collected it and when;
  - an optional integrity reference (a hash or seal number);
  - who has had it since, added as dated entries.

Timeline entries and notifications can attach files too. Those also show here, labelled with where they came from.

## Rules

- While the incident is open, a handler can remove a file they added, with a reason. The removal is recorded on the timeline.
- **Once closed, evidence can be added (with a reason) but never removed**, as with SAP.
- Restricted incidents hide their evidence (later task).

## Notes (technical)

- Polymorphic `attachment` with `owner_type='incident'`. Keep the custody hand-offs as append-only rows.

**Done when:** files and held-elsewhere evidence can be recorded; custody hand-offs append; nothing can be removed from a closed incident.
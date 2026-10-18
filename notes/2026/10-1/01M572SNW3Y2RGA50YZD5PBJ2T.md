---
id: 01M572SNW3Y2RGA50YZD5PBJ2T
created: 2026-10-18T08:42:04.035869Z
updated: 2026-10-18T14:37:03.51137Z
type: task
title: An incident keeps its evidence — files uploaded to it, and a log of evidence held elsewhere (what, where, collected by whom and when) — and nothing can be removed once it's closed
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1073
sprint: serbigk
blocked_by:
- 01M572Q0FYNV11AEM6VZXWZ99Q
comments:
- id: 01M57Q3N00CE9EXE83WJ43MFGG
  author: Steve Vine
  at: 2026-10-18T14:37:02.336555Z
  text: |-
    Done: merged in PR #1072.

    - Every incident has an **Evidence** card.
    - Handlers upload files (screenshots, logs, the vendor's report) with an optional description. Anyone who can see the incident can download them.
    - Files attached to timeline entries and notifications also appear here, labelled with where they came from, e.g. "From notification: UK GDPR: tell the ICO".
    - **Evidence held elsewhere** records:
      - what it is and where it's kept;
      - who collected it (a colleague or a name) and when;
      - an optional hash or seal number.
      Each hand-off is added as a dated entry, and the card shows "Now with: …".
    - While the incident is open, the person who added a file can remove it, with a reason. The record stays on the card under "removed files", with who, when and why, but the file can no longer be downloaded.
    - Once the incident is closed, evidence can still be added, each piece with a reason, but nothing can be removed.
    - Every addition, removal and hand-off goes on the timeline.

    Choices made:
    - Only the person who added a file can remove it.
    - Held-elsewhere items and hand-offs can't be edited. A wrong one is put right by recording a new one.
    - Hand-offs can still be recorded after closure, with a reason, because a disk image may move to legal or the archive later.
assignee: steve
label:
- feature
priority: medium
task_status: review
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
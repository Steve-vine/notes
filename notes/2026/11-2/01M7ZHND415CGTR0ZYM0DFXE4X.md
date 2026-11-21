---
id: 01M7ZHND415CGTR0ZYM0DFXE4X
created: 2026-11-21T17:15:02.657126Z
updated: 2026-11-21T17:46:46.654185Z
type: task
title: Evidence on a plan entry goes out of date by its evidence type, even once the entry is done
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2075
sprint: s9hexqn
comments:
- id: 01M7ZKFB41XTEDKTMCV2YQZQQ6
  author: Steve Vine
  at: 2026-11-21T17:46:41.153636Z
  text: |-
    Done and merged to main (PR #2067). No migration, no API change.

    What changes:
    - A file or web address on a plan entry now goes out of date by its evidence type, just like evidence added straight on a control, whether the entry is open, Done or Cancelled. Its valid-until is the date someone set, or else the type's "Valid for" counted from the end of the period it covers. If it has no period, that's the end of the entry's due window.
    - It shows Due soon, then Out of date, everywhere it appears: the control's Evidence tab and Assessment screen, Audit ▸ Evidence and its Out of date list, the piece's own page, packs and Polaris's answers. A piece still in date shows its valid-until date instead of "doesn't go out of date".
    - The plan entry still reads Done, and a finished entry keeps the evidence it was finished with.
    - Incident evidence, data subject request evidence and an approved risk assessment's PDF still never go out of date.
    - Out of date still only warns. It never changes a control's status, maturity or gaps.

    ADR 0122 §8 has an amendment appended. Polaris's out-of-date tool description is updated. Tests cover Done, Cancelled and open entries (a dated file, an undated file and a web address in each), plus incidents and data subject requests still never going out of date.

    Calls for you to overturn:
    - A plan piece going out of date doesn't raise a to-do of its own. The plan already reminds the owner when the next round is due, and that round's evidence brings the control back in date.
    - A plan piece with no period counts from the end of the entry's due window, not from the day it was added. This only affects older pieces: Add evidence already fills the period in.

    Possible follow-up: a plan piece's valid-until can only be set when it's added. As before, there's no way to push it out later in Audit ▸ Evidence or on the plan screen.
assignee: steve
label:
- improvement
priority: high
task_status: review
---
Steve's decision (21 Nov), option 2 of the valid-until mismatch found in sprint 120's pre-UAT.

## The problem
- Evidence on a plan entry that's Done or Cancelled counts as "finished work". It reads "doesn't go out of date" and stays current for the entry's controls forever.
- The same evidence type added directly on a control goes out of date after the type's "Valid for", usually a year.
- So a control can show last year's annual review as current indefinitely. Only the plan itself warns when the next round is late.

## What people see
- A piece of evidence on a plan entry (a file or a web address) has a valid-until like any other piece. It's the date someone set, or else the evidence type's "Valid for" counted from the end of the period it covers. For a plan entry, that period defaults to the entry's due window.
- It goes Due soon, then Out of date, everywhere it shows: the control's Evidence tab and Assessment screen, Audit ▸ Evidence and its Out of date list, the piece's own page, and Polaris's answers. This holds whether the entry is open, Done or Cancelled.
- The plan entry itself still reads Done. Nothing about completing an entry changes.
- Incidents, data subject requests and an approved risk assessment's PDF keep the "doesn't go out of date" rule. They record what happened; they aren't repeating proof that a control works.
- As before, being out of date only ever warns. It never changes a control's status, maturity or gaps.

## Implementation notes
- The "finished" rule for plan evidence is in core/evidence_register.py (`_plan_files`, the plan web-address listing, and any other place that uses FINISHED_SAP_STATUSES to mark evidence finished). Check SAP's own "evidence of operation" read and Polaris's tools and instructions for the same assumption, and any frontend wording that says plan evidence "doesn't go out of date".
- Docstrings and briefs that list "a file on a done or cancelled plan activity" as finished work need updating.
- ADR: append an amendment to ADR 0122 §8 (append-only, the way ADR 0041 and ADR 0164 §5 were amended). It should say plan entry evidence now follows its evidence type, and why.
- On the chain or independent: independent, unless an API field or enum changes.

## Done when
- A piece on a Done plan entry, whose valid-until (set, or worked out) has passed, shows Out of date on the entry's controls and in Audit ▸ Evidence ▸ Out of date.
- A piece on a Done entry still within its validity shows its valid-until date, not "doesn't go out of date".
- Incident, data subject request and risk assessment evidence still never go out of date.
- Tests cover the done, cancelled and open entry cases.
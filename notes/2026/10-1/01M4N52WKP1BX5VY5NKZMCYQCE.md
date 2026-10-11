---
id: 01M4N52WKP1BX5VY5NKZMCYQCE
created: 2026-10-11T09:35:43.222653Z
updated: 2026-10-11T10:58:39.084175Z
type: task
title: CIS's Implementation Groups become levels — IG1, IG2, IG3, with a "Working towards" choice on the CIS page
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 906
sprint: s4gilxe
blocked_by:
- 01M4N5259GNVX9RR4ZZ24T6HFN
comments:
- id: 01M4N9TPY488PE5P7KM1ZPDZMQ
  author: Steve Vine
  at: 2026-10-11T10:58:38.148098Z
  text: |-
    Merged to main as PR #908 (2026-10-11). Goes to staging with the rest of the sprint.

    What is there
    - Both CIS versions in the library (v8 and v8.1) have the levels IG1, IG2 and IG3. A safeguard's level is the Implementation Group CIS publishes for it: 56 at IG1, 74 at IG2, 23 at IG3.
    - The CIS page has the "Working towards" choice HITRUST has. It is the company's own.
    - Until someone chooses, CIS is measured at IG3: every safeguard. No CIS figure moves when this ships.
    - Choosing IG1 measures 56 safeguards and lists 97 as above IG1. IG2 measures 130 and lists 23. They are not gaps and not out of scope.
    - The Dashboard, the Statement of Applicability and the coverage report name the group they were measured at, and changing it is in the audit trail and marks the trend. All of that came from the HITRUST work with no CIS code of its own.
    - Tiers are worked out exactly as before.

    What to expect on staging
    - The levels arrive when the deploy's seed import runs, not through a migration. Until that job has finished, the CIS page shows no "Working towards" choice.
    - The choice can only be made on v8.1. v8 is superseded and takes no new decisions, as before.

    Decisions I took
    - A safeguard that has a level shows it once. The coverage list used to show the group as a badge; with levels it would have read "IG1 IG1", so the level badge takes over where a safeguard has both.
    - A level somebody corrected in the library is kept on every later import, and so are level names somebody edited. The Implementation Group label itself is never changed by an edit to the level.
    - The page does not call a CIS level "Compass's reading". That wording is HITRUST's own description and CIS's groups are the publisher's assignment.

    Technical
    - seed/frameworks.py: CIS_LEVELS on both CIS entries; a row with no level column takes its implementation_group where the framework has levels; a framework that gained levels after first import gets them where unset.
    - One existing test used CIS as its example of a framework with no levels; it uses SOC 2 now.
assignee: steve
label:
- feature
priority: medium
task_status: review
---
Part of sprint 68, Compliance (ADR in COM-904). CIS has had Implementation Groups as a label since COM-603. This makes them levels in the sense HITRUST has them (ADR 0100), so the Compliance page can offer IG1 to IG3.

## What people see

- **The CIS page has a "Working towards" choice:** IG1, IG2 or IG3. It is the company's own.
- **Until someone chooses, it is IG3,** which is every safeguard. No CIS figure moves on the day this ships.
- **Once a group is chosen, CIS is measured at it,** exactly as HITRUST is at its level: the headline names it, safeguards above it are listed as above the group and not counted, the Dashboard, the Statement of Applicability and the coverage report say which group.
- **Both CIS versions in the library get it:** v8 and v8.1.
- **Changing the group is in the audit trail** and marks the trend, as a HITRUST level change does.
- **The group shown beside each safeguard is unchanged,** and so is how tiers are worked out.

## Notes (technical)

- **Data.** Both CSVs already carry `implementation_group` on all 153 safeguards (56 / 74 / 23). Set the two frameworks' level labels to `IG1`, `IG2`, `IG3` and fill each requirement's `level` from its group.
- **Do it in the seed importer, not a migration** — the seed import runs on every deploy and would otherwise undo it. Follow how HITRUST's labels and levels arrive.
- **Keep `implementation_group`.** The tiering rule (ADR 0069) reads it. Check nothing else treats a non-null `level` as "this is HITRUST".
- **Everything else should come for free** from COM-878: the picker, `PUT /frameworks/{slug}/target-level`, the above-level section, SoA, reports, the timeline mark. Walk each on a CIS framework and fix what assumed three specific labels.
- **Framework tests pin counts and rules** in five files (see the framework checklist); run `pytest -q` with no `-m` before pushing data.
- A library editor can edit a requirement's level (ADR 0100 §7). For CIS the group is published by CIS, not Compass's reading: make sure the page does not label it as a reading, and decide in COM-904 whether editing level and group can drift apart.

**Done when:** on staging, choosing IG1 for a company on CIS v8.1 measures 56 safeguards and lists 97 as above IG1, another company is unaffected, and tiers are unchanged.
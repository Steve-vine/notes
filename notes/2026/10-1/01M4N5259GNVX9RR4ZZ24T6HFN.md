---
id: 01M4N5259GNVX9RR4ZZ24T6HFN
created: 2026-10-11T09:35:19.344054Z
updated: 2026-10-11T09:44:11.183137Z
type: task
title: 'ADR: Timeline becomes Compliance — today''s picture above the trend, a level you can look at without changing the target, and CIS''s Implementation Groups as levels'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 904
sprint: s4gilxe
comments:
- id: 01M4N5JCNF0EJSB3A0T8ZBB5BB
  author: Steve Vine
  at: 2026-10-11T09:44:11.182986Z
  text: |-
    Merged to main as PR #906 (2026-10-11). Documentation only; nothing to see on staging.

    What is recorded
    - The record is ADR 0102, not 0101: that number went to COM-903 the same morning.
    - Timeline becomes Compliance, with a gauge above the trend.
    - Measure (Core controls, or one or more frameworks) and a tier or level filter choose the slice. A framework is measured by its own requirements, one gauge each.
    - The gauge and the compliance trend follow the filter. Open gaps, Maturity and Risks stay whole-company. The separate Frameworks chart goes.
    - A chip opens the list behind its figure.
    - Looking at a level never changes the level a company is working towards.
    - CIS's Implementation Groups become levels. This reverses the "CIS is unchanged" call in ADR 0100 from 2026-10-08, and gives the CIS page a "Working towards" choice. Until someone picks, CIS is measured at IG3, so no figure moves.

    Decisions I took
    - History per level is stored, not replayed on demand. Each night records every level; a one-off pass adds the same breakdown to days already recorded and marks it as reconstructed. It adds to those days and changes nothing they already hold.
    - The line at a company's own level is copied from what was recorded, so it stays the line people have already seen.
    - A level's line starts where its framework's line starts. HITRUST joined on 2026-10-10 and has no earlier points at any level.
    - A CIS safeguard's level is filled from its Implementation Group where unset. An editor can still change it by hand, as on any framework; the two are not forced to stay equal.
    - The Implementation Group label stays, and tiers are worked out from it as before.
assignee: steve
label:
- brief
priority: high
task_status: active
---
First task of sprint 68, Compliance. It records the sprint's decisions before any code lands and gates the rest. Scoped with Steve on 2026-10-11.

## What is decided

- **Timeline is renamed Compliance.** Same place in the menu. It answers two questions on one page: where the company stands today, and how that has moved.
- **A gauge sits above the charts,** in the Assessment page's style: the percentage, the count, the bar split by status, and the status chips.
- **A filter chooses what is measured:** Core controls, or one or more frameworks.
- **A second filter narrows it:**
  - Core controls by tier: Essential, Expected, Specialised.
  - A framework by its levels: e1, i1, r2 for HITRUST; IG1, IG2, IG3 for CIS.
  - A framework with no levels has no second filter.
- **A framework is measured by its own requirements** (Steve's call). HITRUST here is the same figure as on the Dashboard and the Frameworks page. Several frameworks give one gauge each, never one blended number.
- **The gauge and the compliance trend follow the filter** (Steve's call). Open gaps, Maturity and Risks stay whole-company and say so.
- **A chip opens the list behind its figure** (Steve's call): the Assessments queue for Core controls, the framework's page for a framework, already narrowed to that slice and status.
- **Looking at a level is not choosing it.** The page opens at the level the company is working towards. Picking another shows that level and changes nothing about the target, the Dashboard or any report.
- **CIS's Implementation Groups become levels** (Steve's call). CIS gets what HITRUST has, including the "Working towards" choice on its page. Until someone chooses, CIS is measured at IG3, which is everything, so no figure moves on the day this ships.
- **No text search, no Maturity filter, no Domain filter, no "Owned by me"** on this page.

## Notes (technical)

- **Number.** Next free is 0101; check `decisions/` before writing, as 0100's number moved the same way.
- **Amends** ADR 0070 (what the daily snapshot records; the page's name and purpose), ADR 0100 (a level can be viewed without being the target; CIS joins), ADR 0069 only if the tiering rule's reading of `implementation_group` changes (it should not).
- **History per level.** The snapshot records each framework at the company's level only. Decide here how every level is kept: recommended is a per-level breakdown inside each framework's entry in the snapshot, measured nightly, plus a one-off rebuild for days already recorded. Say how a rebuilt per-level figure on an otherwise observed day is labelled, since ADR 0070 forbids rewriting an observed row.
- **CIS.** `implementation_group` stays, because the tiering rule reads it and CIS publishes it. Decide whether `level` is filled from it at import or the two are kept in step some other way; the model's comment at `framework_requirement.py` anticipated this.
- **Brief.** Update `brief/information-architecture.md` for the rename in the same PR or in the rename task.

**Done when:** the ADR is merged and the remaining tasks cite it.
---
id: 01M4EDWB7JZG4NSWXHHX7X6V34
created: 2026-10-08T18:54:44.978276Z
updated: 2026-10-10T17:42:08.073999Z
type: task
title: HITRUST CSF v11.8 is in the Frameworks list — 156 controls under their categories and objectives, each with its level and its domain
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 876
sprint: sfkkkex
blocked_by:
- 01M4EDVNHF9HDF1D20RGKHR29N
comments:
- id: 01M4KEGQTEB4ZJN4G6Y9599NVC
  author: Steve Vine
  at: 2026-10-10T17:42:05.390289Z
  text: |-
    Merged to main as PR #900 (2026-10-10). Goes to staging with the rest of the sprint.

    What is there: HITRUST CSF v11.8.0 in the Frameworks list — 14 categories, 49 objectives, 156 controls. Each control has a level pill and a domain. The page says both are Compass's reading of public material. A library writer can correct either from Edit, and the correction survives later imports.

    WHAT COULD AND COULD NOT BE SOURCED (the count the task asked for)

    Names
    - Controls: 148 of 156 read in a public source, reference and name together. All 135 security controls are in two sources.
    - 6 privacy control names (13.f, 13.o, 13.p, 13.r, 13.t, 13.u) seen only in a search-result excerpt.
    - 2 privacy control names found nowhere by name: 13.i Collection Limitation, 13.q Privacy and Impact Assessment. An assessor's guide paraphrases them; the names are my reading and may not be HITRUST's wording.
    - Objectives: 39 of 49 read in a source; 4 from a search excerpt; 6 named from a paraphrase (09.03 and five of the privacy objectives).
    - 13.d reads "Consent Required" in the one source that names it.

    Domains — 80 of 156 sourced, 76 unverified
    - Sourced from Microsoft's public HITRUST compliance page, HITRUST's own example reports, and a HITRUST paper hosted by NIST.
    - The 76 are filed under the domain most common among the sourced controls in the same objective (failing that, category). All 21 privacy controls are unverified and filed under Data Protection & Privacy.
    - Wireless Security has no control of its own: everything HITRUST asks under it sits beneath 09.m Network Controls, which belongs mainly to Network Protection. It still gets its row.

    Levels — 11 of 156 sourced, 145 unverified
    - e1 (8): 01.c, 01.k, 01.q, 01.x, 04.a, 09.k, 09.m, 09.o.
    - i1 (3): 01.m, 05.a, 07.b.
    - Everything else is filed at r2.
    - This is the weak point. HITRUST publishes no table of which controls e1 and i1 touch; its example reports are truncated samples, and that is all there is in public. So until somebody who holds the CSF corrects the levels in the library, choosing e1 or i1 on the page counts a handful of controls. The picker works; the tags behind it are a starting point.

    Version: no public list specific to v11.8.0 exists. The skeleton is what the sources agree on; HITRUST's own 2023 example report prints exactly these 156 references.

    Not used, deliberately: third-party copies of the full CSF PDF came up in searches (Scribd, a HubSpot-hosted copy). They were not opened — that is the licensed package, and ADR 0100 rules it out.

    Technical
    - All of the above, row by row, is in hitrust-csf-v11-8.SOURCES.md beside the CSV.
    - Migration 0240_framework_levels (frameworks.levels, framework_requirements.level). No data pass; the import Job brings the rows.
    - Three existing tests counted frameworks: 10 → 11.
assignee: steve
label:
- feature
priority: high
task_status: review
---
Part of sprint 66, HITRUST Framework (ADR in COM-875). This puts HITRUST into the library. On its own it shows every control as not covered; the crosswalk task is what gives it a readiness figure, so the two go to staging together.

## What people see

- **The Frameworks list gains HITRUST CSF**, version v11.8.0.
- **Opening it shows HITRUST's own structure:** 14 categories, the 49 objectives beneath them, and the 156 controls beneath those. Categories and objectives are headings only; nothing is assessed against them.
- **Each control shows** its reference (for example 01.a), its name, a level pill (e1, i1 or r2) and the domain it belongs to.
- **There is no requirement text.** As with other frameworks, an organisation can add the text it is licensed for.
- **The page says where the levels and domains came from:** Compass's reading of public material, not HITRUST's own assignment. Anyone who can edit the library can correct a control's level or domain.
- **Any control can already be ruled out of scope** for a company with a reason, or disabled in the library, as on every other framework.

## Notes (technical)

- **Data file.** `data/frameworks/hitrust-csf-v11-8.csv` with `ref,title,parent_ref,assessable,part,level`.
  - Categories and objectives are grouping rows (`assessable=false`); controls are the assessable rows.
  - Seed tuple: slug `hitrust-csf-v11-8`, name `HITRUST CSF`, version `v11.8.0`, effective 2026-05-07. No `supersedes`.
- **Sourcing rules.** Nothing is written from memory.
  - Every category, objective and control name is checked against a public source, and the sources are listed in a `SOURCES` note beside the CSV.
  - Leads: HITRUST's own sample e1 / i1 / r2 reports ("Example HITRUST Deliverables" on help.mycsf.net and hitrustalliance.net), HITRUST advisories, Microsoft Learn's HITRUST control pages, assessor guides.
  - A test asserts the counts (14 / 49 / 156). If v11.8 really differs, the source wins and the test and this task say so.
  - No requirement statements, implementation levels or illustrative procedures go into the repo.
- **Level.** The lowest of e1 / i1 whose published requirements touch the control; otherwise r2. Stored as 1 / 2 / 3.
- **Domain.** The control's main assessment domain, stored in `part`. A control whose requirements straddle domains is filed under the one that carries most of it.
- **Unverified tags.** Where a level or domain cannot be found in public material, the control defaults to r2 and its category's nearest domain, and is listed as unverified in `SOURCES`. Report the unverified count to Steve in the task comment.
- **Migration.** `framework_requirements.level` (small integer, nullable) and the ordered level labels on `frameworks`.
  - The importer fills `level` wherever unset, like the other structural attributes, and sets the labels when the framework row is created.
  - Deployed databases get the rows from the post-upgrade import Job; no data pass in the migration.
  - Revision id 32 characters or fewer.
- **Domain names.** `PART_LABELS` and `PART_ORDER` in `core/coverage.py` gain the nineteen domains, in HITRUST's order. Slugs must fit `part` (30 characters).
- **The provenance line.** Carried in the framework's `description`, set on create.
- **API.** `levels` on the framework, `level` on the requirement and on the coverage row; `level` and `part` editable through the existing requirement update. Regenerate `schema.d.ts`.
- **Page.** The level pill sits where the CIS Implementation Group pill does on `FrameworkDetailPage.tsx`, labelled from the framework's level labels. It never truncates.
- **Tests.** An importer test in the shape of `test_cyber_essentials_danzell.py`: counts, the tree resolves, every control has a level and a domain, every domain slug has a label.

**Done when:** staging lists HITRUST CSF v11.8.0 with 156 controls under their categories and objectives, each with a level pill and a domain, and the page carries the provenance line.
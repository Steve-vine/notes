---
id: 01M738TDP2RCFA4KACRVYF7JEV
created: 2026-11-10T17:41:45.794441Z
updated: 2026-11-10T19:03:22.962469Z
type: task
title: Every SOC 2 point of focus written down in audit/, numbered, so each one can be given exactly one control
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1683
sprint: s6acz3m
assignee: steve
label:
- chore
priority: high
task_status: active
---
**Why.** The review (COM-1684..1688) judges every criterion against its points of focus (rules in COM-1682), so it needs a complete, numbered list of them. All of them are covered, not just the ones this year's auditor tests (Steve, 2026-11-10).

**Source.** `~/audit-sources/Trust-services-criteria.pdf` on g5. Steve downloaded it 2026-11-10. It stays out of the repo.
- **What it is.** AICPA TSP Section 100, *2017 Trust Services Criteria (With Revised Points of Focus – 2022)*: 75 pages, dated October 2022, revised March 2024. The file is titled "Red-Lined Version", but the text has no crossed-out wording: everything except headings and links is plain black.
- **Checked 2026-11-10.** It holds all 61 criteria and **330 points of focus**. Extracted with pypdf, 330 bullets in the criteria section, all accounted for.
- **Carbide has the older 2017 points of focus.** It holds only 37 criteria and 216 points. Of those 37 criteria, 19 have a different number of points from the 2022 text, for example:
  - CC8.1: 18 points now, against 14 in Carbide;
  - CC2.1: 9 against 4;
  - CC6.1: 13 against 10;
  - CC7.3: 7 against 4.

  The wording differs too. So the AICPA document is the source, and Carbide isn't used.
- **Privacy points are tagged.** Each is marked as likely relevant to a data controller `[C]` (56) or a data processor `[P]` (44). Moneypenny is likely both. Every point is covered either way, but keep the tag in the list.

**What changes:**
- Add `audit/mapping/soc2-points-of-focus.json`. It holds, for each of the 61 criteria, its points numbered (e.g. `CC6.1-03`), each with:
  - its title and the AICPA wording;
  - its group: COSO, additional, or additional for privacy;
  - for privacy points, the `[C]`/`[P]` tag.
- Points that apply only in particular circumstances are still covered: the reviewer decides on each one rather than skipping it.
- Record in `audit/README.md` the source and its version, and that Carbide's points are the pre-2022 set.

**Where.** `audit/` only; no app change. **Independent.**

**Done when:**
- All 61 criteria and all 330 points are listed.
- The count per criterion matches the PDF.
- The README records the source.
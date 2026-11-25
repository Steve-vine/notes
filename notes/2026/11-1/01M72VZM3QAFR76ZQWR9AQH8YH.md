---
id: 01M72VZM3QAFR76ZQWR9AQH8YH
created: 2026-11-10T13:57:24.727972Z
updated: 2026-11-25T14:18:17.844166Z
type: task
title: ISO 42001 crosswalk completeness review — every library control that serves a requirement is linked to it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1679
comments:
- id: 01M89BX4M8Z0P0CC5TGW5TKKK9
  author: Steve Vine
  at: 2026-11-25T12:46:48.968575Z
  text: |-
    PR #2169 (top of the stack, on COM-1677 #2168).

    All 65 assessable clauses and Annex A controls reviewed against their intent and the Annex B guidance. 61 gain links, 4 needed nothing (7.2, A.2.4, A.7.6, A.9.3). 152 links added (158 → 310), 55 controls new to ISO 42001 — AI controls and the general controls that plainly cover AI systems too — all partial, each graded with a note.

    What was missing: risk opportunities, appetite, method and treatment tracking (6.1.x, 8.2, 8.3); the management-system controls — audit plan, management review, change planning, records and retention, documented procedures; suppliers across A.10 (agreements, shared responsibility, monitoring, model changes, subcontractors, exit); external reporting and incident communications (A.8.3/A.8.4); lifecycle and logging (A.6); data purpose, lawful basis and provenance (A.7); and the AI controls linked to each other where one serves another's clause.

    For a curator — existing links that look overstated (not changed):
    - 9.2, 9.3, 10.1 AIG.17 "does the whole job" on all three: one control can't be the audit programme, management review and improvement at once.
    - 5.3 AIG.1 "does the whole job": doesn't assign reporting AIMS performance to top management.
    - A.2.4 INS.5 "does the whole job": a general policy lifecycle the AI policy still has to join.
    - A.3.3 IMA.3: security weaknesses only — an overlap.
    - A.8.4 IMA.10 at 6: breach-notification misses most AI failures.
    - A.10.4 VEM.3: supplier contracts say little about obligations to customers. Looks wrong.

    Now look jointly complete (not declared): A.10.2, A.10.3, A.6.2.8, A.8.3, A.8.4, 6.1.1, 10.2.
assignee: steve
label:
- improvement
priority: low
task_status: done
---
Follows the SOC 2 finding (COM-1669, `audit/soc2-mapping.md`): COM-428 built every crosswalk requirement-first, choosing the smallest set of controls that satisfies each requirement, and the tests check coverage, not completeness. So relevant library controls can be missing from a requirement.

ISO 42001 is held as titles only. Review each clause and Annex A control against its intent and link every library control (AI governance and general) that serves it, graded the same way as today. Edit `data/mappings/iso-42001-2023.csv` only; the deploy-time importer applies it. Data only. **Independent.**

**Done when:** every requirement has been reviewed, the additions are graded with notes, and the crosswalk tests are green.
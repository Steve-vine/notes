---
id: 01M0Z992TBV07R7WE2XHZRBB19
created: 2026-08-26T14:58:37.515715Z
updated: 2026-09-01T13:55:53.220958Z
type: task
title: ISO 27001 gains clauses 4–10 — the half you actually certify against
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 420
sprint: s8cjs5n
comments:
- id: 01M10B0XCYPR8APFC4FK87FNH9
  author: Steve Vine
  at: 2026-08-27T00:48:21.405986Z
  text: |-
    Done — PR #424, merged to main.

    **What shipped**

    - **25 requirements at sub-clause level** — 4.1–4.4, 5.1–5.3, 6.1.1–6.1.3, 6.2, 6.3, 7.1–7.5, 8.1–8.3, 9.1–9.3, 10.1, 10.2. Sub-clause is the grain an auditor writes a finding against. ISO now reads 118 requirements rather than 93.
    - Same framework row, same version — a certificate covers one standard, so not a second framework. Refs and titles only; clause text is copyrighted (ADR 0028).
    - **Amendment 1:2024** arrives with it: clauses 4.1 and 4.2 carry the climate-change requirement, described in our own words rather than reproduced.
    - `part` splits the standard so coverage reports the management system and Annex A separately. A company whose controls are in good shape and whose management system is not is the usual ISO finding, and one blended percentage hid it. The parts are accumulated in the same pass as the whole, so they cannot disagree — there is a test for that.

    **The bit that would have bitten silently**

    The importer is insert-missing-only, so it sets `part` on the 25 new rows and **never** on the 93 that already exist. Left null, those 93 fall outside the `annex_a` group and the Statement of Applicability — whose whole job is to list every Annex A control — comes out **empty on every existing deployment**, while fresh CI databases pass because there the importer inserts all 118 at once. The migration backfills them.

    **The SoA is now the artefact clause 6.1.3 d) describes**

    Annex A only — an SoA states which controls you selected, and clauses are not controls. And it states the management system scope.

    **One assumption worth confirming.** The brief said the SoA "must state the ISMS scope" but nothing in the schema held one. I added a per-(company, framework) row rather than hanging it off Company, because COM-430 needs a second, independent Statement of Applicability. That turned out to be the right call — COM-430's test now sets two different scopes and checks the two exports are independent. The scope label is generic ("Management system scope") because 42001's is an AIMS, not an ISMS.

    **Tests**: `test_iso_clauses.py` — 10 cases. Existing ISO counts moved 93 → 118 across four other suites. Full CI green.
assignee: steve
label:
- feature
priority: high
task_status: done
---
The ISO library holds Annex A and nothing else. All 93 controls are present and
correct — 37 organisational, 8 people, 14 physical, 34 technological, right
titles, right order. That half is fine.

The other half is missing. **Clauses 4 to 10** are the certifiable requirements:
context of the organisation, leadership, planning, support, operation,
performance evaluation, improvement. Annex A is a reference control set you
select *from*; the management system is what a certification body audits.

So today Compass can say "we do 93 controls" and cannot answer "are we
certifiable". It also cannot produce a real Statement of Applicability, which
ADR 0011 promised in its title — an SoA is a clause 6.1.3 d) output that lists
every Annex A control with an applicability decision and a justification, and it
only means something inside a documented ISMS.

This is also the largest single driver of the governance gap: the unmapped Annex
A controls cluster around management responsibility, and the clauses are where
that actually lives.

## What changes for the reader

The ISO framework has two parts: **the ISMS** (clauses 4–10) and **Annex A
controls**. Coverage is reported for each. A company can see that its controls
are in good shape while its management system is not — which is the usual
finding, and currently invisible.

**Amendment 1:2024** arrives with this: clauses 4.1 and 4.2 require the
organisation to determine whether climate change is a relevant issue, and
whether interested parties have climate-related requirements. It touches only the
clauses, which is why it has been unrepresentable until now.

## Implementation

- Roughly 30 requirements at the sub-clause level — 4.1, 4.2, 4.3, 4.4, 5.1, 5.2,
  5.3, 6.1.1…6.1.3, 6.2, 6.3, 7.1…7.5, 8.1…8.3, 9.1…9.3, 10.1, 10.2. Sub-clause
  is the right grain: it is what an auditor writes a finding against.
- Same framework row, same version. A `part` or `section` attribute separates
  ISMS clauses from Annex A so coverage reports can split them. Do **not** create
  a second framework — a certificate covers one standard.
- Clause text is copyrighted, so ship refs and titles only and leave descriptions
  to in-app enrichment (ADR 0028). Titles are the clause headings, which are
  quotable.
- Most clauses will map to the new governance controls, so this task's mappings
  land with the crosswalk rebuild rather than here.
- The SoA export changes shape: it must state the ISMS scope, and for each Annex A
  control give applicability, justification, and whether it is implemented. Check
  it against clause 6.1.3 d) before calling it done.

Tests: coverage splits ISMS from Annex A; the SoA export renders every Annex A
control with a decision; clause 4.1 exists and mentions climate.

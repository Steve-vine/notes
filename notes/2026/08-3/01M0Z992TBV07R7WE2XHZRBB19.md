---
id: 01M0Z992TBV07R7WE2XHZRBB19
created: 2026-08-26T14:58:37.515715Z
updated: 2026-08-26T15:02:03.037745Z
type: task
title: ISO 27001 gains clauses 4–10 — the half you actually certify against
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 420
sprint: s8cjs5n
assignee: steve
company:
- moneypenny
label:
- feature
priority: high
task_status: backlog
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

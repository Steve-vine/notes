---
id: 01M0Z98E5EST4YBHW9RA5B9GNS
created: 2026-08-26T14:58:16.366769Z
updated: 2026-08-26T15:02:23.039118Z
type: task
title: CIS moves to v8.1 and SOC 2 gets the name it is actually assessed under
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 419
sprint: s8cjs5n
blocked_by:
- 01M0Z96KW5NKNYZM3G0HBSZ976
assignee: steve
company:
- moneypenny
label:
- chore
priority: medium
task_status: backlog
---
Both libraries are correct. Both are labelled wrong. This is the cheapest
accuracy win in the sprint.

**CIS Controls v8 → v8.1.** All 153 safeguards across 18 controls are present and
correctly referenced — the review found no errors. v8.1 (June 2024) keeps the
same 153 safeguards with the same numbering, so this is a relabel and a text
refresh, not a re-import. What v8.1 adds is worth having:

- a **Govern** security function, taking CIS to six functions and aligning it to
  NIST CSF 2.0 — which is the same spine the new domain structure uses, so the
  two reporting views line up;
- a **Documentation** asset class (plans, policies, procedures) alongside
  Devices, Users, Applications, Data, Networks and Software;
- clarified safeguard descriptions.

**SOC 2.** All 61 criteria are present and correct — 33 common criteria plus 3
availability, 2 confidentiality, 5 processing integrity and 18 privacy. The
operative version is the **2017 Trust Services Criteria with revised points of
focus (2022)**, and the AICPA has issued nothing newer. Record it as such, so a
reader can see the library is on current text rather than four-year-old text.

## What changes for the reader

CIS reads "CIS Controls v8.1", and each safeguard shows its security function
and asset class. Filtering the framework by function becomes possible, which
makes the CIS view and the domain view answer the same question.

SOC 2 reads "2017 Trust Services Criteria (with revised points of focus, 2022)".

## Implementation

- Depends on the framework-versions task for the supersede chain. CIS v8 keeps
  its row; v8.1 is a new row with `carried_from` set on every requirement, since
  the refs are unchanged — which makes carrying an assessment forward a clean
  one-click operation and a good first exercise of that code path.
- `security_function` and `asset_class` on the framework requirement, or a
  general `tags` map if a second framework would want the same. Prefer the
  general shape only if NIST CSF's function/category would use it too — decide
  when you get there rather than building for one caller.
- SOC 2 is a `name`/`version` edit on the existing row. No new version, no
  requirement changes, no supersede.
- Refresh the safeguard titles from the v8.1 text.

Tests: carrying a CIS assessment from v8 to v8.1 preserves every requirement's
state; the SOC 2 rename touches no requirement.

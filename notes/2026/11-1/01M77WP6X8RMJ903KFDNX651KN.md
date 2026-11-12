---
id: 01M77WP6X8RMJ903KFDNX651KN
created: 2026-11-12T12:45:57.032999Z
updated: 2026-11-12T12:54:23.308916Z
type: task
title: 'Audit log: the 2027–28 testing plan is on Moneypenny''s plan, every test linked to the controls it proves'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1752
assignee: steve
label: null
priority: medium
task_status: review
---
Add a dated line to the Log in `audit/README.md` recording the 2026-11-12 work in production Compass:

- 33 tests from `~/audit-sources/2027-Security-assurance-plan.csv` added as SAP-14..SAP-46 (Mar 2027 – Feb 2028; Testing, Planned, owner Steve).
- Controls linked to every Testing entry (SAP-5..SAP-46): pen tests → VUM.8 + VUM.7 (external/app) or VUM.11 (internal); physical → + PES.4; social engineering → SEA.1 + SEA.2; AI Integrity → VUM.8 + AIG.14. VUM.8, SEA.1 and PES.4 are the SOC 2 set controls.
- SAP-1 is done and its links are locked (VUM.7 only, outside the SOC 2 set), so its report was linked to VUM.8 as evidence.

Independent (docs only, no migration or API change).

**Done when:** the log line is on main.
---
id: 01M7AC9HHNJWDZ3XC6CVCV5D28
created: 2026-11-13T11:57:08.021545Z
updated: 2026-11-14T17:05:05.691818Z
type: task
title: 'Audit notes: the review period is 18 Jan – 18 Apr 2027, Processing Integrity is out of scope in Compass, and the systems that hold our evidence are named'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1791
assignee: steve
label: chore
priority: medium
task_status: done
---
Update `audit/README.md` with what Steve confirmed on 2026-11-13:

- **Review period:** 2027-01-18 to 2027-04-18 (SOC 2 Type 2 with A-LIGN). Add it to the engagement table.
- **Processing Integrity out of scope in Compass:** PI1.1–PI1.5 are ruled out for Moneypenny on the SOC 2 framework, so 56 of 61 criteria apply. INI-1 (SOC2-2026) holds the 156 controls of the exact set less the three PI-only controls (EVM.27, SOD.19, SOD.20).
- **Where the evidence lives:** CommVault (backup), FreshService (ticketing and change; HR raises joiner requests there), SentinelOne (EDR), PeopleXD (HR; we have no direct access).
- Log lines for the above, and for the evidence-source analysis: of A-LIGN's 181 requests, 31 are policies already in Compass, 36 come from Compass's own registers, 6 from the directory Compass reads, 58 could be collected from our systems, and 50 are uploads by hand.

Done when: the README says all of this and the PR has merged.
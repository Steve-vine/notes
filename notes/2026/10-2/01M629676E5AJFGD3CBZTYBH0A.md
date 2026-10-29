---
id: 01M629676E5AJFGD3CBZTYBH0A
created: 2026-10-28T22:13:16.11018Z
updated: 2026-10-29T08:39:56.631597Z
type: task
title: The cloud and vulnerability checks — encryption at rest, nothing public, backups on, software in support, and no critical or high vulnerability past its fix-by date, read from the Vulnerabilities register
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1418
sprint: s6j9773
blocked_by:
- 01M6295TFZ7H8V6ZVDR38X6279
assignee: steve
label:
- feature
priority: high
task_status: active
---
Sprint 96, Continuous Control Checks (ADR 0132, COM-1415).

## What people see

Five checks. Each lists the systems or vulnerabilities it means, linked to them.

| Check | Fails when | Controls (screen ref) |
|---|---|---|
| **Data is encrypted at rest** | an open "Compass checks" vulnerability says storage isn't encrypted | KMC.4 |
| **Nothing is open to the public** | an open one says public access isn't blocked, or a resource is readable by anyone | CLD.16 |
| **Backups are switched on** | an open one says nothing backs a datastore up | BCR.13 (backup schedule) |
| **Software is in support** | an open one says an operating system or product is out of support | VUM.1 |
| **Vulnerabilities are fixed on time** | any critical or high vulnerability is open past its fix-by date | VUM.8 |

- **Accepted vulnerabilities don't count:** they have an owner, a reason and a review date. False positives don't count either. Each check shows "and 2 accepted" so nothing is hidden.
- **Can't tell** when the company has no cloud connection and no other source for that question ("Compass reads no cloud for this company"). It isn't a pass.
- A system someone can't see is counted, not named.

## Who can do what

As COM-1417.

## Notes (technical)

- Read from `VulnerabilityFinding`, using the "Compass checks" source keys (`not_encrypted`, `readable_by_anyone` and the public-access keys, the backup key, `unsupported_os`, `software_out_of_support:*`) via `core/discovery/findings.py` and `checks.CHECKS`. Never re-judge the cloud facts here: the register is the one place they're decided.
- Fix-by date: the register's own per-severity target (ADR 0129).
- Controls by key: KMC.6, s42.CLD.7, DBR.1, PAM.1, VUM.4.
- Mapping cloud findings to controls is my call, listed in COM-1415.

**Chain:** on the chain (API).

**Done when:** on staging, against the AWS staging account, at least one check fails with real systems listed, raises its gap, and closes it after the finding is accepted.
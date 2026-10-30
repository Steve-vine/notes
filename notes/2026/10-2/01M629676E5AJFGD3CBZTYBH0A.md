---
id: 01M629676E5AJFGD3CBZTYBH0A
created: 2026-10-28T22:13:16.11018Z
updated: 2026-10-30T08:01:20.119033Z
type: task
title: The cloud and vulnerability checks — encryption at rest, nothing public, backups on, software in support, and no critical or high vulnerability past its fix-by date, read from the Vulnerabilities register
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1418
sprint: s6j9773
blocked_by:
- 01M6295TFZ7H8V6ZVDR38X6279
comments:
- id: 01M63D9NCPZCTJKJTC9PQNRYCS
  author: Steve Vine
  at: 2026-10-29T08:44:17.686218Z
  text: |-
    Done — PR #1435 (stacked on #1434).

    Five checks, read from the Vulnerabilities register:
    - Data is encrypted at rest (KMC.4): an open finding says storage or its secrets aren't encrypted.
    - Nothing is open to the public (CLD.16): public access not blocked, readable by anyone, reachable from the internet, or a Kubernetes control endpoint that's public.
    - Backups are switched on (BCR.13): nothing backs a datastore up.
    - Software is in support (VUM.1): an operating system or any product out of support.
    - Vulnerabilities are fixed on time (VUM.8): a critical or high vulnerability open past its fix-by date, from any source.

    On staging, Test Company has open "out of support" findings, so "Software is in support" will fail there with real systems and raise a gap on VUM.1.

    My calls:
    - "Nothing is open to the public" also counts "reachable from the internet" and a public Kubernetes control endpoint, not only the two the task named. All four say the same thing to an auditor.
    - Backups counts only "no backups". "No point-in-time recovery" and "short retention" stay as vulnerabilities but don't fail this check.
    - Can't tell when the company has no AWS, Azure or Google connection ("Compass reads no cloud for this company"). For software, directory servers count as a source too. "Fixed on time" is Can't tell only when the register is empty.
    - Accepted findings don't count, but the sentence says "and 2 accepted". False positives aren't counted at all.
    - A finished cloud read runs the cloud checks straight away.

    Tests: 5 integration tests, including a gap raised on BCR.13 that closes once its finding is accepted.
assignee: steve
label:
- feature
priority: high
task_status: done
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
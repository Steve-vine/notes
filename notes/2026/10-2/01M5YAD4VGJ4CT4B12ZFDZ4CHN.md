---
id: 01M5YAD4VGJ4CT4B12ZFDZ4CHN
created: 2026-10-27T09:17:33.936061Z
updated: 2026-10-27T09:17:33.936061Z
type: task
title: AWS feeds the register — Security Hub's failed controls and Inspector's software flaws are read for each account, landing on the systems discovery already attached them to
priority: high
assignee: steve
label: feature
task_status: todo
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1383
---
Sprint 93, Vulnerabilities - Cloud sources (ADR amendment in COM-1382). Builds on sprints 90–92.

## What people see

- **Integrations ▸ AWS ▸ Features ▸ Vulnerabilities**, switchable.
  - When on, each account that has discovery on is also read for findings after its discovery read, every 6 hours.
  - Per account, Status shows whether **Security Hub** and **Inspector** are switched on in it, and in which regions.
  - "Not switched on in this account" is a plain line, not an error.
- **What comes in:**
  - **Security Hub:** active, failed control findings and other active findings, such as GuardDuty-sourced items if Security Hub gathers them, with:
    - title;
    - severity;
    - the control ID (e.g. S3.8);
    - the standard (e.g. AWS Foundational Security Best Practices, CIS);
    - remediation text and link;
    - the resource.
    - Kind: Misconfiguration, or Software flaw for Inspector-sourced findings.
  - **Inspector:** package vulnerabilities on EC2, ECR images and Lambda, with CVE, CVSS, the package and fixed-in version, and the resource.
  - When Inspector findings also flow into Security Hub, they come in once.
- **Systems:** the finding's resource, if discovery attached it to a technology asset. Otherwise it goes to Unmatched, with **Attach in Inventory**.
- **Closing:** a finding Security Hub or Inspector marks resolved, archived or passed closes its sighting. Suppressed in Security Hub is shown as Accepted "suppressed in Security Hub", as Aikido's ignore is.
- **The policy template** in `docs/aws` gains the read permissions. Overview says which. Test names any that are missing.

## Who can do what

The switch needs Inventory admin, as for AWS accounts (sprint 90).

## Notes (technical)

- `securityhub:GetFindings` filtered to `RecordState=ACTIVE` and `WorkflowStatus` in NEW/NOTIFIED/SUPPRESSED. Read in the aggregation region if one is set, otherwise per region within the account's switched-on regions.
- `inspector2:ListFindings` only when Security Hub isn't gathering Inspector, decided per account.
- Idempotent on the finding ARN. Readers under `core/vulnerabilities/sources/aws/`, faked through `tests/aws_fakes.py`.
- Tolerate the blocked-regions case (COM-911) the same way discovery does.

**Chain:** on the chain (migration + API).

**Done when:**
- Steve's real AWS account on staging brings in Security Hub and Inspector findings onto attached systems;
- fixing one in AWS closes it on the next read.
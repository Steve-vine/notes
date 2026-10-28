---
id: 01M5YAD4VGJ4CT4B12ZFDZ4CHN
created: 2026-10-27T09:17:33.936061Z
updated: 2026-10-28T09:13:51.955214Z
type: task
title: AWS feeds the register — Security Hub's failed controls and Inspector's software flaws are read for each account, landing on the systems discovery already attached them to
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1383
sprint: svnkdj7
blocked_by:
- 01M5YACKJW9S2N0K25SEG4NJ51
- 01M5YA9T7YGZN49RZ4X73Y344A
- 01M5Y9DB411DAT6GWW6QW3BX9A
comments:
- id: 01M60WJZ0VD1Z3TG1ZPNYZAX47
  author: Steve Vine
  at: 2026-10-28T09:13:47.803046Z
  text: |-
    Done — PR #1400 merged to main (3efe38ff, migration 0721). Already on staging: compass-52 deployed main 084af128 with it.

    What you'll see
    - Integrations ▸ AWS ▸ Features ▸ Vulnerabilities (Inventory admin). It starts OFF — switch it on to try it.
    - When on, each account's discovery read (6-hourly or Read now) is followed by a read of its Security Hub and Inspector findings into that company's Vulnerabilities, on the system discovery attached the resource to.
    - A resource still on Inventory ▸ Discovered: its findings wait on Vulnerabilities ▸ Unmatched, marked "Waiting on Inventory's Discovered tab", with an "Attach in Inventory" action that opens the resource there. Attaching it places the findings at once.
    - Fixed in AWS → closes on the next read ("Fixed — confirmed by AWS"). Suppressed in Security Hub → "Accepted by AWS: Suppressed in Security Hub: <note>".
    - AWS tile ▸ Status gains a Vulnerabilities column per account: which tools are on and where, and any missing permission.
    - docs/aws policy gains 6 read actions; README says existing policies must be re-run.

    Tried against real AWS: I ran the reader locally against the staging account (463040245339) with the profile on this box. That profile can't read Security Hub or Inspector, so it exercised the "permission missing" path for real: it read nothing, closed nothing, and said so. It said it once per region (40 lines); fixed in COM-1384's PR to say it once ("every region"). The happy path is tested against the fake only.

    Still needs you: switch the feature on in staging, make sure the staging account's compass-discovery policy has the new actions (re-run the template), and Security Hub/Inspector must be on in the account. Then Read now on the account.

    My calls
    - Feature starts off.
    - Inspector read directly only where Security Hub isn't gathering it; one source "AWS" so it comes in once.
    - A region counts as checked only where a tool is on and every read worked; Security Hub switched off closes nothing.
    - ECR image findings are image targets (so an image matching rule places them), not resources.
    - "Save as a rule" isn't offered for a cloud-resource row on Unmatched (rules match hosts, repos and images).
assignee: steve
label:
- feature
priority: high
task_status: review
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
---
id: 01M4XZKT2KRBRR4WVS2KEZPTEN
created: 2026-10-14T19:53:16.115543Z
updated: 2026-10-17T09:30:47.177291Z
type: task
title: Installed software on AWS servers is read from Systems Manager, where it is switched on, and appears in Discovered ▸ Software
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 966
sprint: sbkelqe
blocked_by:
- 01M4XZJTK1NXRVG7N8F8XQNFXE
assignee: steve
label:
- feature
priority: high
task_status: active
---
Part of sprint 67, Inventory discovery - Software (ADR in COM-959). The first of three tasks that read a server's full software list from the agent its cloud already runs. Nothing is installed by Compass, and nothing logs in.

## What people see

- **For each AWS server under a technology asset that Systems Manager reports on,** everything installed on it appears in Discovered ▸ Software, grouped with the same software on other servers: "Microsoft SQL Server 2019 · on 3 technology assets", "Notepad++ 8 · on 7".
- **Updates, patches and hotfixes are left out**, as Steve decided.
- **A server Systems Manager doesn't report on** still shows its operating system (COM-964). Opening the server on its technology asset says "Installed software: not reported. Switch on AWS Systems Manager Inventory to see it", so the gap is plain.
- **The AWS account card says how many servers report** ("Installed software: 12 of 18 servers report it"), so whoever looks after AWS knows what's missing.
- Discarding works as COM-960 describes; discard several at once for Linux package lists.

## Notes (technical)

- `ssm:DescribeInstanceInformation` (which instances are managed) and `ssm:ListInventoryEntries` with `TypeName=AWS:Application` (Name, Version, Publisher, PackageId) per managed instance, paged. `AWS:WindowsUpdate` is a separate type and is simply not read, which satisfies "all but updates" on Windows. On Linux, `AWS:Application` is the package list.
- `ssm:GetInventory` can fetch across instances in fewer calls. Compare the request counts on a fake of 50 instances and choose.
- Inventory needs the SSM agent, an instance profile and an Inventory association (AWS Quick Setup). Compass does not create any of these. Say so in `docs/aws/` alongside the template, with the actions added to the user/role template (`core/aws_policy.py`).
- The organisation path (COM-890 / ADR 0101) reads each account as itself, so nothing extra is needed there.
- Store into COM-960's table, replaced per resource on each read. Normalise to `app:<publisher>:<name>:<major>`, plus recognised products (SQL Server, IIS, Apache, nginx, OpenSSL, Java, .NET) mapped to keys COM-962 knows.
- Fakes in `tests/aws_fakes.py`, including a Linux instance with several hundred packages, to check paging and the grouping cost.

**Done when:** on staging, a Systems Manager-managed instance under a technology asset shows its installed software in Discovered ▸ Software with no Windows updates among it; an unmanaged one shows "not reported"; and the account card shows the count. If Steve has no managed instance, the task says so and stops at the fake.
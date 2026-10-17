---
id: 01M4XZJTK1NXRVG7N8F8XQNFXE
created: 2026-10-14T19:52:43.873092Z
updated: 2026-10-17T09:01:49.12995Z
type: task
title: The operating system and version of each cloud server is found — AWS, Azure and Google Cloud — and appears in Discovered ▸ Software, with nothing installed on the server
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 964
sprint: sbkelqe
blocked_by:
- 01M4XZGT1G67Z1HYZRG8MQ07BS
assignee: steve
label:
- feature
priority: high
task_status: active
---
Part of sprint 67, Inventory discovery - Software (ADR in COM-959). Today a cloud server shows only "Windows" or "Linux" (AWS), an image name (Azure), or a disk licence (Google). This task turns those into a named operating system and version.

## What people see

- **Discovered ▸ Software lists the operating systems on servers under technology assets**, one row per OS and version: "Windows Server 2019 · on 14 technology assets", "Ubuntu 22.04 · on 6", "Amazon Linux 2023 · on 3". Rows are provider-neutral, so Windows Server 2019 in AWS and in Azure is one row, and opening it shows each server and where it is.
- **A server reports one of three levels of certainty**, shown when the row is opened:
  - *reported by the server*, from the cloud's own agent;
  - *from the image it was built from*;
  - *not known*, for servers built from a private image with nothing reporting. These are counted in a single "Operating system not known · on N" row, so the gap is visible and not silent.
- **SQL Server bundled in a licence-included AWS image** (AWS says "Windows with SQL Server Standard") appears as SQL Server too.
- On-prem Windows Server versions (COM-936) land in the same rows, so "Windows Server 2019" counts cloud and on-prem servers together.

## Notes (technical)

- **AWS:** keep `PlatformDetails` from `DescribeInstances`, which already comes back with the read ("Windows with SQL Server Standard", "Red Hat Enterprise Linux"). `ec2:DescribeImages` on the instances' image IDs returns the AMI name/description ("Windows_Server-2019-English-Full-Base-…", "ubuntu/images/…/ubuntu-jammy-22.04-…"); public AMIs are readable cross-account. Where Systems Manager knows the instance, `ssm:DescribeInstanceInformation` gives `PlatformName` / `PlatformVersion`, which counts as *reported by the server* and is preferred. Add the actions to the template.
- **Azure:** `imageReference` publisher/offer/sku is read already (`azure/compute.py` `_image`): `MicrosoftWindowsServer:WindowsServer:2019-Datacenter`, `Canonical:0001-com-ubuntu-server-jammy:22_04-lts`. The VM instance view (`…/virtualMachines/{name}/instanceView`, action `Microsoft.Compute/virtualMachines/instanceView/read`) gives `osName` / `osVersion` from the guest agent, which counts as *reported*. That is one call per VM, so watch request counts (the first real read was 132 requests). Add the action to `core/azure_role.py`.
- **Google:** the boot-disk licence is read (`gcp/compute.py` `_operating_system`, e.g. `windows-server-2019-dc`, `ubuntu-2204-lts`). Map it to a name and version. OS Config inventory's `osInfo` (COM-967) is *reported* where present.
- One normalisation table maps each source's spelling to `os:<product>:<version>`, with tests for each source's real strings. Unrecognised strings stay visible as their raw name. They are never dropped.

**Done when:** on staging, Steve's AWS and Azure servers under technology assets show a named OS and version in Discovered ▸ Software, and any that can't be named are counted in "not known".
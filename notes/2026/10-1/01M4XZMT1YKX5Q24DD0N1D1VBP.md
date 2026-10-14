---
id: 01M4XZMT1YKX5Q24DD0N1D1VBP
created: 2026-10-14T19:53:48.862808Z
updated: 2026-10-14T19:53:52.751957Z
type: task
title: Installed software on Azure servers is read from Change Tracking and Inventory, where it is switched on, and appears in Discovered ▸ Software
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 968
sprint: sbkelqe
blocked_by:
- 01M4XZKT2KRBRR4WVS2KEZPTEN
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Part of sprint 67, Inventory discovery - Software (ADR in COM-959). The Azure counterpart of COM-966. It looks the same on screen, and nothing is installed or logged into. Azure is the least direct of the three: the list sits in a Log Analytics workspace, not on the VM.

## What people see

- **For each Azure VM under a technology asset that Change Tracking and Inventory reports on,** its installed software appears in Discovered ▸ Software, grouped with the same software elsewhere.
- **Updates are left out.**
- **A VM that doesn't report** says "Installed software: not reported. Switch on Change Tracking and Inventory to see it". The subscription card says how many VMs report, and which workspace the list came from.
- If Microsoft Defender for Servers is on instead, its software inventory is used in the same way (see notes). Only one of the two is needed.

## Notes (technical)

- **Change Tracking and Inventory** (Azure Monitor Agent + data collection rule) writes to a Log Analytics workspace: `ConfigurationData | where ConfigDataType == "Software"` (SoftwareName, CurrentVersion, Publisher, SoftwareType, Computer, `_ResourceId`), latest per VM and name. `SoftwareType == "Update"` is excluded. Join to VMs on `_ResourceId`, never on computer name.
- **Finding the workspace:** VMs' data collection rule associations (`Microsoft.Insights/dataCollectionRuleAssociations/read`) point to the rule and its destination workspace. Query through Resource Manager (`…/workspaces/{ws}/query`, action `Microsoft.OperationalInsights/workspaces/query/read`), so the existing sign-in and token are reused. If the workspace sits in a subscription Compass doesn't read, the card says so.
- **Defender fallback:** Azure Resource Graph `securityresources | where type == "microsoft.security/softwareinventories"` (Defender Vulnerability Management, Defender for Servers P2), action `Microsoft.ResourceGraph/resources/read` plus `Microsoft.Security/*/read` on the scope. Build it only if Change Tracking proves absent in practice. Otherwise name it on the task as later.
- Add the actions to `core/azure_role.py` → `docs/azure/compass-discovery-role.json`. Write down the request-count cost.
- Fakes in `tests/azure_fakes.py`.

**Done when:** a faked subscription's reporting VM shows its software with no updates, and a non-reporting one shows "not reported". On staging, check whether Steve's subscription has Change Tracking or Defender inventory on any VM, and report what was found.
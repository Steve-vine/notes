---
id: 01KYW7EQB0YTFZW575ARNC3S15
created: 2026-07-31T13:57:38.272198Z
updated: 2026-07-31T13:58:33.899009Z
type: task
title: 'Integration docs: Azure'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 414
sprint: sp3en5k
assignee: steve
label:
- feature
priority: medium
task_status: backlog
---
Replace the Azure stub (`src/content/docs/integrations/azure.md`) with full operator documentation:

- **Capabilities** — per-subscription discovery (VMs, SQL/PG flexible servers, AKS, load balancers + app gateways, storage accounts, app services/function apps), Azure Monitor + Service Health alerts mapped onto the canonical severity ladder, evidence on demand (describe/metrics/Activity Log/optional Log Analytics KQL), action catalogue (VM lifecycle incl. deallocate, App Service restart, PG flexible server restart, resource tagging) with tiers — no RBAC/identity actions; Azure SQL restart deliberately absent.
- **Setup** — read service principal (tenant/client/secret/subscription) and the separate write SP via Grant-write; required role assignments.
- **Examples** — a Sev alert landing on a VM entity joined to a DataDog host; a T1 restart_vm through approval.

Ground in ADRs 0059 (connector) + 0061 (actions); rewrite for operators, released capability only.
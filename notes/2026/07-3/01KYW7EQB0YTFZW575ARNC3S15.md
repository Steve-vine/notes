---
id: 01KYW7EQB0YTFZW575ARNC3S15
created: 2026-07-31T13:57:38.272198Z
updated: 2026-08-07T12:15:32.713844Z
type: task
title: 'Integration docs: Azure'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 414
order: 2.0
sprint: sp3en5k
comments:
- id: 01KYW897X1HQVFRTG48H1R35XD
  author: Steve Vine
  at: 2026-07-31T14:12:07.200953Z
  text: |-
    Done on feature/ise-414-docs-azure — PR #12, left OPEN for the PR-preview test.

    Full Azure page: capabilities (per-subscription discovery of VMs/databases/AKS/LB+AppGW/storage/App Services with tag-pool provenance and joins onto DataDog hosts + K8s clusters; Monitor Sev0–4 → canonical ladder + Service Health, forwarded verbatim; evidence describe_resource/list_resources/monitor_metrics/activity_log/log_analytics_query; actions restart_vm/start_vm/restart_app_service/set_resource_tag T1, deallocate_vm/restart_pg_flexible_server T2, with the LRO polled-to-completion truthfulness note, no-RBAC and no-faked-SQL-restart notes), setup (read SP with Reader + optional Log Analytics Reader, per-subscription instance, Grant-write second SP), examples. Facts from connectors/azure.py + ADRs 0059/0061. Build/lint green.
assignee: steve
label: null
priority: medium
task_status: done
---
Replace the Azure stub (`src/content/docs/integrations/azure.md`) with full operator documentation:

- **Capabilities** — per-subscription discovery (VMs, SQL/PG flexible servers, AKS, load balancers + app gateways, storage accounts, app services/function apps), Azure Monitor + Service Health alerts mapped onto the canonical severity ladder, evidence on demand (describe/metrics/Activity Log/optional Log Analytics KQL), action catalogue (VM lifecycle incl. deallocate, App Service restart, PG flexible server restart, resource tagging) with tiers — no RBAC/identity actions; Azure SQL restart deliberately absent.
- **Setup** — read service principal (tenant/client/secret/subscription) and the separate write SP via Grant-write; required role assignments.
- **Examples** — a Sev alert landing on a VM entity joined to a DataDog host; a T1 restart_vm through approval.

Ground in ADRs 0059 (connector) + 0061 (actions); rewrite for operators, released capability only.
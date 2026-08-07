---
id: 01KZED7V0M99D3NM6YA5SA9CST
created: 2026-08-07T15:25:03.892529Z
updated: 2026-08-07T15:25:03.892529Z
type: memo
title: ISE Integration Capabilities
project: 01KX671DATY39VW6GWK3M2T3DN
---
Current capabilities per integration, as implemented in code (connector registry, 2026-08-07). Tiers: T0/T1 auto-appliable, T2/T3 always human-approved.

## AWS

| Function | Description |
| --- | --- |
| Entity discovery | VPCs, EKS clusters, EC2 hosts, RDS, ELBs, S3 buckets, with cross-links to DataDog hosts and k8s clusters/nodes. |
| Alerts | CloudWatch alarms in ALARM state and AWS Health events raised as signals. |
| Evidence | Describe/list resources, CloudWatch metric statistics, log filtering, CloudTrail event lookup. |
| Actions | `reboot_instance` (T1), `start_instance` (T1), `stop_instance` (T2), `reboot_db_instance` (T2), `set_resource_tag` (T1). |

## Azure

| Function | Description |
| --- | --- |
| Entity discovery | VNets, AKS, VMs and scale-set instances, PG/MySQL/SQL databases, LBs/App Gateways, storage, App Services/Functions, private endpoints. Arc machines deliberately excluded (reserved for Servers integration). |
| Alerts | Azure Monitor fired alerts and active Service Health events. |
| Evidence | Describe/list resources, Monitor metrics, activity log, Log Analytics queries. |
| Actions | `restart_vm` (T1), `start_vm` (T1), `deallocate_vm` (T2), `restart_app_service` (T1), `restart_pg_flexible_server` (T2), `restart_mysql_flexible_server` (T2), `set_resource_tag` (T1). |

## Cloudflare

| Function | Description |
| --- | --- |
| Entity discovery | Zones, tunnels, load balancers, Workers/Pages, with routes-to edges. DNS records are evidence-only, never entities. |
| Alerts | Cloudflare Notifications alerting history, attributed to zone/tunnel/LB entities. |
| Evidence | DNS records, security events, zone analytics, audit log, tunnel connections. |
| Actions | `update_dns_record` (T2, edit-only), `purge_cache_urls` (T1), `purge_cache_everything` (T2), `set_ip_access_rule` (T2), `set_security_level` (T2), `set_pool_enabled` (T2, manual LB failover). |

## DataDog

| Function | Description |
| --- | --- |
| State sync | Monitors (120s), dashboards, APM service catalogue kept synced eagerly. |
| Entity discovery | Services and hosts from the APM catalogue, monitor scope tags, and the reporting host list. Enriches only — not source of record. |
| Alerts | Monitor alerts, filtered through ingest ignore rules. |
| Evidence | Query metrics, search logs, search events, active metrics, synthetics tests. |
| Actions | `ack_event` (T0), `set_host_tag` (T1), `mute_monitor` (T1, bounded), `unmute_monitor` (T1), `edit_monitor` (T2). |

## Kubernetes

| Function | Description |
| --- | --- |
| State sync | Namespaces, workloads, nodes, config (ConfigMap keys only). |
| Entity discovery | Clusters, namespaces, workloads, services, nodes, ExternalSecret-produced secrets, plus custom kinds from the kind dictionary; routes-to / runs-on / depends-on edges deduced. |
| Observations | `pending_pod`, `crashloop`, `oom_kill`, `unhealthy_workload`, `node_not_ready`, `node_pressure`, `node_flapping`, probe/scheduling failures, custom-kind health. No native alerts feed — ISE detects. |
| Baselines | Workload desired/ready replicas and node readiness/pressure captured as normality baselines. |
| Evidence | Describe pod, node capacity, recent events, pending pods, rollout status, pod logs. |
| Actions | `set_label` (T1), `restart_rollout` (T1), `scale_workload` (T1, capped), `edit_resource` (T2), `delete_resource` (T3). |

## EntraID

| Function | Description |
| --- | --- |
| Entity discovery | Users (member + guest), security groups, service principals / app registrations, conditional-access policies. |
| Alerts | Identity-protection risky users (atRisk / confirmedCompromised). |
| Observations | App credential expiry (4 threshold rungs: 90/60/30/critical days) and app-registration hygiene. |
| Evidence | User sign-ins, directory audit log, risk detections, user detail, group members, CA policy detail, credential expiry. |
| Actions | All T3: `revoke_user_sessions`, `disable_user`, `enable_user`, `add_group_member`, `remove_group_member`, `set_ca_policy_state`. Self-escalation guard structurally refuses membership changes on ISE's own role groups. |

## M365

| Function | Description |
| --- | --- |
| State sync | License SKUs (consumed vs enabled). |
| Entity discovery | ~25–30 subscribed services as external `application` entities from service-health overviews. |
| Alerts | Service-health issues. |
| Observations | License pool near-exhaustion and license status, with a percent threshold. |
| Evidence | Service-health issue detail, message center, license detail. |
| Actions | None, permanently by design (ADR 0066) — M365 is a third party ISE observes. |

## Freshservice

| Function | Description |
| --- | --- |
| Ticket sweep | 60s sweep lands tickets on the Events screen (first sighting only). No alerts/entities — ticket noise stays out of the incident queue. |
| Observations | `ticket_burst` and `ticket_duplicate` (similarity clustering with LLM adjudication of borderline pairs); both threshold-tunable. |
| Evidence | Ticket detail, recent tickets, ticket search. |
| Actions | `create_ticket` (T1). ISE-raised tickets are excluded from its own detection. |

## GitHub

| Function | Description |
| --- | --- |
| Repo sync | Hourly sweep, SHA-gated; read surface covers trees, files, commits, changed paths, releases. |
| Alerts | Workflow failures, open Dependabot alerts, open code-scanning alerts. |
| Actions | `open_pull_request` (T2) — branch + atomic multi-file commit + PR. Deliberately no merge action; refuses unregistered repos. |

## Confluence

| Function | Description |
| --- | --- |
| Documents | Hourly scrape of registered pages into the document store. Read-only, permanently — ISE never writes to the wiki. |

## Status Pages

| Function | Description |
| --- | --- |
| Page sweep | 60s sweep of public status pages (Atlassian Statuspage JSON or RSS); no credential needed. |
| Entity discovery | One external `application` entity per tracked service — the only source that can tell ISE a third party (e.g. Twilio) exists. |
| Alerts | Raised and recovered from page state by the sweep. |

## Microsoft Teams

| Function | Description |
| --- | --- |
| Notifications | Outbound only: incident opened/escalated/resolved (severity-gated), action pending, integration broken. Delivers to users, group chats, assignees; card edit-in-place; per-channel anti-flap. Never enters approval machinery. |

## MCP Evidence

| Function | Description |
| --- | --- |
| Evidence | Catalogue discovered live from the remote MCP server's tool list; each tool becomes an evidence query. No write path, permanently. |

## Webhook (internal)

| Function | Description |
| --- | --- |
| Push ingest | Token-in-URL ingest raising ordinary alerts; recovery via explicit event or TTL sweep. Hidden from integration surfaces (ADR 0078 — core application, not an integration). |

## Planned, unbuilt

| Integration | Status |
| --- | --- |
| Servers (agentless Ansible) | ADR 0084 Proposed, ISE-563..571 in Backlog; no code yet. |
| Voice escalation + on-call rotas | ADRs 0079/0080 accepted; no ACS/PSTN/rota code yet. |
| GitLab / second Git host | Future work per ADR 0051; would be a new connector. |
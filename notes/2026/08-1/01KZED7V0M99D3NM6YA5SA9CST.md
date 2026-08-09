---
id: 01KZED7V0M99D3NM6YA5SA9CST
created: 2026-08-07T15:25:03.892529Z
updated: 2026-08-09T10:00:59.459185Z
type: memo
title: ISE Integration Capabilities Catalogue
project: 01KX671DATY39VW6GWK3M2T3DN
---
Current capabilities per integration, as implemented in code (connector registry, **verified against the code 2026-08-09**). Tiers: T0/T1 auto-appliable, T2/T3 always human-approved.

Evidence vs actions: both are self-describing catalogues, but evidence queries are live, bounded, **read-only** pulls executed immediately with no tier or approval; actions are proposals that mutate the external system and pass through the approval machinery before a worker executes them.

# AWS

| Function | Description |
| --- | --- |
| Entity discovery | VPCs, EKS clusters, EC2 hosts, RDS, ELBs, S3 buckets, with cross-links to DataDog hosts and k8s clusters/nodes. EC2 instances record their OS family. |
| Alerts | CloudWatch alarms in ALARM state and AWS Health events raised as signals. |

**Evidence**

| Query | Description |
| --- | --- |
| `describe_resource` | Describe one AWS resource by ARN (EC2 instance, RDS instance, etc.). |
| `list_resources` | List the account's resources of one type in a region. |
| `cloudwatch_metric_statistics` | Average/maximum statistics for one CloudWatch metric over a time window. |
| `logs_filter_events` | Search a CloudWatch Logs log group with a filter pattern. |
| `cloudtrail_lookup_events` | Recent CloudTrail management events — who changed what, when. |

**Actions**

| Action | Description |
| --- | --- |
| `reboot_instance` | T1 — reboot an EC2 instance. |
| `start_instance` | T1 — start a stopped EC2 instance. |
| `stop_instance` | T2 — stop a running EC2 instance. |
| `reboot_db_instance` | T2 — reboot an RDS database instance. |
| `set_resource_tag` | T1 — set a tag on a resource (tag write-back). |

---
# Azure

| Function | Description |
| --- | --- |
| Entity discovery | VNets, AKS, VMs and scale-set instances, PG/MySQL/SQL databases, LBs/App Gateways, storage, App Services/Functions, private endpoints. VMs and scale-set instances record their OS family. Arc machines are still **not** Azure entities — they are read as a list by the Servers coverage reconciler through this credential (ADR 0084). |
| Alerts | Azure Monitor fired alerts and active Service Health events. |

**Evidence**

| Query | Description |
| --- | --- |
| `describe_resource` | Describe one Azure resource by its full ARM resource id. |
| `list_resources` | List the subscription's resources of one type. |
| `monitor_metrics` | Azure Monitor platform metrics for one resource over a time window. |
| `activity_log` | The subscription's Activity Log — who changed what, when. |
| `log_analytics_query` | Run a read-only KQL query against a Log Analytics workspace. |

**Actions**

| Action | Description |
| --- | --- |
| `restart_vm` | T1 — restart a virtual machine. |
| `start_vm` | T1 — start a stopped virtual machine. |
| `deallocate_vm` | T2 — stop and deallocate a VM (releases compute billing). |
| `restart_app_service` | T1 — restart an App Service or Function app. |
| `restart_pg_flexible_server` | T2 — restart a PostgreSQL flexible server. |
| `restart_mysql_flexible_server` | T2 — restart a MySQL flexible server. |
| `set_resource_tag` | T1 — set a tag on a resource (tag write-back). |

---
# Cloudflare

| Function | Description |
| --- | --- |
| Entity discovery | Zones, tunnels, load balancers, Workers/Pages, with routes-to edges. DNS records are evidence-only, never entities. |
| Alerts | Cloudflare Notifications alerting history, attributed to zone/tunnel/LB entities. |

**Evidence**

| Query | Description |
| --- | --- |
| `list_dns_records` | List one zone's DNS records — name, type, content, proxied state. |
| `security_events` | Recent firewall/security events for one zone (WAF blocks, challenges). |
| `zone_analytics` | Hourly traffic summary for one zone over a window. |
| `audit_log` | The account's audit log — who changed what, when. |
| `tunnel_connections` | One Cloudflare Tunnel's current status and active edge connections. |

**Actions**

| Action | Description |
| --- | --- |
| `update_dns_record` | T2 — edit an existing DNS record (no create or delete). |
| `purge_cache_urls` | T1 — purge specific URLs from cache (max 30 per call). |
| `purge_cache_everything` | T2 — purge a zone's entire cache. |
| `set_ip_access_rule` | T2 — block, challenge, or whitelist an IP/CIDR at zone or account scope. |
| `set_security_level` | T2 — set a zone's security level, including under-attack mode. |
| `set_pool_enabled` | T2 — enable/disable a load-balancer pool (manual failover). |

---
# DataDog

| Function | Description |
| --- | --- |
| State sync | Monitors (120s), dashboards, APM service catalogue kept synced eagerly. |
| Entity discovery | Services and hosts from the APM catalogue, monitor scope tags, and the reporting host list. Enriches only — not source of record. |
| Alerts | Monitor alerts, filtered through ingest ignore rules. |

**Evidence**

| Query | Description |
| --- | --- |
| `query_metrics` | Evaluate a DataDog metric query over a time window. |
| `search_logs` | Search DataDog logs with a log query. |
| `search_events` | List recent DataDog events over a time window, optionally filtered. |
| `active_metrics` | List the metric names actively reporting over a window. |
| `synthetics_test` | The Synthetics test behind a synthetics-alert monitor. |

**Actions**

| Action | Description |
| --- | --- |
| `ack_event` | T0 — acknowledge an event (additive, irreversible). |
| `set_host_tag` | T1 — set a user-source tag on a host (tag write-back). |
| `mute_monitor` | T1 — mute a monitor for a bounded downtime (minutes required, capped). |
| `unmute_monitor` | T1 — lift a monitor mute. |
| `edit_monitor` | T2 — edit a monitor's name, query, message, or options. |

---
# Kubernetes

| Function | Description |
| --- | --- |
| State sync | Namespaces, workloads, nodes, config (ConfigMap keys only). |
| Entity discovery | Clusters, namespaces, workloads, services, nodes, ExternalSecret-produced secrets, plus custom kinds from the kind dictionary; routes-to / runs-on / depends-on edges deduced. Nodes record their OS family, so Windows node pools are distinguishable. |
| Observations | `pending_pod`, `crashloop`, `oom_kill`, `unhealthy_workload`, `node_not_ready`, `node_pressure`, `node_flapping`, probe/scheduling failures, custom-kind health. No native alerts feed — ISE detects. |
| Baselines | Workload desired/ready replicas and node readiness/pressure captured as normality baselines. |

**Evidence**

| Query | Description |
| --- | --- |
| `describe_pod` | One pod's live state: phase, conditions, container statuses. |
| `node_capacity` | Every node's capacity vs allocatable vs currently-requested resources. |
| `recent_events` | Recent cluster events (scheduler, kubelet, controllers). |
| `pending_pods` | Pods stuck Pending, with the scheduler's reason for each. |
| `rollout_status` | A workload's rollout state: desired/ready/updated/available replicas. |
| `pod_logs` | Tail a pod's logs (bounded; default 100, max 200 lines). |
| `list_namespaces` | The cluster's namespaces. |
| `list_workloads` | Workloads in a namespace, with replica counts. |
| `list_pods` | Pods in a namespace, with phase and restart counts. |
| `pod_resource_usage` | A pod's live CPU/memory usage against its requests and limits. |

**Actions**

| Action | Description |
| --- | --- |
| `set_label` | T1 — set a label on a resource (tag write-back; refuses nodes). |
| `restart_rollout` | T1 — trigger a rolling restart of a workload. |
| `scale_workload` | T1 — scale a workload's replicas (capped maximum). |
| `edit_resource` | T2 — apply a strategic-merge patch to a resource. |
| `delete_resource` | T3 — delete a resource (irreversible). |

---
# Servers (agentless Ansible)

Windows and Linux machines ISE reaches over SSH/WinRM. **Nothing is installed on a target** (ADR 0084). The one integration whose credentials are **per target** rather than per System: secrets live on a *connection profile*, because which secret to use depends on which host an operation names.

**Register-first**: Ansible is agentless, so inventory is an *input*. Nothing discovers servers — an operator registers one and every other machine-shaped sighting audits that list rather than filling it.

| Function | Description |
| --- | --- |
| Register | Servers registered by hostname (the identity the estate joins on), with an optional DNS domain and an address override. Connection profiles hold the transport, port, become/WinRM settings and credentials, with an optional per-OS-family default. |
| Onboarding preflight | Every registration is confirmed by a real connection, and a failure names the missing precondition — unresolvable name, no route, SSH/WinRM not listening, TLS failed, auth refused, no Kerberos realm, no Python — rather than a bare "unreachable". |
| Facts sync | Slow per-server identity gather (OS, distribution, version, kernel, addresses, virtualisation, hardware). A successful contact IS the entity's liveness sighting; volatile facts are excluded on purpose. |
| Entity discovery | A contacted server becomes a `host` entity — the same type as a cloud instance. A registered cloud VM **binds** to the entity it already had rather than minting a second row. |
| Coverage reconciler | Audits the register against every machine ISE can see: EC2 and Azure VMs (already entities — confirming binds), plus Arc, Entra devices and Hyper-V guests (list-only — confirming registers and mints). Ephemeral compute is excluded by rule: Kubernetes nodes and scale-set instances. |
| Observations | Unreachability past a consecutive-failure threshold. No native alert feed — ISE's own judgement. |

**Evidence**

| Query | Description |
| --- | --- |
| `server_full_facts` | Everything the machine reports about itself — the complete facts dump. |
| `server_service_status` | One named service, or the set that is not running — the question an incident usually means. |
| `server_disk_usage` | Filesystems with usage. `ansible_mounts` on Linux, `win_disk_facts` on Windows, normalised to one shape. |
| `server_recent_logs` | A bounded tail — journald on Linux, System + Application event logs on Windows. |

**Actions** — all T2, both platforms

| Action | Description |
| --- | --- |
| `restart_service` | Restart one named service (`systemd` / Windows service). |
| `start_service` | Start one named service. |
| `stop_service` | Stop one named service. |
| `reboot_server` | Reboot and wait for the machine to come back. **Deliberately T2, not the cloud reboot's T1**: an on-prem server that does not come back is a site visit, not an API call. |

**No arbitrary-execution primitive, ever.** There is no `run_playbook` and no `run_command` (ADR 0084 §2) — every operation is a pinned, ISE-authored module call reviewed at PR time. The image ships named, pinned collections (`ansible.windows`, `community.windows`), never the megabundle, because every shipped collection is a set of modules somebody could eventually declare an operation against.

**Check-mode preview**: a proposal is previewed with the module's own `--check --diff` before approval, and the preview states which level of answer it managed (a real diff, a would-change flag, current state, or just reachability) — Windows check-mode support is thinner than systemd's, and an approver deserves to know which they are reading. `reboot_server` declares itself **un-previewable** rather than faking a dry run; its preview is a live reachability test, and a failed preview refuses execution.

---
# EntraID

| Function | Description |
| --- | --- |
| Entity discovery | Users (member + guest), security groups, service principals / app registrations, conditional-access policies. |
| Device list | Windows and Linux device objects read as a **list source** for the Servers coverage reconciler — deliberately not entities. Disabled and long-stale computer objects filtered out. |
| Alerts | Identity-protection risky users (atRisk / confirmedCompromised). |
| Observations | App credential expiry (4 threshold rungs: 90/60/30/critical days) and app-registration hygiene. |

**Evidence**

| Query | Description |
| --- | --- |
| `user_sign_ins` | One user's recent sign-ins — app, client, IP, location. |
| `directory_audit_log` | The directory audit log — who changed what, when. |
| `risk_detections` | One user's Identity Protection risk detections. |
| `user_detail` | One user's full directory record — enabled state, attributes. |
| `group_members` | One security group's direct members. |
| `ca_policy_detail` | One conditional-access policy's full document. |
| `app_credential_expiry` | Every app registration's credential expiry, soonest first. |

**Actions** — all T3

| Action | Description |
| --- | --- |
| `revoke_user_sessions` | Revoke all of a user's sign-in sessions (irreversible). |
| `disable_user` | Block a user's sign-in. |
| `enable_user` | Re-enable a disabled user. |
| `add_group_member` | Add a user to a security group. |
| `remove_group_member` | Remove a user from a security group. |
| `set_ca_policy_state` | Set a conditional-access policy to enabled, disabled, or report-only. |

Self-escalation guard: membership changes on the groups ISE's own roles derive from are structurally refused.

---
# M365

| Function | Description |
| --- | --- |
| State sync | License SKUs (consumed vs enabled). |
| Entity discovery | ~25–30 subscribed services as external `application` entities from service-health overviews. |
| Alerts | Service-health issues. |
| Observations | License pool near-exhaustion and license status, with a percent threshold. |
| Actions | None, permanently by design (ADR 0066) — M365 is a third party ISE observes. |

**Evidence**

| Query | Description |
| --- | --- |
| `service_health_issue` | One Service Health issue's full detail and status. |
| `message_center` | Recent Message Center announcements (change notices). |
| `license_detail` | The full licence inventory — every subscribed SKU. |

---
# Freshservice

| Function | Description |
| --- | --- |
| Ticket sweep | 60s sweep lands tickets on the Events screen (first sighting only). No alerts/entities — ticket noise stays out of the incident queue. |
| Observations | `ticket_burst` and `ticket_duplicate` (similarity clustering with LLM adjudication of borderline pairs); both threshold-tunable. |

**Evidence**

| Query | Description |
| --- | --- |
| `ticket_detail` | One ticket's full detail. |
| `recent_tickets` | Recently created/updated tickets over a window. |
| `ticket_search` | Search tickets by query. |

**Actions**

| Action | Description |
| --- | --- |
| `create_ticket` | T1 — raise a ticket (subject, description, priority, type, group). ISE-raised tickets are excluded from its own detection. |

---
# GitHub

| Function | Description |
| --- | --- |
| Repo sync | Hourly sweep, SHA-gated; read surface covers trees, files, commits, changed paths, releases. |
| Alerts | Workflow failures, open Dependabot alerts, open code-scanning alerts. |

**Actions**

| Action | Description |
| --- | --- |
| `open_pull_request` | T2 — create a branch, one atomic multi-file commit, and a PR. Deliberately no merge action; refuses unregistered repos. |

---
# Confluence

| Function | Description |
| --- | --- |
| Documents | Hourly scrape of registered pages into the document store. Read-only, permanently — ISE never writes to the wiki. |

---
# Status Pages

| Function | Description |
| --- | --- |
| Page sweep | 60s sweep of public status pages (Atlassian Statuspage JSON or RSS); no credential needed. |
| Entity discovery | One external `application` entity per tracked service — the only source that can tell ISE a third party (e.g. Twilio) exists. |
| Alerts | Raised and recovered from page state by the sweep. |

---
# Microsoft Teams

| Function | Description |
| --- | --- |
| Notifications | Outbound only: incident opened/escalated/resolved (severity-gated), action pending, integration broken. Delivers to users, group chats, assignees; card edit-in-place; per-channel anti-flap. Never enters approval machinery. |

---
# MCP Evidence

| Function | Description |
| --- | --- |
| Evidence | Catalogue discovered live from the remote MCP server's tool list; each tool becomes an evidence query. No write path, permanently. |

---
# Webhook (internal)

| Function | Description |
| --- | --- |
| Push ingest | Token-in-URL ingest raising ordinary alerts; recovery via explicit event or TTL sweep. Hidden from integration surfaces (ADR 0078 — core application, not an integration). |

---
# Integration Packs (uploaded YAML)

A whole class of integration that needs no code (ADR 0094): a read-only integration described in a YAML document an admin uploads. The connector's identity comes from a row rather than a class — its type, display name, credential form and capabilities are all read off the document.

The safety properties are **structural, not conventional**: `action_catalogue` returns empty unconditionally and no pack field could populate it, so the write path is unreachable rather than merely unused; `credential_use().write` is False, so Settings never offers a write slot; and capabilities are derived from the document's own mappings, so a pack cannot advertise Entities and then enumerate none.

| Pack | Description |
| --- | --- |
| GitHub Status | GitHub's public status page. Components join the estate as external Applications; unresolved incidents arrive as Alerts. No credential — the example pack. |
| GitLab | Projects, pipelines and their state. Built as the acceptance proof that a real integration could be added with **zero core changes** (ISE-505..508). |

Packs have **no actions and no write path, permanently**. Anything needing to change a system has to be a coded connector.

## Planned, unbuilt

| Integration | Status |
| --- | --- |
| Voice escalation + on-call rotas | ADRs 0079/0080 accepted; ISE-545..549 in Backlog. No ACS/PSTN/rota code yet. |
| GitLab as a *coded* connector | The pack above covers read-only use. A coded connector would only be needed to act on GitLab (packs can never write) — not planned. |
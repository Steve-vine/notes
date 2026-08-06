---
id: 01KZB355P1024JY3NQE8VFVF6Y
created: 2026-08-06T08:31:07.457492Z
updated: 2026-08-06T09:26:22.274781Z
type: memo
title: ISE Test Plan
project: 01KX671DATY39VW6GWK3M2T3DN
---
# ISE Test Plan — Claude Code via the ISE MCP surface

Purpose: verify from a real Claude Code session that every integration behaves the way it was designed — reads, evidence, actions, tiers, and guards — over the ISE MCP server (ADR 0055). Work through the sections in order; the platform sections prove the plumbing the integration sections depend on.

**Setup:** mint an MCP token (Settings → Claude Code → New MCP token), connect Claude Code, and have at least one open incident to pin. Where a test needs a proposed change, trigger it from the ISE app first (proposals cannot be made over MCP — see Known gaps).

---

## 1. Connection, discovery & session discipline

- [x] `describe_resources` returns the install's resource areas with counts, every enabled System with its capabilities, and the correct role tier for my token
- [ ] With a viewer-role token, `tools/list` shows no write tools at all (approve/record/merge etc. absent, not just refused)
- [x] `search_incidents` finds an incident by fuzzy text and returns IN-NNNN refs
- [x] `list_incidents` filters by status / severity correctly
- [x] `/mcp__ise__work-on IN-NNNN` pins the session; Claude presents the brief + cues (merge candidates, similar priors, playbooks, pending approvals) then stops and waits
- [ ] A session-required tool (e.g. `get_timeline`) called with no pinned session refuses with an instructive message naming `start_incident_session`
- [x] Pinning a second incident supersedes the first (first session ends with reason `superseded`)
- [ ] Re-pinning the same incident resumes rather than duplicates
- [ ] The incident screen in the ISE UI shows the live Claude session chip while pinned
- [ ] `/mcp__ise__exit` records conclusions and releases the pin; timeline shows session start/end
- [ ] All read activity during the session collapses into a per-session activity block on the incident timeline (`mcp_activity` recording works)

## 2. Investigation reads (pinned session)

- [ ] `get_incident_brief` and `get_timeline` return coherent, current data for the pinned incident
- [ ] `search_signals` scopes to the pinned entity by default; `all_entities=true` widens it
- [ ] `get_entity` + `traverse_graph` (downstream, upstream, both) walk the estate graph correctly from the incident's entity
- [ ] `search_estate` and `search_tags` find known entities/tags
- [ ] `list_events` shows recent inbound webhook events
- [ ] `find_playbooks` surfaces the applicable playbooks with efficacy stats
- [ ] `search_documents` / `read_document` retrieve Confluence-scraped docs
- [ ] `search_repos` / `read_repo_file` retrieve file content and commits from a registered GitHub repo
- [ ] `list_evidence_queries` lists every evidence-capable System with parameter schemas
- [ ] `fetch_evidence` on any query writes an `mcp_evidence_pulled` event on the incident timeline

## 3. Incident actions & approvals (governance)

- [ ] `update_incident_status`: acknowledge, resolve (cascades to signals + merged children), reactivate
- [ ] `record_note` lands as a `user` turn in the incident conversation (ADR 0024), visible in the UI
- [ ] `merge_incident` merges another incident into the pinned one and implicitly acknowledges it (ADR 0038); `detach_incident` reverses it
- [ ] `commit_diagnosis` writes a diagnose run attributed to `claude-code` / `operator-session` with zero spend
- [ ] `list_pending_approvals` shows pinned-incident proposals by default; `all_incidents=true` shows everything
- [ ] `get_proposed_change` shows operation, params, tier, rationale, provenance; for a **T3** change it adds the "review on the Approvals screen" nudge
- [ ] `approve_change` on a T2 change (proposed by someone else) acknowledges the incident and hands to the executor — verify the change actually executes
- [ ] `reject_change` requires a comment and records it
- [ ] **Separation of duties:** approving my own T2/T3 proposal is refused (`SelfApprovalError`)
- [ ] Approve/reject are refused (absent) below approver role
- [ ] A T1 action under a System whose risk policy opts into auto-apply executes without approval; the same action with no opt-in queues for approval
- [ ] A protected-target entity (ADR 0021) is refused regardless of tier or approval

## 4. DataDog

- [ ] Services and hosts appear as estate entities; monitor alerts land as signals (ignore rules honoured, ADR 0044)
- [ ] Evidence: `query_metrics`, `search_logs`, `search_events`, `active_metrics`, `synthetics_test` all return live data
- [ ] `ack_event` proposal is **T0** and auto-applies
- [ ] `mute_monitor` (T1) requires a duration ≤ 1 week and creates a real downtime; `unmute_monitor` clears it
- [ ] `set_host_tag` (T1) writes the tag in DataDog
- [ ] `edit_monitor` is **T2** — queues for human approval, never auto-applies

## 5. Kubernetes

- [ ] Cluster / namespace / workload / node / service / secret entities sync with part-of, routes-to, runs-on, depends-on edges
- [ ] Observations (not alerts) raised for crash loops, OOM-kills, pending pods
- [ ] Evidence: `describe_pod`, `node_capacity`, `recent_events`, `pending_pods`, `rollout_status`, `pod_logs`
- [ ] `restart_rollout`, `scale_workload`, `set_label` are T1; `edit_resource` is T2
- [ ] `delete_resource` is **T3** — always needs human approval, MCP nudges to the Approvals screen

## 6. AWS

- [ ] EC2 / RDS / EKS / ELB / S3 / VPC entities sync with account-scoped keys; cross-keys link to DataDog hosts and k8s nodes
- [ ] CloudWatch ALARM states and Health events arrive as signals
- [ ] Evidence: `describe_resource`, `list_resources`, `cloudwatch_metric_statistics`, `logs_filter_events`, `cloudtrail_lookup_events`
- [ ] `reboot_instance` / `start_instance` / `set_resource_tag` are T1; `stop_instance` / `reboot_db_instance` are T2
- [ ] Confirm no IAM actions exist anywhere in the catalogue (ADR 0060 §4)

## 7. Azure

- [ ] VM / AKS / database / App Gateway / storage / App Service / VNet / private-endpoint entities sync
- [ ] Azure Monitor fired alerts + Service Health arrive as signals
- [ ] Evidence: `describe_resource`, `list_resources`, `monitor_metrics`, `activity_log`, `log_analytics_query` (KQL, read-only)
- [ ] `restart_vm` / `start_vm` / `restart_app_service` / `set_resource_tag` are T1; `deallocate_vm` / `restart_pg_flexible_server` are T2
- [ ] Confirm no RBAC actions exist in the catalogue (ADR 0061 §4)

## 8. Cloudflare

- [ ] Zones, tunnels, load-balancers, Workers/Pages entities sync with routes-to edges; DNS records are evidence-only, not entities
- [ ] Notification alert history arrives as signals over the bounded window
- [ ] Evidence: `list_dns_records`, `security_events`, `zone_analytics`, `audit_log`, `tunnel_connections`
- [ ] `purge_cache_urls` is T1; `update_dns_record` (existing records only), `purge_cache_everything`, `set_ip_access_rule`, `set_security_level`, `set_pool_enabled` are all T2
- [ ] `update_dns_record` on a non-existent record is refused (no record creation path)

## 9. EntraID

- [ ] Users (incl. guests), identity groups, applications/SPs, CA policies sync as entities
- [ ] Identity Protection risky users arrive as signals (stateful); SP-less app registrations raise observations (ADR 0076)
- [ ] Evidence: `user_sign_ins`, `directory_audit_log`, `risk_detections`, `user_detail`, `group_members`, `ca_policy_detail`, `app_credential_expiry`
- [ ] **Every** action (`revoke_user_sessions`, `disable_user`, `enable_user`, `add_group_member`, `remove_group_member`, `set_ca_policy_state`) is **T3** — never auto-applies, always human approval
- [ ] **Self-escalation guard** (ADR 0064): a group write targeting a group ISE's own roles derive from (incl. transitively nested) is refused outright
- [ ] Confirm no password, credential, or role-assignment writes exist in the catalogue

## 10. M365

- [ ] Subscribed services appear as third-party/application entities
- [ ] Unresolved Service Health issues arrive as signals and clear when Microsoft resolves them
- [ ] Licence-pool exhaustion raises entity-less observations
- [ ] Evidence: `service_health_issue`, `message_center`, `license_detail`
- [ ] Confirm the action catalogue is **empty by design** — ISE observes Microsoft, never operates it

## 11. GitHub

- [ ] Registered repos are searchable (`search_repos` / `read_repo_file`); repos are a register, not estate entities
- [ ] Workflow-run failures, Dependabot, and code-scanning alerts arrive as signals for registered repos only
- [ ] `open_pull_request` (**T2**) creates a real PR as one atomic commit after approval
- [ ] Confirm there is **no** `merge_pull_request` action — merging stays human

## 12. FreshService

- [ ] No CMDB entities are synced (ADR 0068 — deliberate)
- [ ] `ticket_burst` / `ticket_duplicate` raise **observations, never alerts**; a single ticket raises nothing
- [ ] Evidence: `ticket_detail`, `recent_tickets`, `ticket_search`
- [ ] `create_ticket` (T1) creates a ticket tagged `ise-generated`, and that ticket is **excluded at ingest** (no feedback loop)
- [ ] Confirm no update/close-ticket or CMDB-write actions exist

## 13. Teams, Confluence, Status pages, Webhooks (read-only / outbound by design)

- [ ] Teams: incident notifications arrive in the configured chats; confirm the bot is send-only with an empty action catalogue
- [ ] Confluence: documents reach the Document Register and are readable via `search_documents`/`read_document`; confirm ISE never writes to the wiki
- [ ] Status pages: tracked services appear as third-party entities and raise signals on issues
- [ ] Webhooks: an inbound event appears via `list_events` and can become a signal on the mapped entity
- [ ] Generic MCP evidence source: a configured third-party MCP server appears in `list_evidence_queries` and serves evidence — read-only, no actions

## 14. Playbook authoring loop (operator, no session needed)

- [ ] `list_pending_learnings` shows learning proposals; `confirm_learning` accepts one
- [ ] `draft_playbook` / `update_playbook` work; editing a LIVE playbook retracts it
- [ ] `publish_playbook` refuses when the publisher is the sole author (author ≠ publisher)
- [ ] `publish_playbook` refuses a T3 desk-executable envelope
- [ ] `retract_playbook` takes a live playbook down

## 15. Not testable yet — known gaps

- `propose_change` is in the design brief but **not registered** — changes cannot be proposed over MCP today; only reviewed/approved. Tests above assume proposals originate in the app or from the AI engine.
- Playbook *runs* are app-only; the responder-tier blurb advertising desk-executable runs over MCP is aspirational.
- **GitLab**: no connector exists yet (read-pack plans only). Nothing to test.
- **Servers/Ansible**: ADR 0084 still Proposed; planned T2 actions (`restart_service` etc. with `--check --diff` preview) not built. Add a section here when it ships.

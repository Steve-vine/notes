---
id: 01KZB355P1024JY3NQE8VFVF6Y
created: 2026-08-06T08:31:07.457492Z
updated: 2026-08-07T15:12:43.535882Z
type: memo
title: ISE Integration Test Plan
project: 01KX671DATY39VW6GWK3M2T3DN
---
# ISE Test Plan — Claude Code via the ISE MCP surface

Purpose: verify from a real Claude Code session that every integration behaves the way it was designed — reads, evidence, actions, tiers, and guards — over the ISE MCP server (ADR 0055). Work through the sections in order; the platform sections prove the plumbing the integration sections depend on.

**Setup:** mint an MCP token (Settings → Claude Code → New MCP token), connect Claude Code, and have at least one open incident to pin. Changes can be proposed over MCP with `propose_change` (ISE-584); proposing from the ISE app, or letting the AI engine propose, are equally valid ways to set up an approval test.

---

## 1. Connection, discovery & session discipline

- [x] `describe_resources` returns the install's resource areas with counts, every enabled System with its capabilities, and the correct role tier for my token
- [ ] With a viewer-role token, `tools/list` shows no write tools at all (approve/record/merge etc. absent, not just refused)
- [x] `search_incidents` finds an incident by fuzzy text and returns IN-NNNN refs
- [x] `list_incidents` filters by status / severity correctly
- [x] `/mcp__ise__work-on IN-NNNN` pins the session; Claude presents the brief + cues (merge candidates, similar priors, playbooks, pending approvals) then stops and waits
- [x] A session-required tool (e.g. `get_timeline`) called with no pinned session refuses with an instructive message naming `start_incident_session`
- [x] Pinning a second incident supersedes the first (first session ends with reason `superseded`)
- [x] Re-pinning the same incident resumes rather than duplicates
- [x] The incident screen in the ISE UI shows the live Claude session chip while pinned
- [x] `/mcp__ise__exit` records conclusions and releases the pin; timeline shows session start/end
- [x] All read activity during the session collapses into a per-session activity block on the incident timeline (`mcp_activity` recording works)

## 2. Investigation reads (pinned session)

- [x] `get_incident_brief` and `get_timeline` return coherent, current data for the pinned incident
- [x] `search_signals` scopes to the pinned entity by default; `all_entities=true` widens it
- [x] `get_entity` + `traverse_graph` (downstream, upstream, both) walk the estate graph correctly from the incident's entity
- [x] `search_estate` and `search_tags` find known entities/tags
- [x] `list_events` shows recent inbound webhook events
- [x] `find_playbooks` surfaces the applicable playbooks with efficacy stats
- [x] `search_documents` / `read_document` retrieve Confluence-scraped docs
- [x] `search_repos` / `read_repo_file` retrieve file content and commits from a registered GitHub repo
- [x] `list_evidence_queries` lists every evidence-capable System with parameter schemas
- [x] `fetch_evidence` on any query writes an `mcp_evidence_pulled` event on the incident timeline

## 3. Incident actions & approvals (governance)

- [x] `update_incident_status`: acknowledge, resolve (cascades to signals + merged children), reactivate
- [ ] `assign_incident` with no argument assigns the incident to me and activates it (ISE-589); the app shows my name on the incident and the change on the timeline
- [ ] `assign_incident` to another person by name or email works; an ambiguous name is refused with the candidates listed, and `"nobody"` unassigns
- [x] `record_note` lands as a `user` turn in the incident conversation (ADR 0024), visible in the UI
- [x] `merge_incident` merges another incident into the pinned one and implicitly acknowledges it (ADR 0038); `detach_incident` reverses it
- [x] `commit_diagnosis` writes a diagnose run attributed to `claude-code` / `operator-session` with zero spend
- [x] `list_pending_approvals` shows pinned-incident proposals by default; `all_incidents=true` shows everything
- [ ] `propose_change` proposes a T1/T2 change on the pinned incident from Claude Code; it appears on the Approvals screen in the UI with the operator as proposer
- [ ] `propose_change` refuses an operation outside the integration's catalogue, parameters that do not satisfy its schema, and a protected target (ADR 0021) — none of them leaving a row behind
- [ ] The tier on the resulting change comes from the catalogue and policy — a caller cannot ask for one
- [ ] `get_proposed_change` shows operation, params, tier, rationale, provenance; for a **T3** change it adds the "review on the Approvals screen" nudge
- [ ] `approve_change` on a T2 change (proposed by someone else) acknowledges the incident and hands to the executor — verify the change actually executes
- [ ] `reject_change` requires a comment and records it
- [ ] **Separation of duties:** approving my own T2/T3 proposal is refused (`SelfApprovalError`)
- [ ] Approve/reject are refused (absent) below approver role
- [ ] A T1 action under a System whose risk policy opts into auto-apply executes without approval; the same action with no opt-in queues for approval
- [ ] A protected-target entity (ADR 0021) is refused regardless of tier or approval

### 3a. The gated-write walk, in one sitting (ISE-598)

The items above test the pieces. This is the **whole path on one surface**, done
as a single unbroken sequence — which is the thing that was never checked, and
the thing ADR 0090's Claude Code row actually claims.

`tests/integration/test_mcp_gated_write_path.py` now proves this logic in CI
against the fake connector, so what a live walk adds is the parts CI cannot
have: a **real** connector, a **real** Celery worker, and the queue between
them. Do it against a system you are content to change.

- [ ] **Propose.** `propose_change` a T2 from a pinned session. Note the change id from the response, and check the Approvals screen shows it with you as proposer
- [ ] **Refuse yourself.** `approve_change` on your own proposal → refused, naming separation of duties. (Mint a second person's token, or use a second identity, for the next step)
- [ ] **Approve.** A different human approves over MCP. The response says it was handed to the executor
- [ ] **It actually ran.** `get_proposed_change` reports `executed`, with a `result` carrying the connector's detail and its `before` snapshot. Confirm the change is real in the target system — this is the step CI cannot do
- [ ] **Claude can see it without the id.** `get_timeline` carries a `proposed_change` card whose `status` is `executed`. (`list_pending_approvals` deliberately shows only what is still waiting, so the timeline is how an executed change is found again)
- [ ] **The trail.** The ISE audit log for that change reads `proposed → awaiting_approval → approved → executed`, the approver is named on the approval, and the proposal carries `via: claude`
- [ ] **The ceiling holds.** A T3 stays queued on a system whose policy claims `auto_apply: {T3: true}` — a misconfigured policy must fail *stricter*, never looser
- [ ] **Absence is not consent.** A T1 on a system with an empty `risk_policy` waits for a human
- [ ] **The band works.** With `auto_apply` set for T0/T1 on that system, both execute with no human; the audit trail names `policy:auto_apply`, not a person
- [ ] **Disabled beats approved.** Approve a T2, then switch the integration off before the worker runs it. It must FAIL, not fire — and the reason must be legible from `get_proposed_change`, not only in a log (ISE-461)
- [ ] **A connector failure is visible where it was approved.** Force one; the change reads `failed` with the reason, never `approved` for ever

## 4. DataDog

- [x] Services and hosts appear as estate entities; monitor alerts land as signals (ignore rules honoured, ADR 0044)
- [x] Evidence: `query_metrics`, `search_logs`, `search_events`, `active_metrics`, `synthetics_test` all return live data
- [ ] `ack_event` proposal is **T0** and auto-applies
- [ ] `mute_monitor` (T1) requires a duration ≤ 1 week and creates a real downtime; `unmute_monitor` clears it
- [ ] `set_host_tag` (T1) writes the tag in DataDog
- [ ] `edit_monitor` is **T2** — queues for human approval, never auto-applies

## 5. Kubernetes

- [x] Cluster / namespace / workload / node / service / secret entities sync with part-of, routes-to, runs-on, depends-on edges
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
- [ ] `recent_commits` answers "what changed in repo X in the last 24 hours" chronologically from ISE's own data, with no `gh` fallback (ISE-587); the query lands on the incident timeline
- [ ] `recent_commits` names a repo by `owner/name` or a substring, refuses an ambiguous one, and states its limits (registered repos, default branch, sync freshness)
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

- [ ] `list_playbooks` enumerates the whole library from any conversation with no pinned incident (ISE-590), matching what the Playbooks screen shows; `live_only` and a substring query both filter, and truncation is declared
- [ ] Library rows separate desk-executability (`live`, `published_by`) from earned standing, and advisory vs remediation playbooks report standing in their own words
- [ ] `get_playbook` returns the procedure body and the envelope's limits in plain language
- [ ] `list_pending_learnings` shows learning proposals; `confirm_learning` accepts one
- [ ] `draft_playbook` / `update_playbook` work; editing a LIVE playbook retracts it
- [ ] `publish_playbook` refuses when the publisher is the sole author (author ≠ publisher)
- [ ] `publish_playbook` refuses a T3 desk-executable envelope
- [ ] `retract_playbook` takes a live playbook down

## 15. Not testable yet — known gaps

- Playbook *runs* are deliberately app-only (ADR 0055 §4 amendment, ISE-584) — not a gap. `describe_resources` no longer advertises them.
- **GitLab**: no connector exists yet (read-pack plans only). Nothing to test.
- **Servers/Ansible**: ADR 0084 still Proposed; planned T2 actions (`restart_service` etc. with `--check --diff` preview) not built. Add a section here when it ships.

*(The four gaps found during the 2026-08-06 run — ISE-584, ISE-587, ISE-589, ISE-590 — are all built in the MCP Surface Gaps sprint and now have checkboxes above rather than entries here.)*

*(ISE-598, 2026-08-07: the gated-write path was walked end to end and **no gap
was found** — propose, approve, inspect, timeline and the executor were all
already right. What was missing was any test that crossed the seams between
them, so §3a is now covered in CI by `test_mcp_gated_write_path.py` and the live
walk exists to exercise what CI cannot: a real connector, a real worker, and the
queue between them.)*

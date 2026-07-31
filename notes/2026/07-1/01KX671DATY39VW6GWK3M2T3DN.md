---
id: 01KX671DATY39VW6GWK3M2T3DN
created: 2026-07-10T14:31:22.714867Z
updated: 2026-07-31T15:07:37.522698Z
type: project
title: ISE
identifier: ISE
next_task_number: 444
start: 2026-07-10
due: 2026-08-31
sprints:
- id: sh9ng2k
  title: Application Scaffold
  description: 'Phase 0 — Foundations: an empty app that ships. Complete 2026-07-10.'
- id: sqtx330
  title: Core Platform
  description: Phase 1 — a logged-in shell over the domain model. Complete 2026-07-11 (11/11).
- id: sdm5e08
  title: State Sync
  description: Phase 2 — DataDog + Kubernetes read-only sync; the pane of glass shows real state. Deterministic, no AI. Complete 2026-07-12 (13/13).
- id: syv1q8m
  title: AI Analysis
  description: Phase 3 — ISE detects issues itself. Pydantic AI (ADR 0013); summarise-state / analyse / diagnose, read-only.
- id: sdcd2jr
  title: Remediation
  description: Phase 4 — tiered-approval remediation (ADR 0017); ISE gained WRITE credentials. Complete 2026-07-14 (15/15, incl. 7 exit-test defects). Default-deny; nothing auto-applies.
- id: syz8rn1
  title: Assist + Search
  description: Phase 5a — assist chat (SSE, ADR 0022; read-only DB boundary, ADR 0023) + global search behind a Cmd-K palette. Complete 2026-07-15 (13/13), released to main. Hardening moved to Sprint 8.
- id: syqgx3z
  title: Workflow Review & Polish
  description: 'Feature-complete after Sprints 1-6. Stop building; judge how the whole app WORKS and FEELS as one product. A structured end-to-end walkthrough on staging — sign in → estate → issue → diagnose → propose → approve → execute → audit, then assist and search — noting rough edges, cross-screen inconsistency, interaction friction, and empty/loading/error states. That review GENERATES the task list: targeted tweaks, not new architecture. Steve leads the feel judgement; Claude drives the walkthrough, captures findings, implements agreed changes. Tasks TBD.'
- id: s0v93ii
  title: Issue Loop
  description: |-
    Update the issue handling workflow to include a proper remediation loop.
    analyse -> diagnose -> propose -> approve -> execute -> (repeat)
- id: sd1gs0p
  title: Hardening
  description: |-
    Phase 5b — operational hardening deferred from Phase 5. ISE runs the full loop and holds WRITE credentials; make it survivable in prod. Gaps mapped in Sprint 6 exploration: Postgres backup/restore (CNPG single-instance, no backup today; MUST include the KEK or a restore yields undecryptable credentials); rate limits (only break-glass is limited — security-model.md already claims more than the code does); ISE→DataDog log shipping + self-monitoring (makes ADR 0015's break-glass ALERT real — today it's an ERROR line nothing collects); break-glass verification drill + last-used tracking + Settings→Access UI; NetworkPolicies; registry retention (Zot accumulates tags, ADR 0008 names the gap); golden-run eval fixtures as a manual/nightly job, never in the PR gate. Decisions taken: DataDog self-monitoring; evals nightly not gated. Likely 1-2 ADRs. Follow staging-first deploys. Completes Phase 5 + MVP operational readiness.

    NOTE (Sprint 10 review): deferred as a block behind the cost re-architecture (Sprints 11-14) — hardening a product whose viability is unproven is premature. Nothing obsoleted, nothing closed. ISE-73 (backup+KEK) pulled forward to Sprint 10 as catastrophic-loss insurance. ISE-80 (evals) a candidate to pull into the re-architecture as regression safety. ISE-74 (rate limiting) overlaps the new auto-investigation trigger caps.
- id: scxrykd
  title: Spend issues
  description: |-
    Having just come to use the system today, I managed to trigger 3 or 4 actions before running out of budget.  There seems to be an issue using up almost all of the budget while the system is idle.  Seeing as there are currently only 2 systems connected to ISE, that raises serious concerns over the viability of the way the product works.  In this sprint I want to analyse how the product currently works, and what changes need to be made to the functionality in order to make it viable from a cost perspective.  Seeing as the outcome of this could potentially end of with the product being shelved, I want to revisit some of the fundamental principles of the project including existing design decisions.

    OUTCOME: analysis produced the ISE Canon (target model) + a re-architecture roadmap across Sprints 11-15. This sprint now carries the immediate spend-relief work: prompt caching (ISE-107), model tiering (ISE-108), the DataDog idle-drain-leak fix, plus ISE-73 (backup+KEK) pulled forward.
- id: stgj737
  title: Signals & Incidents foundation
  description: 'Re-architecture spine (per the ISE Canon). Split detection into transient Signals — Alerts (from a source''s own detection layer) and Observations (ISE-detected where there is none) — flowing onto durable, human-owned Incidents; replace the 1:1 Finding→promotion→Issue mapping. Add the canonical severity ladder, a global auto-incident threshold + confidence bar, and a scoped severity-override layer. Reshape connectors to declared capabilities and cut DataDog to monitors-only Alerts (per-group) + evidence-on-demand, retiring metric/event detection (a large idle-spend cut). ADRs: Signals & Incidents; Severity, confidence & thresholds; Connector capability contract. The load-bearing spine — proves the cost thesis early.'
- id: sp5m61e
  title: Estate Knowledge Base
  description: 'The Estate Knowledge Base (per Canon): entities + integration aliases + typed edges + context annotations, in Postgres. Identity resolution — harvest cross-tags automatically, AI-proposed candidate matches, human-asserted aliases (sticky). Discovered-vs-authored reconciliation; graph-as-cache validated by the Obs Loop (drift surfaces as Observations). Conversational query / validate / enrich over the chat surface (audited internal writes, not infra actions). The join-spine that makes cross-integration investigation directed and cheap. ADR: Estate Knowledge Base.'
- id: sdv8hgy
  title: Incident Loop (learning)
  description: 'The Incident Loop learning layer (per Canon): wrap the existing diagnose→propose→execute→verify with Recall (memory + playbook retrieval) at the front and Update (write memory, playbooks, newly-learned structure) at the back. Two-phase incident signatures (trigger for retrieval, diagnostic for learning) built from stable attributes; memory hung off the entity graph; playbooks (six-part, referencing the governed action catalogue, efficacy-tracked, human-confirmed). Directed investigation via the knowledge base. Self-tiering — cost per incident falls as memory grows. ADR: Incident Loop + memory + playbooks.'
- id: srmqjcq
  title: Obs Loop & Observations
  description: 'Obs Loop & Observations (per Canon): a slow, per-integration scheduled detector loop — mostly cheap deterministic detectors + context-driven suppression, AI reserved for genuine novelty — producing Observations, a baseline of record, and knowledge-base drift checks. Kubernetes observation detectors (CrashLoopBackOff, OOMKill, pending pods, failing probes, cert expiry, resource saturation…). Retire the 15-/30-min summarise/analyse timers entirely. ADR: Obs Loop.'
- id: sehghhk
  title: Integration modularity
  description: |-
    Integration modularity (per Canon; downstream of viability — deliberately last). Harden the connector capability contract; a generic MCP-backed Integration Type for Evidence (and, with per-action classification, Actions); move toward independently-deployable integrations behind a versioned contract (out-of-process, MCP for tool capabilities, authorization stays in core, never the shared DB). Platform extensibility. ADR: Independently-deployable integrations.

    RELEASED to main 2026-07-20 (ISE-145..150 + ISE-154 budget fix): ADR 0031; Type-aware add-integration + surfaced capabilities; per-integration capability display + graceful degradation; generic MCP Evidence Type; on-demand Evidence in investigation; DataDog metrics/logs → Evidence (eager metrics slice retired).
- id: skj7tft
  title: Post-Canon polish & legibility
  description: 'First sprint after the Canon re-architecture (Sprints 11–15 shipped). Collects product-completeness and legibility gaps surfaced by actually using the app on staging — the ''/single pane of glass/'' polish the DoD demands, not new architecture. Opened with alert legibility: an operator can see that a monitor fired but not why.'
- id: sth83hw
  title: Tags
  description: 'Tags become a first-class concept: a unified, normalized tag pool ingested from all integrations (K8s labels, Datadog host/service/monitor tags) with per-integration provenance; a Tag Cloud page (own nav entry) with alert-count heat over a selectable window (24h/7d/30d) and integration filter, with per-tag drilldown; and admin-defined tag rules (AND-ed predicates, optional integration scope) that materialize real group entities (new type `group`) with rule-provenance part-of edges in the estate graph — e.g. service:kora → "Kora", cluster-x + env:prod → "Public customer facing applications". One ADR (unified tag pool + tag-derived groups), migrations 0037/0038. ISE-179..186; T1→T2→T3→T4→T8 and T1→T5→{T6,T7} run as two tracks after the foundation.'
- id: sohzsw2
  title: Bugs and Improvements
  description: Issues and improvements identified while using the app
- id: sbeam3b
  title: Estate Lifecycle
  description: 'Estate entities gain a lifecycle: last-seen tracking stamped by discovery, retirement of entities no longer seen at source (retire/archive, never delete — signals, tags and audit hang off entity.id), and the operator-facing story for retired entities in the estate UI. Opened from the Sprint 17 tag investigation: ghost hosts accumulate forever (92/202 hosts no longer exist in DataDog) because nothing in the estate is ever cleaned up.'
- id: s5khymf
  title: Relationship Mapping
  description: |-
    A holistic think-through and implementation of how estate assets relate — from inventory to impact. Motivating scenario (2026-07-22): an RDS out-of-memory alert should answer "which Services does this affect — Kora or another app? Production or test?" in one glance; today it cannot.

    Diagnosis from the code walk: the estate has inventory (entities/aliases, ADR 0028), classification (tags + tag-derived groups, ADR 0037) and context (annotations) — but the dependency layer is schema-only. EDGE_TYPES already defines depends-on / routes-to for blast-radius traversal, yet nothing creates them: K8s discovery emits only part-of containment, DataDog discovery emits zero edges (APM service-dependency map never read), and edge assertion is API-only with no UI. The blast-radius engine (investigation_context / traverse, ISE-129) already exists but only feeds AI prompts — the incident screen shows the affected entity as name + link, no groups/env/dependents; group membership isn't even a field on the member entity.

    Candidate scope to flesh out: relationship authoring UI (assert/remove edges — API + types exist); deterministic harvest (K8s Service→selector routes-to, pod/workload runs-on node; DataDog APM dependencies where present); AI-proposed depends-on candidates (alias-proposal precedent, ADR 0028 §3); an "Affects" impact panel on the incident reusing traverse(); group/env rollup onto entity detail and incident context; possibly an AWS connector slice so things like RDS are first-class entities. Needs an ADR (relationship model & impact surfacing). Sprint scope TBD with Steve.
- id: skiru9m
  title: Twingate integration
  description: Add a Twingate sidecar to the integration pod to allow connectivity to the internal network.
- id: s6pc5xk
  title: Webhook notifications
  description: 'Create an integration to accept webhooks from external systems, these can be used to give the user visibility of what’s happening as well as providing signals. '
- id: sthz8ne
  title: AI Cost Management
  description: Better visualise and control AI Costs
- id: svgrad3
  title: AI Interaction Review
  description: 'Review how AI interactions work end-to-end and remove what needlessly limits them. Opened 2026-07-24 after two live findings: an analyse-issue run burned >200k tokens (killed by the run cap) to conclude the issue had resolved itself, and issue-chat could not check DataDog directly — it answered that it is limited to what ISE already holds (the ADR 0023 read-only chat boundary; connector evidence tools are not exposed to the chat surfaces). Scope: MAP the interaction workflow per surface (analyse-issue / diagnose / propose / execution-followup / assist / issue-chat) — what context is assembled, from where, at what token cost, and what tools each surface may call; classify every limitation as deliberate design (ADRs 0022/0023/0026, caps) vs accidental; then TUNE — bound context assembly for an estate that has doubled, evidence-on-demand for chat, right-sized caps. The mapping deliverable comes first; expect ADR amendments where deliberate limits no longer serve their purpose.'
- id: sak4nk6
  title: Dashboards
  description: Create a dashboard system to show important information that is simple and clear enough to be displayed on a wallboard.
- id: siyfhjg
  title: Code Repos
  description: Create access to IAC repos in Github
- id: sr2f21y
  title: CI Performance & Hardening
  description: 'CI/CD pipeline performance & hardening — from the 2026-07-26 pipeline review. The g5 node is near-idle at rest (3% CPU / 9% mem of 16 cores / 96GB) but jobs degrade badly under concurrency (backend job seen 6m→14m→41m; api-types 1m→11m across 3 concurrent runs). Three compounding causes, none of them node capacity: (1) runner pods declare NO cpu/mem requests, so ARC packs up to 10 on one node and they thrash; (2) external deps aren''t mirrored on g5 — PyPI, the npm registry and the GitHub Actions cache service all hit the internet (the 193s uv sync, npm ci, and a 63MB cache restore crawling at 0.1MB/s that caused the ClusterLink flake all trace here; same failure class as the ryuk/Docker-Hub hang fixed in ISE-302); (3) duplicated work — api-types re-installs uv+node, the staging push re-runs the whole PR-gate suite, every job cold-starts install. The 1254 real-Postgres tests are the value (ADR 0016 risk-based) — run them faster, don''t cut them. Tasks below ranked by payoff/effort.'
- id: s3fr4ef
  title: AI Incident Management
  description: 'Improve how ISE relates, groups and merges incidents. Opened 2026-07-27 from a live case: IN-1091 and IN-1092 (both FailedScheduling, one cluster-capacity root cause surfacing in two namespaces) offered no merge option because merge candidates require the exact same affected entity (ADR 0035) and there is no manual merge.'
- id: sax9eff
  title: Claude Investigation Surface (MCP)
  description: 'Deep incident investigation moves to Claude Code over a governed ISE MCP server ("Variant A", decided 2026-07-27). Origin: IN-1092 — issue-chat could only re-hash synced ISE state (the K8s connector implements zero live evidence queries), and two tuning rounds showed the in-app harness will always trail a frontier one. Operators run Claude Code on their own machines/subscriptions (per Feb-2026 ToS, personal tokens must NOT be wrapped in ISE-provisioned infra — no embedding); ISE stays the system of record and the write gate. Must-haves (Steve): interactive cues (similar incidents, merge candidates) surfaced conversationally; easy incident info retrieval (status, merged tickets, alert state); ALL get/put interactions recorded on the ticket; resource-awareness (Signals, Incidents, Estate, Repos, Kubernetes, Playbooks, Confluence docs, Events, Tags); approvals surfaced in Claude + recorded in ISE (permission-gated); incident actions from Claude (resolve, merge, etc.). Session model: "ISE start working on IN-NNNN" pins the session until exit; substantive tools refuse without a pinned session; pane-of-glass kept via live timeline write-back + session indicator in the UI. Auth v1: per-user reveal-once MCP tokens (board-token precedent); OAuth later if needed. In-app issue-chat is demoted to quick Q&A, not rewritten.'
- id: sf23rna
  title: Playbooks V2
  description: 'Playbooks become the unit of pre-approved response (decided 2026-07-28 from the MCP acceptance experience; ADR 0056). The split: DevOps engineers investigate via the Claude/MCP surface and author playbooks; Service Desk staff use a guided incident page that can ONLY execute published playbooks — no per-execution approval (the ITIL standard-change model: approval is spent once, at publish). A V2 playbook is a FREEFORM natural-language body interpreted by AI inside a STRUCTURED ENVELOPE of server-enforced hard limits: allowed catalogue operations (T1/T2 only, never T3), incident-derived target binding, run bounds (max actions / wall-clock / tokens), deterministic validation predicates over evidence queries (the AI never self-certifies success), and an escalation path. Publish requires a second engineer (separation of duties moves to publish time, amending ADR 0017); efficacy decay demotes desk-executability (anti-rot). Execution = an in-app interpreted AgentRun with envelope-scoped tools, full transcript as the audit artefact, playbook-bound auto-approved ProposedChanges with pre_approved_via provenance, semi-supervised by the responder (ADR 0025 spirit: a human watches the run). New role rung: viewer < responder < operator. One playbook format serves both interpreters — ISE''s in-app runner for the desk, Claude-via-MCP for engineers — and stays simple enough for the learning loop to keep auto-drafting.'
- id: sg4216j
  title: UI Improvements
  description: 'Tidy up the UI: easier navigation and a clearer layout. Opened 2026-07-28; tasks to be planned with Steve.'
- id: s9cqr80
  title: Status Page Integration
  description: 'New ''Status Page'' integration: maintain a curated list of external service status pages (URL + a description of which services we actually use), periodically check each page for reported issues, and raise matching ones as Alert-type signals. The per-entry service description drives filtering so issues on unused services are not alerted on. Opened 2026-07-28; tasks to be planned with Steve.'
- id: sjyt01k
  title: AWS Integration
  description: |-
    New AWS integration, read-only v1 (actions next sprint). Planned with Steve 2026-07-29: one integration instance per AWS account, static access-key auth in the existing credential store; resources EC2/RDS/EKS/ELB/S3 → estate entities with account-scoped native keys aws:{account_id}:{arn} (ADR 0045) and cross_keys joining onto existing DataDog hosts (instance-id) and K8s cluster/nodes (ISE-205 precedent); two new entity types load-balancer + bucket; CloudWatch alarms + AWS Health events ingested as Alert signals like any other source — dedupe/reinforcement via same-entity attribution + merge candidates, no new cross-source architecture; evidence-on-demand (describe/metrics/logs/CloudTrail); AWS account card on System detail. ADR 0058. Tasks ISE-358..363: 358 foundation → 359 discovery → {360 alarms → 361 health, 362 evidence, 363 surface}.

    RELEASED to main 2026-07-29 (PRs #331-#336, migration 0072), all 6 tasks Done; smoke-tested on staging by Steve; staging reset to main. Follow-on: AWS actions sprint (write path, second IAM identity).
- id: s0d5f5q
  title: Azure Integration
  description: |-
    New Azure integration, read-only v1, mirroring the AWS pattern (sprint sjyt01k, ADR 0058). Planned with Steve 2026-07-29: one integration instance per subscription; service principal + client secret (tenant_id/client_id/client_secret/subscription_id) in the existing credential store; discovery of VMs, Azure Database (SQL+PG flexible servers), AKS, Load Balancers + App Gateways, Storage Accounts, App Services + Function Apps → estate entities with native keys azure:{subscription_id}:{resource_id} and cross_keys onto DataDog hosts + existing K8s cluster/node entities; reuse load-balancer/bucket entity types from AWS, App Service → workload (no migration this sprint); Azure Monitor alerts (Sev0-4 → canonical ladder) + Service Health as Alert signals via existing same-entity dedupe; evidence-on-demand (describe / metrics / Activity Log / optional Log Analytics KQL); subscription card on System detail. ADR 0059; zero new dependencies (ArmClient over httpx, no Azure SDK); no region config tenant (ARM is global).

    RELEASED to main 2026-07-30 (PRs #337-#342, no migration), ISE-364..369 all Done; smoke-tested live on the CSP Softcat subscription (161 entities, smart-detector alert ingested) after two live-found fixes ($expand=instanceView unsupported at subscription scope → statusOnly sweep; rule|target alert key overflowed finding.source_key varchar(300) → _bounded_key on all minted keys); staging reset to main. Follow-ups in-sprint: ISE-371 (worker OOM under concurrent cloud syncs, high) + ISE-372 (sync_one persist failures die silently) — both pre-existing platform issues the smoke test exposed. Follow-on sprint candidate: Azure actions (write path, second service principal).
- id: sv6hnwj
  title: AWS Actions
  description: |-
    AWS write path — follow-on to AWS Integration (sjyt01k), the actions ADR 0058 §4 deferred. Planned with Steve 2026-07-30: second IAM identity on the existing System.write_credential_ref Grant-write flow (GitHub ADR 0051 §7 precedent, no credential_spec change); catalogue v1 = EC2 lifecycle (reboot/start/stop) + reboot_db_instance + set_resource_tag (singular — renamed in-build to the set_label/set_host_tag shape, Resource Groups Tagging API), K8s-parity tiering (reboot/start/tag T1, stop/RDS-reboot T2; no IAM actions — ADR 0060 §4); tag write joins the ADR 0043 fix-at-source map; executor ctx.config gains system.config so regions resolve on the write path. Pane-of-glass slice: connector-generic propose-action panel on System detail — first UI caller of POST /proposed-changes. Tasks ISE-373 → {ISE-374, ISE-375}, ISE-374 → ISE-376.

    RELEASED to main 2026-07-30 (PRs #348-#351, main 105ca3d, NO migration), all 4 tasks Done; staging smoke by Steve caught one UI fix (dropdown clipped inside the panel — withinPortal); staging reset to main; feature branches deleted. ADR 0060.
- id: sh8mf3h
  title: Azure Actions
  description: |-
    Azure write path — follow-on to Azure Integration (s0d5f5q), mirroring the AWS Actions pattern (sv6hnwj, ADR 0060). Planned with Steve 2026-07-30: second service principal on the existing System.write_credential_ref Grant-write flow (no credential_spec change); catalogue v1 = restart_vm/start_vm T1, restart_app_service T1 (covers Function Apps, same Microsoft.Web/sites type), set_resource_tag T1 (ARM Tags API merge, joins the ADR 0043 fix-at-source map); deallocate_vm T2, restart_pg_flexible_server T2; Azure SQL out of v1 (no ARM restart op — failover deferred); no RBAC/identity actions (T3). ADR 0061 citing 0060. Azure-specific plumbing: ARM long-running-operation poll helper in ArmClient (202 + Azure-AsyncOperation). UI comes free via the connector-generic ActionsPanel (ISE-376). Tasks ISE-377 (foundation+ADR) → {ISE-378 VM+App Service lifecycle, ISE-379 PG restart+tags}.

    RELEASED to main 2026-07-30 (PRs #352–#354, main e9e01a9, NO migration, zero new deps, no frontend change), ISE-377..379 all Done; staging reset to main; feature branches deleted. Suite 1606→1626. Noted for later: MySQL flexible servers are discovered but have no restart action (same ARM /restart API as PG — the one catalogue inconsistency); Azure SQL failover, VMSS discovery, App Service slot swap/scale remain unscoped. Live write-path smoke still needs a write SP granted on the subscription (ADR 0061 §1 custom role).
- id: s39ax46
  title: Cloudflare Integration
  description: |-
    Cloudflare integration — unlike AWS/Azure, read AND write in ONE sprint (write phase added after the read release). READ (planned 2026-07-30): one instance per account; account-owned read-only api_token + account_id; native REST v4 over httpx (CloudflareClient — MCP servers rejected as OAuth-user-flow shaped). Discovery: zones (new type zone), Tunnels (new type tunnel), LBs (pools as attributes), Workers/Pages → workload; keys cloudflare:{account_id}:{resource_id}; DNS evidence-only. Detect: polled alert history, 24h window IS the presence contract. Evidence: DNS, firewall events (GraphQL), zone analytics, audit log, tunnel connections. Surface: cloudflare-summary card + zone/tunnel display. ADR 0062; migration 0074. Tasks ISE-381→382→{383,384,385}.

    READ RELEASED to main 2026-07-31 (PRs #356-#360, main 00a5cf0), all 5 Done; account-owned-token verify fallback fixed in review (ADR 0062 §2); live smoke completed by Steve 2026-07-31, no defects.

    WRITE (planned 2026-07-31): second write-capable account token on the Grant-write flow (ADR 0060/0061 pattern — needed ZERO platform changes); catalogue = update_dns_record T2 (existing records only), set_ip_access_rule T2 (one-target-one-rule, derived ip/ip6/ip_range family), set_security_level T2 (incl. Under Attack), purge_cache_urls T1 / purge_cache_everything T2 (split ops — tier is per-op), set_pool_enabled T2; NO freeform WAF editing, NO tunnel actions, NO DNS create/delete. Writes synchronous — no LRO helper. UI free via ActionsPanel. ADR 0065. Tasks ISE-394 → {ISE-395, ISE-396}.

    WRITE RELEASED to main 2026-07-31 (PRs #361-#363, main adade43, NO migration/deps/frontend change), ISE-394..396 all Done; write-token smoke clean (Steve); staging reset to main; feature branches deleted. SPRINT COMPLETE — all 8 tasks Done, ADRs 0062+0065, migration 0074. Remaining follow-on candidate: CNAME/A routes-to edge harvest (unscheduled).
- id: setdxf2
  title: EntraID Integration
  description: |-
    New EntraID (Microsoft Entra ID) integration — the governance flagship (roadmap deferred it until the approval machinery was proven on lower-stakes systems; AWS/Azure/Cloudflare done). Planned with Steve 2026-07-31: BOTH read-only connector AND write path in one sprint (unlike the AWS/Azure two-sprint split). connector_type entraid, GraphClient over httpx (ArmClient pattern, scope graph.microsoft.com/.default, nextLink pagination, Cloudflare-style 429 retry, zero new deps) in shared connectors/msgraph.py (M365 reuses it, module-level only); read SP + second write SP on the Grant-write flow. Discovery: users, security groups, service principals, CA policies → four new entity types user/identity-group/application/policy (migration 0075; NOT the taken tag-derived `group` type), native keys entra:{tenant_id}:{object_id}, no membership edges v1. Signals: Identity Protection riskyUsers (P2) as a stateful presence contract, kind=identity-protection; riskDetections are evidence not alerts. Evidence: 7 queries (sign-ins, directory audit, risk detections, user detail incl. MFA state, group members, CA policy detail, app credential expiry). Actions: six ActionSpecs, ALL T3 per ADR 0017; lowercase-GUID targets schema-enforced; structural self-escalation guard (entra_group_roles ∪ new entra_protected_group_ids deny set + transitiveMemberOf check, fail closed) — ISE never modifies the groups its own RBAC derives from; forbidden-permission invariant for both SPs; truthful completion. Surface: entraid-summary tenant card + estate types/icons. ADRs 0063 (connector) + 0064 (actions). Tasks ISE-387..393, stacked branches.

    RELEASED to main 2026-07-31 (PRs #364-#370 merged in order, main fa73375, migration 0075), all 7 tasks Done; live smoke by Steve on staging (SPs registered, sync + full T3 round-trip) passed clean; staging reset to main; feature branches deleted. Build gotcha recorded: ENTITY_TYPES changes redden the OpenAPI-snapshot check on their OWN branch (the entities filter pattern embeds the type list) — regenerate the snapshot on the migration branch, not only at the stack top. Follow-on candidates: UPN↔email cross-key harvest onto other integrations' actors; CA-policy freeform editing (deliberate omission, needs ADR amendment); servicePrincipal risk detections (Workload Identities licence).
- id: s10ybrs
  title: M365 Integration
  description: |-
    New Microsoft 365 integration — the last system on the ISE integration roadmap, read-only (Status Page shape: empty action catalogue, no write SP — service health has nothing to act on). Planned with Steve 2026-07-31.

    EntraID relationship: code/concept reuse yes, dependency NO — M365 works standalone if EntraID is never configured. GraphClient shared at module level (ISE-387 amended: connectors/msgraph.py, not inside entraid.py); dedicated M365 read SP (own consent/revocation), same tenant_id/client_id/client_secret credential shape; if both configured, joins are opportunistic via cross_keys, never required.

    Estate (A+B): (A) /admin/serviceAnnouncement/healthOverviews → ~25-30 M365 services as existing third-party entities (ISE-355 precedent, NO migration), keys m365:{tenant_id}:{service_id}. (B) Licensing = subscribedSkus as System-card data + deterministic Obs detectors (pool ≥90% consumed, SKU warning/suspended) — NOT entities. Non-goals (ADR 0066, with revisit triggers): SharePoint sites/Teams entities, Intune devices; tenant is the System card, not an entity.

    Signals: Service Health issues as Alerts, STATEFUL presence contract on isResolved (riskyUsers pattern, not the Cloudflare 24h window); classification+status → canonical ladder. Message Center = pull-only evidence, deliberately not a signal source. Evidence: service_health_issue (incl. post-incident report), message_center, license_detail. Surface: m365-summary card (open-issue counts, license utilisation bars). Permissions: ServiceHealth.Read.All + Organization.Read.All — verify live at build time. ADR 0066; NO migration; zero new deps.

    Tasks ISE-399 (foundation+ADR) → ISE-400 (discovery) → {ISE-401 signals+license obs, ISE-402 evidence+card+live smoke}. Prereq for smoke: Steve registers the M365 read SP, admin-consented.
- id: sfv5yw0
  title: Bugs and Tweaks
  description: This sprint is a collection of small bugs, issues and improvements that have been identified.
- id: sp3en5k
  title: Website Setup
  description: |-
    Create a website to maintain information and documentation for ISE — public site at ise.cool (separate ise-website repo).

    Planned with Steve 2026-07-31: static markdown-first site, Astro + Starlight, deployed to Cloudflare Workers static assets (personal Cloudflare account) via GitHub Actions — main → production plus PR preview deployments; Cloudflare's built-in git integration deliberately not used. Branding matches the app design system (Compass brand blues #1772a8/#4aace0, Inter), dark mode default with light/dark toggle; copy technical & direct for expert operators, grounded in the app repo's briefs, documenting only released capability.

    PHASE 1 — SETUP, COMPLETE 2026-07-31: ISE-403..410 all Done (PRs #1–#8, repo bootstrapped from empty same day). Site LIVE at https://ise.cool + www over TLS: landing, docs skeleton with search, branded 404, dark-default ISE theme, OG cards, deploy pipeline + PR previews. Two gotchas recorded: an interactive `gh secret set` via the Claude ! prefix stores an EMPTY value (use --body); and with custom domains configured, `preview_urls: true` is required or version uploads print no preview URL.

    PHASE 2 — INTEGRATION DOCS, COMPLETE 2026-07-31: ISE-411..418 all Done (PRs #9–#16 + #17 preview fix). One full operator page per integration (DataDog, Kubernetes, AWS, Azure, Cloudflare, Entra ID, M365, Webhooks) — capabilities incl. deliberate absences, setup with the read/write credential split, worked examples; fact-checked against connector source + ADRs. NOTE: the zone edge-caches HTML, so freshly-deployed pages can serve stale for a while — purge or add a cache rule (unscheduled follow-up).

    PHASE 3 — REMAINING PAGES + NEW SECTIONS, planned 2026-07-31: ISE-423..437. Fills the ten remaining stubs (getting-started introduction/installation/upgrading; concepts core-loop/signals-and-incidents/estate/actions-and-approvals/playbooks; security roles/audit) and adds a new `Using ISE` sidebar group of five operator-surface pages — Dashboards, Assist, Events, Tags, Proposals. ISE-433 owns creating the sidebar group and blocks ISE-434..437; all others independent. Each task names its grounding ADRs and says what to cross-link rather than duplicate.

    Still with Steve: enable Web Analytics on the ise.cool zone (dashboard, automatic injection).
- id: s7qg63g
  title: MS Teams Integration
  description: |-
    MS Teams as a NOTIFICATION CHANNEL — ISE pushes incident/alert notifications out to Teams; the platform's first outbound notification layer (survey confirmed none existed — no notifier abstraction, no event bus). Built as a small generic channels layer with Teams as the first kind. Planned with Steve 2026-07-31.

    Delivery mechanism: Power Automate Workflows webhook URL per channel (classic O365 incoming-webhook connectors are retired) — POST an Adaptive Card to the URL; full Azure Bot and Graph channel-send rejected (Graph won't send channel messages with application permissions). The URL is the secret → envelope-encrypted credential store (first non-connector consumer), keyed notification-channel:{id} — by ID not name, so a rename cannot orphan the secret; write-only, never returned by any endpoint.

    Model: NotificationChannel (kind=msteams, credential_ref, enabled, min_severity + per-event toggles — rule fields live ON the channel, no separate rules table v1) + NotificationDelivery (pending row written in the SAME transaction as the triggering change, post-commit enqueue + Beat sweep for stragglers — the dispatch_approved_changes reliability pattern; retries ride the sweep cadence, bounded attempts, failures visible in the UI). Payload is an emit-time SNAPSHOT: delivery never re-reads the incident, so a later change cannot skew what was announced.

    Events v1 (Steve): incident opened (incl. reactivations), escalated, resolved — including both apply_status_change bypass paths (AI auto-resolve in ai/verify.py, silence-cascade in severity_api.py) — action awaiting approval, and integration broken (edge-triggered on the sync-health transition, with a recovery notice on the way back). Anti-flap guard on incident_opened only; escalations and resolutions are always news. dismissed/closed deliberately silent. Dispatch interval 0 switches the whole layer off.

    Surface: Settings → Notifications tab — channel CRUD, per-channel test send, recent-deliveries log (a silently-failing channel must be visible in the pane of glass). ADR 0067; migrations 0076 (tables) + 0077 (adds the `test` delivery event type).

    BUILT 2026-07-31 — ISE-419..422 all in Review, stacked PRs #375-#378 (all checks green), merged to staging and DEPLOYED GREEN: migration head 0077, both tables present, all 4 endpoints live, both Celery tasks registered, Beat sweep ticking every 60s (dispatched: 0). Backend ruff/mypy clean; frontend 80 files / 449 tests pass, build green.

    Build gotchas: Mantine toast text is UNASSERTABLE in frontend tests (renderWithProviders doesn't mount the Notifications renderer — spy on notifications.show instead); `npm run build` caught a test-stub type error that tsc --noEmit would have missed; integration tests sharing a per-module Postgres need unique channel names per test.

    AWAITING: Steve's live smoke — mint a Power Automate Workflow in Teams (channel ⋯ → Workflows → "Post to a channel when a webhook request is received"), paste the URL into a new channel in Settings → Notifications, then verify test send → a real incident open/resolve card pair → the deep link back into ISE. Then release #375 → #378 in order.
- id: s5pft6a
  title: FreshService Integration
  description: New FreshService integration. Opened 2026-07-31; scope to be planned with Steve.
assignee: steve
priority: medium
project_status: active
---
ISE (Infrastructure State Engine) is an internal platform that gives infrastructure operators a **single pane of glass** over the systems that run the organisation: it connects to them, pulls their state, detects issues, proposes (and — within strict limits — applies) fixes, and provides one governed place to make changes to sensitive core systems.

Sprints 1-7 defined initial MVP Roadmap, additional Sprints to follow.
 

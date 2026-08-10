---
id: 01KX671DATY39VW6GWK3M2T3DN
created: 2026-07-10T14:31:22.714867Z
updated: 2026-08-10T15:29:17.434852Z
type: project
title: ISE
identifier: ISE
next_task_number: 637
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
  description: |-
    A collection of small bugs, issues and improvements identified while using the app. Planned, built and RELEASED with Steve 2026-08-01.

    THE THROUGH-LINE: per-integration configuration moves off global nav screens and the main Settings page, onto the page of the integration that owns it. The three registers (Repos, Status Pages, Documents) become cards on SystemDetailPage; Teams stops being a Settings tab and becomes an integration in its own right.

    RELEASED to main 2026-08-01 (PRs #392-#399, main 0ea5211, ADRs 0070 + 0071, migrations 0082 + 0083), all 8 tasks Done, main CI green, staging reset to main, feature branches deleted.

    - ISE-397: Reset collected data also clears Events, Playbooks and the whole tag pool. The pool was the interesting one — only entity_tag/finding_tag cascade with their parents, so tags on the KEPT registers held the pool open, which is why the tag cloud still showed status-page tags after a reset.
    - ISE-452: Overview moves to head the Integrations nav section; Recent activity removed; subtitle becomes "Installed Integrations." Consequence: the Integrations header now always renders, because Overview is deliberately ungated.
    - ISE-456/457/458: the Repos, Status Pages and Document registers become per-integration cards. Standalone pages, routes and nav entries deleted; detail-page back-links retarget to the owning integration.
    - ISE-455 (ADR 0070, migration 0082): documents become instance-owned. uq_document_url becomes uq_document_system_url; the operator picks the integration and the connector VALIDATES the choice rather than searching for one. Two Confluence integrations are two accounts, not two views of one wiki.
    - ISE-459 (ADR 0071, migration 0083): Microsoft Teams becomes a real integration — msteams connector on the StatusPageConnector shape, new `notifications` capability, notification_channel.system_id, Settings → Notifications tab deleted. Its health_check is the real gain: a rotated-out bot secret was invisible until a delivery failed.
    - ISE-460: four tests that passed in the morning and failed in the afternoon (fixtures pinned to a fixed date while the code read the wall clock). Pre-existing on main, found during this sprint, and it BLOCKED the release because `backend` is a required check.

    LESSONS WORTH KEEPING: (1) a migration's data path is invisible to zero-to-head tests — 0083 minted a System with an invalid `health` value and broke the staging deploy while the suite reported 2039 passing. (2) Eight PRs all editing nav.ts means one conflict-resolve cycle each, and the markers cut through object literals so only `npm run build` catches a bad resolution. (3) Re-running a stale PR check does NOT pick up a fix that has since landed on main — the branch must have main merged into it.
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
    MS Teams as a NOTIFICATION CHANNEL — ISE's first outbound notification layer (survey confirmed none existed: no notifier abstraction, no event bus). A small generic channels layer with Teams as the first kind. Planned and built with Steve 2026-07-31.

    The LAYER is the lasting output and it is destination-agnostic: NotificationChannel + NotificationDelivery, routing rules ON the channel (min_severity + event toggles, no rules table), a pending delivery row written in the SAME transaction as the triggering change with post-commit enqueue + Beat sweep for stragglers (the dispatch_approved_changes reliability shape), bounded retries, an anti-flap guard on incident_opened only, and an emit-time payload SNAPSHOT so delivery never re-reads the incident. Five emit points: incident opened (incl. reactivations), escalated, resolved — including BOTH apply_status_change bypass paths (AI auto-resolve in ai/verify.py, silence-cascade in severity_api.py) — action awaiting approval, and integration broken (edge-triggered on the sync-health transition, with a recovery notice). dismissed/closed deliberately silent. Surface: Settings → Notifications with per-channel test send and a recent-deliveries log, because a silently-failing channel must be visible in the pane of glass. ADR 0067; migrations 0076 + 0077.

    DELIVERY MECHANISM REJECTED BEFORE RELEASE. The original poster used a Power Automate Workflows webhook URL. Steve rejected it outright: a Workflow runs under its OWNER'S authenticated connection and stops silently when their password or MFA changes — disqualifying for the mechanism that reports failure — and it is now a STANDING RULE that Power Automate is never used anywhere in ISE. The msteams kind was therefore removed rather than kept alongside, inside the same unreleased stack, so it never reached main. Successor sprint: Teams Bot Notifications (s8rg5n9).

    RELEASED to main 2026-07-31 as part of the combined ten-PR stack (#375-#378 layer, then #379-#384 bot), main c143e29, main CI green, staging reset to main, feature branches deleted. ISE-419..422 all Done.

    Build gotchas recorded: Mantine toast text is UNASSERTABLE in frontend tests (renderWithProviders does not mount the Notifications renderer — spy on notifications.show instead); `npm run build` caught a test-stub type error that tsc --noEmit would have missed; integration tests sharing a per-module Postgres need unique channel names per test.
- id: s8rg5n9
  title: Teams Bot Notifications
  description: |-
    Teams notifications delivered by an ISE-OWNED BOT, posting to CHATS. Successor to the MS Teams Integration sprint (s7qg63g) after its Power Automate delivery mechanism was rejected. Planned and built with Steve 2026-07-31.

    WHY A BOT — three findings, each verified against Microsoft docs directly:
    1. POWER AUTOMATE REJECTED: a Workflow runs under its owner's authenticated connection and dies silently on a password/MFA change. Now a standing rule for all of ISE.
    2. GRAPH APP-ONLY CANNOT SEND TEAMS MESSAGES AT ALL — chat and channel both list Application = Teamwork.Migrate.All, higher = "Not available". Migration mode only.
    3. RSC CANNOT SEND TO A CHAT — the chat RSC table has no send permission; `ChatMessage.Send.Chat` DOES NOT EXIST despite secondary sources claiming it. `ChannelMessage.Send.Group` exists for CHANNELS, but Steve rejected channels on product grounds: nobody watches them.

    SCOPE CHOSEN (Steve): "minimal + lifecycle" PLUS group chats. Outbound only — no inbound endpoint, so no card buttons and no conversational bot; both are the obvious follow-on and would need Teams→ISE identity mapping plus RBAC enforcement (ADR 0017/0049 territory) in their own sprint.

    WHAT SHIPPED: single-tenant bot client (client credentials; Microsoft stopped allowing NEW multi-tenant bots after 31 July 2025, so the tenant-scoped token endpoint is the default and the legacy shared endpoint is opt-in). Destination resolution — a person by email (UPN first, falling back to `mail`, because they diverge in real tenants) and group chats by id OR pasted chat link (the id appears nowhere in the Teams UI but "Copy link" contains it). CARD LIFECYCLE, decided with Steve: an edit is SILENT in Teams and a new post leaves the old card stale, so do BOTH — opened posts; escalated edits the live card so it steps aside THEN posts a fresh one that actually pings; resolved edits in place. Assignee routing (notify whoever owns the incident, with an optional fallback). @mentions on high/critical group-chat cards only, matched via the Bot Connector roster on EMAIL. Teams app package + build script in clients/teams-app.

    ADR 0069 (0068 was reserved by Freshservice — gap left deliberately); migrations 0078/0079/0080.

    BOT IDENTITY IS ENTERED IN THE APP, not deployment config — Steve's correction mid-build, and the right one: every other credential in ISE is entered in the app, so env vars would have made configuring it a CI change and rotating it a redeploy. All four values (app id, secret, tenant id, catalogue app id) live as ONE credential under the well-known name `teams-bot`, the shape the Azure connector already uses. ADR 0069 §2 RECORDS the reversal rather than quietly rewriting it.

    RELEASED to main 2026-07-31 (PRs #379-#384, released together with the layer PRs #375-#378 in one ten-PR train, main c143e29, main CI green), ISE-446..451 all Done; live smoke by Steve passed; staging reset to main; feature branches deleted.

    LIVE SETUP GOTCHAS, in the order Steve hit them: (1) AADSTS7000215 = pasted the Secret ID instead of the Secret Value — the Value shows once, the ID stays visible. (2) Install 403 exposed a REAL BUG: installation was fatal when it is only a convenience; an app added by hand needs no install permission at all, so it is now best-effort and the SEND is the source of truth. (3) The app must be uploaded to the org catalogue AND the Teams client restarted — it caches hard. (4) Availability (Users and groups) is NOT the same as installed; the fix was adding the app manually in the client. (5) The bot app id and the CATALOGUE app id are different values and confusing them gives a 404 that reads like a permissions error.

    FOLLOW-ON CANDIDATES: inbound endpoint → card buttons (Acknowledge/Resolve from Teams, needs an identity-mapping ADR); a conversational bot is deliberately NOT wanted (ADR 0055 chose Claude/MCP for investigation).
- id: s5pft6a
  title: FreshService Integration
  description: |-
    New Freshservice (ITSM) integration — TWO-WAY, read and write in one sprint (the Cloudflare/EntraID shape). Planned and built with Steve 2026-07-31.

    WHY IT IS DIFFERENT: every integration so far reads MACHINE telemetry. Freshservice is the first source of HUMAN-REPORTED symptoms — when SSO breaks, five people raise tickets before any monitor fires. NO CMDB/asset sync; tickets only.

    PRODUCT-VISION TENSION, RESOLVED: product-vision.md says "Not a general ITSM". That non-goal STANDS — ISE does not become a ticket queue; it reads the desk as a detection source and writes exactly one additive artefact into a queue Freshservice still owns.

    DECISIONS (Steve): scope = config-driven allow-list on System.config (default Incident-only — the "I need a mouse" cut); detectors = BURST + SAME-ISSUE CLUSTER only (single-urgent-ticket and repeat-reopen explicitly declined); AI gated behind a cheap deterministic pre-filter; incident button IN this sprint.

    ARCHITECTURE: (1) Ticket signals are OBSERVATIONS not Alerts — Freshservice has no detection layer to defer to, so a single ticket raises nothing and the signal is in the population. (2) Raw tickets reuse the EVENTS LAYER (ensure_managed_source + store_event, ADR 0051 §4) — no new table; FTS, Events screen, search_events, investigation auto-context and retention all free. (3) Detectors compute over ONE live API read and never query webhook_event, so recovery falls out of the window sliding and source keys carry no count or timestamp — no state machine. (4) obs_detection_enabled must stay FALSE or the Obs Loop's absence-means-recovery silently recovers everything the sweep writes. (5) Signals are ENTITY-LESS; what that costs (context suppression, fine merge candidates) is named in the ADR rather than discovered later. (6) Feedback loop cut by an unconditional ise-generated tag, excluded at ingest, with an explicit test.

    THE AI GATE IS GROUP-BASED, NOT SIMILARITY-BASED — the one design that changed in build. Gating on "suggestive but inconclusive word overlap" filters out the exact case a model exists for: "cannot log in" and "SSO is broken" share NO vocabulary. So the model compares deterministic GROUPS (one representative each, cap 12) and cost scales with the number of distinct problems, not ticket volume. A test caught it before it shipped.

    CORRECTIONS TO THE PLAN, both found in build: adding the cluster-tickets AI task type DOES need a migration (extends the ai_model_config CHECK, the 0071 pattern) — migration 0081; and it reddens test_ai_config_api.py::test_seeded_defaults_listed, which enumerates every configurable type. No config row is seeded, so an install that never opens Settings → AI still gets working detectors without the tie-breaker.

    WRITE PATH: create_ticket T1 (additive, off the mutation path — argued against GitHub's T2 PR and DataDog's T0 ack_event). The ise-generated tag and the requester are BOTH enforced by the closed schema rather than trusted to callers: passing `tags` is rejected outright, and the requester comes from config so a proposal cannot file a ticket as a named colleague. Adds ActionResult.external_ref {kind,id,url,label} so created artefacts render as links — GitHub's PR URLs become clickable for free; the href is scheme-checked because connector responses are untrusted content.

    ALSO IN THE SPRINT: ISE-438 fixed a VERIFIED pre-existing bug — obs_loop.py never spread system.config into ConnectorContext, so M365's documented license_threshold_percent override had never worked on the scheduled loop. Confirmed by running the new regression test against the unfixed code. Plus two stale claims corrected in the connectors brief (M365 said "Deferred" though it shipped; "the deferred five stay deferred" had outlived all five).

    BUILT 2026-07-31 — ISE-438..444 all in Review, stacked PRs #385-#391, every PR CI-green. Merged to staging and DEPLOYED GREEN: migration head 0081, CHECK constraint carries cluster-tickets, connector registered (capabilities observations/evidence/actions, create_ticket:T1, three evidence queries), Beat sweep dispatching and the worker executing it cleanly. Full backend suite 2024 on the combined state; frontend 466 across 82 files. ADR 0068; zero new deps.

    AWAITING: Steve's live smoke — register the integration with a read API key on a VIEW-ONLY agent and a second key on a SEPARATE agent for ticket creation (separate agent so ISE-raised tickets are attributable in Freshservice's own audit and write access is revoked by deactivating one agent). Confirm tickets land on the Events screen, provoke a burst and confirm an incident opens, then raise a ticket from that incident and confirm it appears with the ise-generated tag and is NOT re-ingested as a signal. Optionally set a model for cluster-tickets in Settings → AI; leaving it unset runs deterministic-only by design. Then release #385 → #391 in order.
- id: s7j0986
  title: Estate Inputs
  description: |-
    Review how the estate view is built — what data goes in, and how it is deduplicated. Opened 2026-08-02; the review turned into a re-architecture of what the estate IS. Design agreed with Steve 2026-08-02 and recorded in the ISE Canon ("The three layers of the estate"); nothing built yet.

    REVIEW FINDINGS (live prod, 2026-08-02). 4,717 entities and multi_source = 0 — not one entity is known by more than one integration, so the tier-1 dedup path has never fired in production. Only 182 entities appear in any graph; all 267 edges are part-of; zero annotations, zero proposals ever raised; 54 of 77 signals carry no entity at all; 73 of 246 hosts are named by a raw instance id or UUID. Cause: of 13 integrations only datadog/entraid/freshservice/m365/statuspage are enabled — AWS, Azure and all three Kubernetes systems are deliberately off during testing — so DataDog's cross-keys point at native keys that do not exist, and the only other entity sources (EntraID, M365) emit no cross-keys at all. The reconcile code is sound; nothing feeds it.

    THE DESIGN. The estate stops being a flat resource inventory and becomes three layers: Business Service → Application → Resource. Resources are DISCOVERED (an integration owns and retires them); Applications and Business Services are ASSERTED (no API owns their existence). That single line decides how each layer is maintained and where rot can enter.

    Key decisions:
    - Each integration declares what it is a SOURCE OF RECORD for. DataDog is a source of record for nothing — it holds Monitors and Alerts, and neither is a thing in the estate — and neither is Freshservice. Their identifiers become aliases on entities other sources own.
    - An alert against something no source claims still opens an incident, flagged UNKNOWN ASSET, but mints no placeholder entity; it re-links once the source is integrated. The gap list becomes the integration backlog.
    - A Kubernetes workload is a Resource — workloads map many-to-one onto Applications, so promoting them would still need an Application concept above to group them.
    - Applications ARE entities: existence authored via a confirmed proposal, membership derived from tags, each storing its own predicate so a tag rename is an edit rather than a fork that orphans incident history. Never retired by discovery.
    - Two independent ENVIRONMENT dimensions — infrastructure (sandbox/staging/production, a Resource property, inherited downward by containment) and application (dev/test/demo/prod, part of the Application's identity). Neither is inferred from the other; a Demo instance on production infrastructure is correct.
    - Three structural TAG ROLES (Application / Platform / Environment) bound to dictionary keys by explicit selection — aliasing alone cannot serve an estate that uses `platform` for one role and `project` for something else. One env tag at source, its dimension resolved by its sibling; canonical values are dimension-scoped so prod = production keeps aliasing in both (re-tagging the estate to fix prod/production is an endless project). Compliance therefore rests on "every Resource carries exactly one of app or project".
    - Entity-type collisions resolved: application → app-registration; service splits (Kubernetes Service = Resource, DataDog APM Service = an observation of an Application); third-party retires, because external-ness is an attribute, not a type. "Service" is always fully qualified.
    - Applications display as app.env stored as two fields; Resources are named by their source of record, with display scope drawn from the containment graph.

    TASKS ISE-462..476, dependency-ordered: 462 (ADR 0073) → 463 entity types + 464 tag roles → {465 environments, 466 Applications-as-entities → 467 Applications screen + 468 Business Services}; 469 source-of-record → {470 unknown assets, 471 resource naming}; plus 472 dimension-scoped vocabularies, 473 compliance, 474 unknown-key proposals, 475 integration-level default tags, 476 per-repo tag editing.

    SEQUENCING RISK: ISE-469 must ship WITH ISE-470. DataDog is currently the only enabled entity source in prod, so demoting it without the unknown-asset surface would empty the estate rather than make its gaps visible.

    ALSO FOUND (tagging audit, 2026-08-02): tags reach ISE three ways and the third does not exist. Status Pages is the template — the only register whose tags flow onto an entity. Documents are fine. Repos are partial (shared tags at registration only; PUT /api/v1/repos/{repo_id} exists but nothing in the frontend calls it). Freshservice has nothing at all — no register, tickets stream in as signals inheriting arbitrary Freshservice tags — and needs integration-level default tags, which no integration has.

    SIZE NOTE: 15 tasks is a large sprint. ISE-472..476 are the natural second half if it needs splitting; the first ten deliver the model and its screens.
- id: skxht3g
  title: Functional testing and improvements
  description: This sprint will focus on testing the full feature set provided by ISE and spawn tasks to fix bugs or issues and implement improvements.
- id: shk7zaj
  title: Integration Decoupling
  description: 'Option A — finish the in-process squeeze so a new connector touches the registry line and nothing else: generic summary capability, ActionSpec-declared tag writeback, connector-declared sweep cadence, generated frontend entity-type lists.'
- id: s1mg25q
  title: Integration Packs I
  description: 'Option B part 1 — read-only integrations as versioned declarative packs (no core release to add one): ADR + pack specification, upload/validation/management screen, interpreter core, entities and alerts from a pack.'
- id: syte7bx
  title: Integration Packs II
  description: Option B part 2 — evidence from a pack, dry-run preview, pack update/remove lifecycle + State-toggle conformance, and a GitLab reference pack built purely from the spec as the acceptance proof.
- id: scb3vol
  title: AI Capability Review and Update
  description: Review the capabilities of the AI to surface information to the user and help resolve incidents. Improve and enhance capabilities.
- id: s4ncy73
  title: Voice Escalation & On-Call
  description: ADR 0079/0080 — voice calls over PSTN via ACS as the attention rung above Teams cards, driven by an on-call rota with an acknowledgement loop. ISE-545..549.
- id: sesjg7z
  title: Servers Integration
  description: 'Windows/Linux server fleet via agentless Ansible (ansible-runner in the worker, ADR 0084): register-first inventory with multi-source coverage reconciliation, identity facts sync, evidence on demand, three-op T2 act catalogue with check-mode previews.'
- id: syjypmr
  title: Threshold Specs
  description: 'Connector-declared tunable thresholds: threshold_specs() sibling to ADR 0085''s sweep_specs(), generic config surface/UI, migrate M365/Freshservice/Kubernetes hard-coded trip points, and the first multi-rung ladder — EntraID app-registration credential expiry (90/60/30/expired → low/medium/high/critical).'
- id: sp337by
  title: MCP Surface Gaps
  description: Close the gaps between the MCP design brief (ADR 0055) and the registered tool surface, found while writing the ISE Test Plan 2026-08-06.
- id: snk16ew
  title: Assist
  description: 'Assist = read-only estate Q&A: read all ISE information, write nothing, execute all read-only integration functions (Role Matrix memo, to become an ADR). ISE-591..604: answer capability (estate query v2, EntraID expiry attributes, evidence catalogue extension, prompt refresh, question-bank acceptance), Role Matrix ADR + parity registry, role gate drops (ask→viewer, status/merge→responder), MCP gated-write verification, UI (thread titles, search+pagination, message affordances, Ask-Assist entry points), and BreakGlass completion (ISE-591/592, ADR 0089).'
- id: sgyvvx3
  title: Platform Self-Observability
  description: 'ISE observing its own machinery, born from the 2026-08-06/07 sync-queue backlog: System Status screen + shared collector (ISE-607), task expiry + queue/staleness warnings (ISE-605), connector timeout hardening (ISE-606).'
- id: srhh7w7
  title: Multiple Dashboards
  description: 'Generalise ADR 0053''s single implicit wallboard into named boards: board entity + M2M service membership with per-board order, per-board wallboard tokens (existing TV URLs migrate to a "Main" board), and one-TV rotation across boards. Same tile/rule/latch model — not a widget system.'
- id: sw5yz4n
  title: Reports
  description: 'Scheduled and on-demand PDF reports over the estate: deterministic entity-query specs (AttributeFilter), two A4 templates (portrait/landscape, Jinja2 HTML), calendar-cadence scheduler, S3-compatible artifact storage (in-chart MinIO default), AI-assisted query authoring. ADR 0093.'
- id: s1rgnyx
  title: Playbook Improvements
  description: 'Make playbooks findable and usable in practice. Raised 2026-08-09 from a real attempt to use `reboot_server` via a playbook: the AI has no playbook tool at all, a manually-raised incident can never match one, no playbook matched and nothing said why, and the host could not be resolved by its short name.'
assignee: steve
priority: medium
project_status: active
---
ISE (Infrastructure State Engine) is an internal platform that gives infrastructure operators a **single pane of glass** over the systems that run the organisation: it connects to them, pulls their state, detects issues, proposes (and — within strict limits — applies) fixes, and provides one governed place to make changes to sensitive core systems.

Sprints 1-7 defined initial MVP Roadmap, additional Sprints to follow.
 

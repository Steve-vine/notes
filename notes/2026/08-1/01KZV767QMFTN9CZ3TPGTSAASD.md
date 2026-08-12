---
id: 01KZV767QMFTN9CZ3TPGTSAASD
created: 2026-08-12T14:49:27.540773Z
updated: 2026-08-12T16:53:12.147842Z
type: project
title: RedVektor
identifier: RED
next_task_number: 219
sprints:
- id: s6nhj1v
  title: Phase 1 — Foundation
  description: Repo + CI scaffold, FastAPI backend with config/logging/telemetry/health, data model with tenant scoping, JWT auth, frontend shell with httpOnly cookie auth, Celery + Valkey + scheduled tasks, scanner dispatcher + first scanner (subfinder), Helm chart deployable end-to-end on minikube. Project & Target CRUD + frontend UI. Closed with Brief 008b.
- id: s5d7bqn
  title: Phase 2 — Scanner Framework
  description: 'Modular scanner framework: I/O contract (env-vars, NDJSON-on-stdout), dispatcher → K8s Job → ingest. Multiple scanners (subfinder, httpx), scan engine YAML config loader, basic DAG execution.'
- id: sv5cbvq
  title: Phase 3 — Workflow Framework
  description: Per-Engine parameter schema + /engines endpoint. Workflow + WorkflowStep data model + CRUD API. WorkflowRun execution. Workflows UI on project page. Workflow schedule (Celery beat). Asset-query Selector.
- id: sz0gev3
  title: Phase 4 — Vulnerability Scanning
  description: 'Vulnerability scanning end-to-end: nuclei + nmap/naabu scanners, finding storage with fingerprint-based dedup, severity + SLA deadline calculation, finding status lifecycle, ownership assignment.'
- id: ssxh43d
  title: Phase 5 — Engine Plugin Foundations
  description: 'Architectural shift: engines stop being code-time registrations and become declarative plugins. Versioned NDJSON event spec, SDK packages, Engine/EngineVersion CRD model, engine controller, I/O declarations replacing step types, conformance CLI, asset-query ported as reference implementation.'
- id: syc8wmf
  title: Phase 6 — Engine Refactor
  description: 'Port the four remaining engines (cloudflare, subfinder, httpx, nuclei) onto the M5 plugin contract. End of milestone: legacy registration code path deleted, shim removed.'
- id: s0ht2jk
  title: Phase 7 — New Engines
  description: 'Build new engines against the stable plugin contract: naabu, tlsx, katana, nmap. End of M7 = recon coverage complete enough to replace reNgine.'
- id: set2ygr
  title: Phase 6.5 — Engine Spec/CRD v2
  description: 'Finalise the engine contract into a self-service v2 — spec + CRD a third-party developer can build against with zero app-code changes. Engine-declared credentials, CR-carried UI hints, CRD v2 schema/migration. NOTE: sits after Phase 7 in Linear''s milestone sort order; preserved as-is.'
- id: sv10nf2
  title: Phase 8 - Resolve asset DB conflicts
  description: 'Resolve foundational asset data-model conflicts per ADR-037: declared Scope store, anchor/endpoint asset graph, append-only audit trail, point-in-time report snapshots, ingest reconciliation, engine-output-contract revision.'
- id: sewyev2
  title: Phase 9 - End-to-end engine test and bug fix
  description: Systematic end-to-end testing of all engines against parameter combinations on dev, capturing each defect as an issue and fixing it. Resumed after the M8 asset-DB work landed.
- id: sp88phy
  title: M10 - End-to-end engine test and enhancements
  description: Re-run end-to-end tests of each engine and identify opportunities for enhancement or residual bugs.
- id: s3ry03w
  title: M11 - Version-based vulnerability detection (CVE correlation)
  description: Passive, version-based vulnerability detection — detected software version → known CVEs. In-cluster CVE/CPE mirror with no external egress; a version-cve external-job engine. Phased P1–P5.
- id: skesb93
  title: M12 · Review and update UI
  description: UI/UX review pass. Seeded with standing frontend papercuts (login flash, mobile layout, command-palette data, engine deprecation badge).
- id: s9dry54
  title: M13 · Dashboards, Reporting & Export
  description: Executive / asset / per-project / rollup dashboards, PDF reports, CSV/JSON export, trend charts.
- id: sarkyv8
  title: M14 · Inbound Scanner Integrations
  description: 'Third-party finding sources: Trivy, Wazuh, Prowler, Kubescape, Gitleaks, Semgrep, Dependency-Track, custom-script UI/scanners, and a generic HMAC ingest endpoint.'
- id: s6h3c3a
  title: M15 · Outbound Notifications & Ticketing
  description: 'Outbound integrations: webhooks, Slack, Teams, email, Automox, SIEM feed.'
- id: s1yya2y
  title: M16 · Asset Management UX
  description: Asset inventory, history/changelog, tagging, manual add, suppression, grouping, list perf at scale. Anchored by the P0 tags + provenance work (DEV-244/245).
- id: svxm3pw
  title: M17 · Triage & Findings Intelligence
  description: Bulk triage, verification re-scan, suppression-by-rule, compliance tagging, finding correlation, AI-assisted triage, attack-path, change feed, keyboard shortcuts.
- id: sm1kr5j
  title: M18 · Scanner Coverage & Scan Controls
  description: New scanners (amass, screenshots, WAF, S3 misconfig) plus scan-execution controls (parallelism, throttling, scope include/exclude).
- id: s1jtpzf
  title: M19 · Projects, RBAC & SSO
  description: 'Project-level access/config/SLA, SSO/SAML, API keys, company switcher. NOTE: re-scope against ADR-035 (asset/finding are company-scoped; project is a lens).'
- id: sb1sfzd
  title: M20 · Auth & Security Hardening
  description: Refresh-token revocation, RS256, password reset, email verification, MFA/TOTP, audit log, rate-limiting, webhook signing/API keys, breached-password check.
- id: sw9wx5e
  title: M21 · Platform, CI/CD & Release
  description: Product version scheme, branch protection, OIDC→ECR, CI image build/push, Helm 3→4, secretKeyRef refactor, kubectl image, Beat HA, Flower, result transport, scanner versioning, local-dev setup.
- id: svz96jc
  title: M22 · Observability
  description: OTEL instrumentation (SQLAlchemy/Celery), K8s watch API for Job completion, NATS event-stream spike, concurrency-profile tuning from telemetry.
- id: s1hm0kb
  title: Backlog
  description: Ongoing small tech-debt, chores, follow-ups and new features not yet tied to a feature milestone.
assignee: steve
imported_from: null
priority: medium
project_status: active
---
RedVektor application.
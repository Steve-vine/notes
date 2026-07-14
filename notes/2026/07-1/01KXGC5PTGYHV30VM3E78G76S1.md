---
id: 01KXGC5PTGYHV30VM3E78G76S1
created: 2026-07-14T13:13:30.704987Z
updated: 2026-07-14T17:54:42.955572678Z
type: project
title: Compass
assignee: steve
priority: medium
project_status: active
identifier: COM
sprints:
- id: s8ayp7w
  title: 0 - Architectural standards, mission brief and features
  description: Decide on the architecture use, the design and layout, the database schema, the core features of the app and the governance model used to develop the application.
- id: s7hkfxa
  title: 1 - Walking skeleton
  description: 'Foundation / walking skeleton (ADR 0014, Phase 1). Proves the architecture end to end with no user-facing GRC features yet: auth + roles, Company + default company, base schema (UUID/audit/soft-delete), API scaffolding, frontend app shell, deployment + observability, and CI. See decisions/0014 and brief/feature-set-and-phasing.md.'
- id: sz3kacg
  title: '2 - MVP: Know where we stand'
  description: |-
    ✅ **Complete (2026-06-16)** — all briefs and follow-ups shipped and merged; the MVP is live at https://compass.citops.net.

    Lean MVP / assessment heartbeat (ADR 0014, Phase 2 — the first release). Browse imported, read-only domains/policies/Core controls; per-company assessments (applicability, status, maturity, evidence-as-links); gaps; a compliance/maturity dashboard by domain; full API; the maturity rubric. Framework crosswalk (M3), risk (M4) and content authoring (M5) are deliberately excluded. See decisions/0014.
- id: s9wnr7r
  title: 3 - Report against frameworks
  description: |-
    ✅ **Complete (2026-06-17)** — all six briefs merged and shipped to the k3s cluster (image `49d5feb`, https://compass.citops.net): DEV-431 framework models + import (#27), DEV-432 crosswalk API (#28), DEV-433 crosswalk UI (#29), DEV-434 coverage reporting (#30), DEV-435 SoA export (#31), DEV-436 evidence attachments (#32).

    Phase 3 (ADR 0014) — "report against frameworks". Framework + requirement entities; the control↔requirement **crosswalk** (import + UI); derived **framework-coverage** reporting; **ISO 27001 Statement of Applicability** export; and **evidence attachments** upgraded from links to real files (object storage). Builds on the M2 assessment heartbeat — assessments roll up through the crosswalk to external frameworks. Risk (M4) and content authoring (M5) remain out of scope. Refs: ADR 0010 (control framework model), 0011, 0013, 0015, 0017; brief/feature-set-and-phasing.md (Phase 3).
- id: sq2tcpq
  title: 4 - Manage risk
  description: |-
    ✅ **Complete** — shipped to https://compass.citops.net (image `93580f2`, 2026-06-17). All six briefs (DEV-448…453) merged: risk scoring scales + appetite rubric, risk register model + API, treatment plans, register & detail UI, dashboard heatmap, evidence attachments.

    Phase 4 (ADR 0014) — "manage risk". The GRC 'Risk' pillar: a per-company **risk register** (inherent vs residual on a 5×5 likelihood×impact matrix), **treatment plans** (mitigate/accept/transfer/avoid), **risk appetite** thresholds, a **risk dashboard/heatmap**, and **evidence attachments** on risks. Risks link to the Core controls that mitigate them and to gaps — letting Compass prioritise work by risk, not just raw control gaps (the "prioritise work" half of the vision). Builds on M2 assessments/gaps and the M3 control library. Content authoring (M5) is out of scope. Refs: ADR 0012 (risk module), 0018 (risk rubric/appetite), 0015 (data model), 0017 (IA); brief/feature-set-and-phasing.md (Phase 4), brief/rubrics.md.
- id: sd5fyv6
  title: 5 - Author the living playbook
  description: |-
    ✅ **Complete (2026-06-17)** — all eight briefs shipped and merged to `main`: DEV-456 content versioned model + API (#39), DEV-457 authoring UI (#40), DEV-459 decision records backend (#41), DEV-460 notifications & reminders backend (#42), DEV-458 re-author imported policies (#43), DEV-463 decision records UI (#44), DEV-464 notifications bell (#45), DEV-466 linked-decision surfacing (#46). The decision-records and notifications briefs were each split into backend + UI PRs for reviewability.

    Phase 5 (ADR 0014) — "author the living playbook". Turns Compass from a tracker pointing at imported PDFs into the authoritative, living source of truth: full in-app **Markdown authoring** with a draft → published lifecycle and diffable **version history**; **re-authoring** of the M2-imported `policies/` PDFs as native content (PDF retained as a provenance attachment, seed-from-PDF); content cross-linked to its domain, Core controls and implementing procedures; **decision records** captured in-app (the 20 repo ADRs migrated in via the deploy import Job) and linked to controls/risks/content; and **notifications/reminders** (content/assessment review due, treatment overdue) on the Celery Beat scheduler with a top-bar bell. Delivers the full "living content" vision (success criterion #6). Refs: ADR 0013 (content model), 0006 (Celery/Beat), 0001 (ADRs), 0015 (data model), 0017 (IA); brief/feature-set-and-phasing.md (Phase 5).
- id: sd2bf6k
  title: 6 - Global search
  description: |-
    ✅ **Complete (2026-06-18)** — both briefs merged to `main`: DEV-467 search API (#47) and DEV-468 search UI (#48). Not yet deployed.

    **First phase beyond the original ADR 0014 roadmap** (recorded in ADR 0021). Realises the global search ADR 0017's IA always intended — the top-bar box that shipped disabled since the M1 shell. A single `/api/v1/search` endpoint (Postgres full-text, `websearch_to_tsquery`/`ts_rank`, no new infra) searches across the shared library (domains, Core controls, content, decision records, frameworks + requirements) and the selected company's risks/gaps, returning typed, ranked, deep-linkable results; the top-bar box + a `/search` results page (grouped by type) consume it. ADR 0021 also vendored into the decision-records seed (record 21). Refs: ADR 0021 (search approach + Phase 6), 0017 (IA), 0005 (Postgres).
- id: s9nk96f
  title: '7 - UI refresh: modern, dynamic, light/dark'
  description: |-
    ✅ **Complete (2026-06-19)** — all four briefs merged + deployed (live image `f678024`, helm rev 24): DEV-469 theme + light/dark (#49, +accent retune #50), DEV-470 shell & nav (#51), DEV-471 components & tables (#52), DEV-472 dynamic feel (#53).

    **New phase beyond ADR 0014** (design direction recorded in ADR 0022). Modernised the UI within Mantine 8 (ADR 0003): a custom **blue-teal/cerulean** theme (`primaryShade` light7/dark4) with a persisted **Light/Dark/System** toggle (no-flash); a branded shell (compass mark + wordmark, sidebar grouped Overview/Library/Company/Admin, mobile burger); shared `StatusPill` + theme-level Table/Card defaults + a gradient dashboard header; and dynamic feel — toast notifications (`@mantine/notifications`, central via a `MutationCache`), loading skeletons, friendly empty states, and a motion-safe card hover-lift. Risk pages keep their bespoke band colours (possible follow-up). Refs: ADR 0022, 0017, 0003.
- id: sr1y7pm
  title: 8 - CIS Controls framework
  description: |-
    ✅ **Complete** — both briefs shipped, deployed and verified live (image `2ce6cc4`, 2026-06-19). DEV-474 (CIS Controls v8 framework, 153 safeguards) + DEV-475 (Core↔CIS crosswalk, 130 mappings / 129 of 153 safeguards). Live: 2 frameworks, 208 total mappings (78 ISO + 130 CIS); CIS coverage derives from the existing M2 assessments. No UI changes, no migrations, no new ADR.

    ---

    **New phase beyond ADR 0014** — content under the existing framework/crosswalk model (ADR 0010), no new architectural decision. Adds **CIS Controls v8** to the framework library: the **153 Safeguards** as requirements, plus a conservative Core↔CIS **crosswalk** starter. Because M3 built a generic framework system, this is almost entirely vendored seed data (two CSVs + two one-line importer entries) — the **Frameworks page, framework-coverage reporting, crosswalk UI, and global search pick it up with no UI changes**, and the deploy's post-upgrade import Job seeds it. (The ISO 27001 SoA export stays ISO-specific.)

    Two briefs: (1) **CIS Controls v8 framework + 153 safeguards** (vendor `data/frameworks/cis-controls-v8.csv` + `_FRAMEWORKS` entry); (2) **Core↔CIS starter crosswalk** (vendor `data/mappings/cis-controls-v8.csv` + `_MAPPINGS` entry). Conservative high-confidence mappings only — bulk curation is a governance concern done via the UI (ADR 0010). Note: safeguard titles are the public CIS names (no copyrighted descriptive text, mirroring the ISO import); worth sanity-checking against the official CIS source. Refs: ADR 0010 (control framework model), 0017.
- id: sywxatr
  title: 9 - SOC 2 Framework
  description: |-
    ✅ **Complete** — both briefs shipped, deployed and verified live (image `8149c7e`, 2026-06-19). DEV-485 (SOC 2 framework, 61 criteria across all 5 categories) + DEV-486 (Core↔SOC 2 crosswalk, 41 mappings / 38 of 61 criteria). Live: 3 frameworks (SOC 2 reqs=61, CIS=153, ISO=93), 249 total mappings (78 ISO + 130 CIS + 41 SOC 2); SOC 2 coverage derives from the existing M2 assessments (Default company met=2/partial=1/unmet=1/not_assessed=57/unmapped=23). No UI changes, no migrations, no new ADR.

    ---

    **New phase beyond ADR 0014** — content under the existing framework/crosswalk model (ADR 0010), no new architectural decision. Adds **SOC 2** to the framework library: the **AICPA Trust Services Criteria (TSC, 2017 w/ 2022 points of focus)** as requirements, plus a conservative Core↔SOC 2 **crosswalk** starter. Mirrors M8 (CIS): almost entirely vendored seed data (two CSVs + two one-line importer entries) — the **Frameworks page, framework-coverage reporting, crosswalk UI, and global search pick it up with no UI changes**, and the deploy's post-upgrade import Job seeds it. (The ISO 27001 SoA export stays ISO-specific.)

    **Scope: all five Trust Services Categories** — Security/Common Criteria (CC1–CC9), Availability (A1), Confidentiality (C1), Processing Integrity (PI1), Privacy (P1–P8) — 61 criteria. Requirement unit = the individual criterion (e.g. CC6.1, A1.2, P4.3).

    Two briefs: (1) **SOC 2 (Trust Services Criteria) framework + criteria** (vendor `data/frameworks/soc-2-tsc-2017.csv` + `_FRAMEWORKS` entry); (2) **Core↔SOC 2 starter crosswalk** (vendor `data/mappings/soc-2-tsc-2017.csv` + `_MAPPINGS` entry). Conservative high-confidence mappings only — bulk curation is a governance concern done via the UI (ADR 0010). Note: criterion titles are short descriptors/paraphrases, NOT the verbatim AICPA TSC text (copyrighted), mirroring the ISO/CIS imports; worth sanity-checking against the official AICPA TSC. The CC criteria map well to the existing Core controls; Privacy (P-series) maps mainly to the PDH (Personal Data Handling) controls and is the sparsest. Refs: ADR 0010 (control framework model), 0017.
- id: s7xztsf
  title: 10 - NIST CSF Framework
  description: |-
    ✅ **Complete** — both briefs shipped, deployed and verified live (image `d68f15f`, 2026-06-19). DEV-487 (NIST CSF 2.0 framework, 106 subcategories across all 6 Functions) + DEV-488 (Core↔CSF crosswalk, 65 mappings / 64 of 106 subcategories). Live: **4 frameworks** (CSF reqs=106, CIS=153, ISO=93, SOC 2=61), **314 total mappings** (78 ISO + 130 CIS + 41 SOC 2 + 65 CSF); CSF coverage derives from the existing M2 assessments (Default company met=2/partial=1/not_assessed=103/unmapped=42). No UI changes, no migrations, no new ADR.

    ---

    **New phase beyond ADR 0014** — content under the existing framework/crosswalk model (ADR 0010), no new architectural decision. Adds the **NIST Cybersecurity Framework 2.0** (Feb 2024) to the framework library: the **Subcategories** as requirements, plus a conservative Core↔CSF **crosswalk** starter. Mirrors M8 (CIS) / M9 (SOC 2): almost entirely vendored seed data (two CSVs + two one-line importer entries) — the **Frameworks page, framework-coverage reporting, crosswalk UI, and global search pick it up with no UI changes**, and the deploy's post-upgrade import Job seeds it. (The ISO 27001 SoA export stays ISO-specific.)

    **Scope: CSF 2.0, all six Functions** — Govern (GV), Identify (ID), Protect (PR), Detect (DE), Respond (RS), Recover (RC) — 22 categories, 106 subcategories. Requirement unit = the individual subcategory (e.g. `GV.OC-01`, `ID.AM-01`, `PR.AA-03`, `DE.CM-01`).

    Two briefs: (1) **NIST CSF 2.0 framework + subcategories** (vendor `data/frameworks/nist-csf-2-0.csv` + `_FRAMEWORKS` entry); (2) **Core↔NIST CSF starter crosswalk** (vendor `data/mappings/nist-csf-2-0.csv` + `_MAPPINGS` entry). Conservative high-confidence mappings only — bulk curation is a governance concern done via the UI (ADR 0010). Note: subcategory titles are short descriptors/paraphrases (NIST CSF is US-Gov public domain, but kept concise and consistent with the ISO/CIS/SOC 2 imports); worth sanity-checking against the official NIST CSF 2.0. The Protect/Detect/Respond/Recover subcategories map well to the existing Core controls; the Govern (GV) function maps mainly to the INS/RIM/VEM governance controls and the OV/strategy subcategories are the sparsest. Refs: ADR 0010 (control framework model), 0017.
- id: s3j9yhs
  title: 11 - PCI DSS Framework
  description: |-
    ✅ **Complete** — both briefs shipped, deployed and verified live (image `d81732c`, 2026-06-19). DEV-490 (PCI DSS v4.0.1 framework, 63 sub-requirements) + DEV-491 (Core↔PCI crosswalk, 42 mappings / 42 of 63 sub-requirements). Live: **5 frameworks** (CIS=153, ISO=93, NIST CSF=106, PCI=63, SOC 2=61), **356 total mappings** (78 ISO + 130 CIS + 41 SOC 2 + 65 CSF + 42 PCI); PCI coverage derives from the existing M2 assessments (Default company met=1/partial=1/not_assessed=61/unmapped=21). No UI changes, no migrations, no new ADR.

    ---

    **New phase beyond ADR 0014** — content under the existing framework/crosswalk model (ADR 0010), no new architectural decision. Adds **PCI DSS v4.0.1** to the framework library: the **sub-requirements** as requirements, plus a conservative Core↔PCI **crosswalk** starter. Mirrors M8 (CIS) / M9 (SOC 2) / M10 (NIST CSF): almost entirely vendored seed data (two CSVs + two one-line importer entries) — the **Frameworks page, framework-coverage reporting, crosswalk UI, and global search pick it up with no UI changes**, and the deploy's post-upgrade import Job seeds it. (The ISO 27001 SoA export stays ISO-specific.)

    **Scope: PCI DSS v4.0.1, sub-requirement (X.Y) granularity** — all 12 principal requirements, 63 sub-requirements. Requirement unit = the individual sub-requirement (e.g. `1.2`, `3.4`, `8.3`, `10.2`).

    Two briefs: (1) **PCI DSS v4.0.1 framework + sub-requirements** (vendor `data/frameworks/pci-dss-4-0-1.csv` + `_FRAMEWORKS` entry); (2) **Core↔PCI DSS starter crosswalk** (vendor `data/mappings/pci-dss-4-0-1.csv` + `_MAPPINGS` entry). Conservative high-confidence mappings only — bulk curation is a governance concern done via the UI (ADR 0010). Note: sub-requirement titles are short descriptors/paraphrases, NOT the verbatim PCI SSC text (copyrighted), mirroring the ISO/CIS/SOC 2 imports. PCI is a technical/cardholder-data standard: Req 1/2/5/6/7-8/10/11 map densely to the existing Core controls; Req 9→PES, Req 12→INS; the cardholder-data-environment specifics (Req 3 stored CHD, Req 4 transmission) and PCI program items are the sparsest and left for hand-curation. Refs: ADR 0010 (control framework model), 0017.
- id: spyhsng
  title: 12 - HIPAA Framework
  description: |-
    ✅ **Complete** — both briefs shipped, deployed and verified live (image `64ce53d`, 2026-06-19). DEV-492 (HIPAA Security + Breach Notification framework, 58 requirements) + DEV-493 (Core↔HIPAA crosswalk, 38 mappings / 38 of 58). Live: **6 frameworks** (CIS=153, ISO=93, NIST CSF=106, PCI=63, SOC 2=61, HIPAA=58), **394 total mappings** (78 ISO + 130 CIS + 41 SOC 2 + 65 CSF + 42 PCI + 38 HIPAA); HIPAA coverage derives from the existing M2 assessments (Default company met=2/not_assessed=56/unmapped=20). No UI changes, no migrations, no new ADR.

    ---

    **New phase beyond ADR 0014** — content under the existing framework/crosswalk model (ADR 0010), no new architectural decision. Adds **HIPAA** (Security Rule + Breach Notification Rule, 45 CFR Part 164, 2013 Omnibus) to the framework library: the **standards + implementation specifications** as requirements, plus a conservative Core↔HIPAA **crosswalk** starter. Mirrors M8-M11: almost entirely vendored seed data (two CSVs + two one-line importer entries) — the **Frameworks page, framework-coverage reporting, crosswalk UI, and global search pick it up with no UI changes**, and the deploy's post-upgrade import Job seeds it. (The ISO 27001 SoA export stays ISO-specific.)

    **Scope: Security Rule + Breach Notification Rule** (Privacy Rule deliberately excluded — PHI use/disclosure/patient-rights items map weakly to an infra/security control set, like PCI's cardholder-data specifics). 58 requirements at implementation-specification granularity. 164.308 Administrative (23), 164.310 Physical (10), 164.312 Technical (9), 164.314 Organizational (4), 164.316 Documentation (4); Breach Notification 164.402-414 (8).

    Two briefs: (1) **HIPAA framework + safeguards** (vendor `data/frameworks/hipaa-2013.csv` + `_FRAMEWORKS` entry); (2) **Core↔HIPAA starter crosswalk** (vendor `data/mappings/hipaa-2013.csv` + `_MAPPINGS` entry). Conservative high-confidence mappings only — bulk curation is a governance concern done via the UI (ADR 0010). HIPAA is US-Gov public domain; titles kept as concise descriptors. The Technical/Administrative/Physical safeguards map densely to existing Core controls; the healthcare-specific items (clearinghouse functions, business-associate/group-health-plan specifics, breach-to-HHS/media notification) are the sparsest and left for hand-curation. Refs: ADR 0010 (control framework model), 0017.
- id: s0f74ms
  title: 13 - Cyber Essentials Plus
  description: |-
    ✅ **Complete** — both briefs shipped, deployed and verified live (image `271451d`, 2026-06-19). DEV-494 (Cyber Essentials Plus framework, 31 requirements across the five NCSC themes) + DEV-495 (Core↔CE crosswalk, **31/31 — 100% coverage**). Live: **7 frameworks** (CIS=153, ISO=93, NIST CSF=106, PCI=63, SOC 2=61, HIPAA=58, CE=31), **425 total mappings** (78 ISO + 130 CIS + 41 SOC 2 + 65 CSF + 42 PCI + 38 HIPAA + 31 CE); CE coverage derives from the existing M2 assessments with **zero unmapped requirements**. No UI changes, no migrations, no new ADR.

    ---

    **New phase beyond ADR 0014** — content under the existing framework/crosswalk model (ADR 0010), no new architectural decision. Adds the UK NCSC **Cyber Essentials Plus** scheme: the requirements under the **five technical control themes** as requirements, plus a Core↔CE crosswalk. Mirrors M8-M12: vendored seed data (two CSVs + two one-line importer entries) — the **Frameworks page, framework-coverage reporting, crosswalk UI, and global search pick it up with no UI changes**, seeded by the deploy's post-upgrade import Job. (The ISO 27001 SoA export stays ISO-specific.)

    **Scope: the five Cyber Essentials control themes** — (1) Firewalls, (2) Secure Configuration, (3) Security Update Management, (4) User Access Control, (5) Malware Protection — 31 requirements. ("Plus" = the same technical controls verified by independent hands-on audit rather than self-assessment.) Version is year-based (`2025`) pending confirmation of the current named NCSC/IASME edition.

    Two briefs: (1) **Cyber Essentials framework + requirements** (`data/frameworks/cyber-essentials.csv` + `_FRAMEWORKS` entry); (2) **Core↔Cyber Essentials starter crosswalk** (`data/mappings/cyber-essentials.csv` + `_MAPPINGS` entry). CE is Crown-copyright / OGL; titles are concise descriptors. **Near-complete crosswalk achieved (100%)** — Compass's Core controls are a UK-style infra/security set that aligns 1:1 with CE's five themes (firewalls→NES/DBC/ENE, config→DBC/ACC/CRD, updates→ASM/PAM, access→ACC/CRD, malware→DBC.1/THP). Refs: ADR 0010 (control framework model), 0017.
- id: sxptdhb
  title: 14 - Audit Trail & Activity Log
  description: |-
    ✅ **Complete** — shipped, deployed and verified live (image `ac1167b`, 2026-06-19). DEV-498 (activity_log model + auto-capture + admin API) + DEV-505 (admin Activity page + per-entity history on Risk/Decision). ADR 0023 records the design.

    Live verification: migration 0018 applied, `before_flush` listener registered, **activity_log rows = 0 post-deploy** (the live proof of the actor-gated design — the import Job seeds everything with no actor, so no audit noise), `/api/v1/activity` mounted + admin-gated. Full create→capture path covered by the integration suite (`test_activity.py`). Admins can eyeball it at /activity after any change.

    ---

    **First feature milestone beyond the 7 frameworks.** An append-only audit trail (who-did-what-when) complementing the per-entity revision snapshots — and satisfying controls Compass itself tracks (ISO A.8.15, HIPAA 164.308(a)(1)(ii)(D), PCI Req 10, CIS 8).

    * **Capture**: one SQLAlchemy `before_flush` listener; zero per-endpoint wiring. Actor stamped on the shared request `session.info` by `get_current_user`, so only authenticated user actions are logged (no seed/import noise) — sidesteps the contextvar/threadpool pitfall.
    * **Model**: `activity_log` append-only; no FK on entity_id/company_id (outlives deletion); allowlist of 15 governance tables; admin-only read API.
    * **UI**: admin Activity feed (filter entity/action/company, paginated) + reusable `ActivityHistory` on Risk & Decision detail pages. (Content keeps its version-history tab; controls aren't audited; gaps have no detail page — all still in the admin feed.)
      Refs: ADR 0010, 0023.
- id: s98e9vg
  title: 15 - Reporting & Export
  description: |-
    ✅ **Complete** — shipped, deployed and verified live (image `254173d`, 2026-06-20). DEV-499 (export service) + DEV-506 (Reports page). ADR 0024 records the design.

    Live verification (read-only in-pod — reports are pure SELECT + render): coverage report CSV (93 ISO rows, correct header), coverage PDF (`%PDF`, ~10KB), gap register CSV, risk register PDF — all render against live data; all three endpoints mounted + 401 unauth.

    ---

    **Audit-ready exports for all seven frameworks** (ADR 0024).

    * `/api/v1/reports/coverage` — per-framework coverage report, **reusing** `coverage.py`**'s derivation** so on-screen coverage / SoA / report never diverge. `/reports/gaps` + `/reports/risks` — registers.
    * **CSV + PDF** (ReportLab — pure-Python, no system libs). Generated synchronously + streamed; nothing persisted (no storage-backend dependency). Reads open to any authenticated user.
    * Frontend: Reports page download cards + Framework-detail coverage CSV/PDF shortcuts.

    **Deferred:** the evidence pack (bundling attachment files) — its backend was out of scope per ADR 0024 (revisit with async + storage); not shipped as a broken button. The ISO SoA export (CSV/XLSX) is unchanged.

    Refs: ADR 0010, 0024.
- id: szghwdw
  title: 16 - Remediation & Action Tracking
  description: |-
    Unify remediation into an assignable, due-dated **action view** across gaps, risk treatment plans, and upcoming reviews, with a **"my work / overdue"** lens — delivering the charter's "prioritise work from day one" promise.

    Builds on what exists: gaps and treatment plans already carry owners; the reminders/notifications engine already computes due/overdue items. The missing pieces: **gaps have no due date**, and there's no consolidated, assignable work queue tying gaps + treatment plans + upcoming assessment/content reviews together.

    **May warrant a short ADR/decision** (model a first-class `Action` entity vs a derived aggregation view over existing gaps/treatments/reviews — leaning derived to avoid duplicate state). New phase beyond ADR 0014.

    Two briefs: (1) **Backend — action due dates + unified actions query** (add `due_date` to gaps + migration; an `/actions` endpoint aggregating gaps, treatment plans and upcoming reviews with owner/status/due/overdue; filters: mine / company / overdue); (2) **Frontend — actions work queue + dashboard widget** (Actions page with assignment, due dates, overdue highlighting, mine/all filter; a "my actions / overdue" dashboard widget). Backend brief first.
- id: s29esb7
  title: 17 - User permissions
  description: |-
    Create more granular roles that can be assigned to users within each section.

    Roles should include -

    Admin - Can access every part of the application, without any restrictions

    Assessor - Full access to the 'Company' section (Assessments, Gaps, Actions, Risks, Reports)

    Analyst - Full access to the 'Library' section (Domains, Controls, Content, Frameworks, Decisions)

    Viewer - Readonly access to 'Library' and 'Company' Sections.

    All users get access to the Overview Section ('Dashboard')

    It should be possible to assign more that one role to a user, E.g. Viewer and Assessor - The user would be able to view the Library section and edit the Assessments section.
- id: s114vjm
  title: 18 - Domains and Controls Editing
  description: |-
    Add the ability to edit domains and controls.

    Domains

    * Add, edit and delete domain (Domain Name, Slug, Description).
    * Disable a domain so that it no longer appears - disables all controls within that domain
    * Clicking on a domain should allow you to edit the domain, with the existing policy link and controls list below

    Controls

    * Add, edit and delete control (Control name, Description, Parent domain).
    * Disable a control so that it no longer appears.
    * Clicking on a control in Library should display that control rather than take you to the assessment screen
- id: s7sxqts
  title: 19 - Frameworks
  description: |-
    ✅ **Complete** — shipped, merged and deployed live (image `3fc4269`, helm rev 41, 2026-06-26). DEV-655 backend (#81) + DEV-656 frontend (#82); design in **ADR 0028** (projects #10). DB head now **0022_editable_frameworks**. Verified live: api+frontend on `3fc4269`, all 4 workloads Ready, `/readyz` + `/` 200, migration hook passed.

    ---

    **Frameworks become editable & enrichable.** The milestone's question — "control frameworks have a lot of information missing (e.g. CIS has the title but not the description); how do I get the rest in?" — answered by turning the read-only framework library into governed, in-app-editable data (the framework analogue of M18's editable domains/controls).

    The descriptions were empty *on purpose*: the standards' clause text is copyrighted, so the M8–M13 seeds shipped only public control **names**. ADR 0028's resolution:

    * **CRUD + reversible disable + guarded delete** for frameworks and requirements, gated `require_library_write` (analyst/admin, ADR 0026). Disable = derived visibility (a requirement is hidden if it *or* its framework is disabled); delete is a guarded soft-delete (409 "in use — disable instead"). Disabled items drop out of coverage, crosswalk pick-lists and search.
    * **Description enrichment** — the headline: inline editing **plus a bulk "Import descriptions" CSV upload**, so an org loads the clause text it's *licensed* for. Compass still ships **no copyrighted text**.
    * **Vendored open-licence descriptions** — NIST CSF 2.0 (106), HIPAA (58, 45 CFR Part 164), Cyber Essentials (31, NCSC OGL) now ship with their clause text; ISO/CIS/SOC 2/PCI stay description-less and are enriched in-app.
    * **Importer → insert-missing-only + blank-only description backfill**, so redeploys never clobber edits and existing deployments pick up the vendored text. Migration **0022** adds the two `active|disabled` status enums. `frameworks`/`framework_requirements` now audited.

    No new architectural decision beyond ADR 0028; crosswalk mechanism (M3) untouched. Refs: ADR 0028, 0027 (the M18 pattern this mirrors), 0010, 0023, 0026, 0017.
- id: sk4616x
  title: 20 - Decisions
  description: |-
    ✅ **Complete (2026-06-27)** — shipped, merged and deployed live (image `ade8118`, helm rev 42, https://compass.citops.net). DEV-670 backend (#83) + DEV-671 frontend (#85); design in **ADR 0029** (projects #11). DB head now **0023_decision_fuzzy_declined**. Verified live: 4 workloads on `ade8118` Ready, migration hook passed (`deployed`), `/readyz` + `/` 200.

    Two enhancements to the M5 in-app decision records:

    * **Typo-tolerant fuzzy search** — the deferred ADR 0021 follow-up, now realised. Enables Postgres **pg_trgm** (migration 0023); `GET /decisions?q=` ranks by `word_similarity` over number/title/body and composes with the status/link filters; a debounced search box lands on the Decisions page. The M6 **global search** also gains a trigram supplement on short name fields (titles/names), OR-ed with FTS and ranked so exact/FTS hits stay above fuzzy-only. **Identifier-like queries** (digits/dots, e.g. `A.5.1`) deliberately skip the fuzzy path and stay precise via FTS + ref-ILIKE — measured `word_similarity('A.5.1', '…5.1…')` = 0.667, identical to real typos, so no threshold separates them.
    * `Declined` **status** — a terminal decision status that **stays visible** (listed by default, filterable, searchable), alongside `superseded`. Gray `StatusPill`, no enforced transition.

    No new architectural decision beyond ADR 0029; the supersede mechanism, decision links and import seed are untouched. Migration 0023 also adds the `declined` enum value (add-only). Follow-on chore (#86) pinned `worker/beat enabled:true` in `values-k3s.yaml` so future rolls need no `--set` flags.

    ---

    **Original ask:** I feel like decisions could become difficult to navigate eventually, it would benefit from a fuzzy search feature to surface previous decisions.

    Secondly it should have a Declined status.
- id: s28w1cp
  title: 21 - Content
  description: |-
    ✅ **Complete (2026-06-28)** — all six briefs shipped and merged to `main`; design in **ADR 0030** (projects #12). DB head now **0025_content_templates**.

    Backend: DEV-678 sectioned content + editable content types (#87), DEV-679 Word templates + placeholder extraction (#93), DEV-680 merge & render pipeline (#91). Frontend: DEV-681 tabbed page + sectioned editor + Mappings (#94), DEV-682 Templates tab (#90), DEV-683 Generate PDF single + bulk (#92).

    **Content now works as templated, placeholder-named sections rendered into Word templates as PDFs.** ContentItem's single Markdown body became ordered `content_sections` (the body is a derived rollup, so M6 search + versioning are unchanged; versions gain `sections_json`). The hardcoded `ContentType` enum became an editable `content_types` table (CRUD + disable + guarded delete, the M18/M19 pattern), each mapping to an uploaded `.docx` template (`content_templates`, bytes in object storage, `[placeholder]` tokens auto-extracted). The Content page gained **Templates** and **Mappings** tabs alongside **Content**. Generating a PDF merges a content item's like-named sections into its type's template (pure-Python `python-docx`) and renders to PDF on the **Celery worker** via LibreOffice headless; PDFs are cached in object storage (content+template-revision keyed); single opens in a new tab, bulk multi-select returns a zip. Migrations **0024** (types/sections) + **0025** (templates).

    **ADR-0008 note:** ADR 0030 §6 wanted LibreOffice in a worker-only image, but ADR 0008 mandates one shared image, so `libreoffice-writer` ships in every workload (the API never invokes it — conversion runs only on the worker via Celery). Recorded as an amendment in ADR 0030 §6; the worker now mounts the storage PVC. Markdown→docx fidelity is intentionally modest (headings/lists/emphasis). Refs: ADR 0030, 0013, 0027/0028, 0026, 0023, 0006, 0008.

    ---

    Change the way that content works to use Word documents as templates. On the content page, create new new tabs, 'Templates' and 'Mappings' and rename the current view as 'Content'.

    Templates:

    * User can upload Word documents as templates, standard work documents with placeholders in such as '[main-policy]' or '[acc-controls]'
    * Can also delete and rename existing templates

    Mappings:

    * Users can map content types (policy, standard, process etc.) To uploaded templates.
    * Users can also create, edit and delete existing content types.

    Content:

    * Users create new content as they do today but in edit mode they can create new sections, each section has a placeholder name such as '[main-policy]'.
    * Sections appear one below each other are all editable (in edit mode) and can be individually deleted.
    * In read mode, there is an option to generate a PDF that merges the content sections into the corresponding Word template and opens it in a new tab. From there, the user can print or download it.

    Main Content List Screen

    * each content has a tickbox on the left, the user can select multiple contents and generate PDF's in bulk, which are downloaded.
- id: sg31rps
  title: 22 - Content Reviews
  description: Create the capability to schedule content reviews.
- id: ssdk92z
  title: 23 - Content Library
  description: |-
    ✅ **Complete (2026-07-03)** — all ten M23 issues shipped, merged, deployed and verified live (image `main-20260703-2134` / `83b85a1`, helm rev 65, https://compass.citops.net: `/readyz` + `/` 200, all 4 workloads Ready, no new migrations). **Post-verification fix:** DEV-803 xlsx/pptx PDF export failed on the worker (image shipped only `libreoffice-writer` — no Calc/Impress import filters; homeless-user dconf/fontconfig noise masked the error) — fixed in PR #140, live on image `main-20260704-0702`, helm rev 66.

    List page: DEV-794 rewording (#130), DEV-793 name search (#131), DEV-787 Kind filter (#132), DEV-788 multi-select — per-kind Generate/Export/Download PDFs + bulk Delete (#134). Detail page: DEV-786 Delete content (#133), DEV-789 Export PDF rename (#135), DEV-790 preview pane removed (#136), DEV-791 consistent click-to-preview incl. Office-via-LibreOffice (#137), DEV-792 Publish-button fix via server-computed `has_unpublished_changes` (#138). Templates: DEV-785 display-name de-dup (#139). New API surface: `DELETE /content/{slug}` (soft-delete), `kind`/`q` list filters, `?download=true` on the file endpoint, bulk PDF pipeline dispatching per kind on the worker. No new ADR (fixes/refinements under ADR 0034/0035).

    ---

    Four content kinds treated uniformly when browsing but each behaving appropriately when used (DEV-753 / ADR 0034 follow-on):

    * **Uploaded** — standard documents (Word, Excel, PDF) stored on the platform (local/EFS/S3 storage backend)
    * **Templated** — Markdown stored locally, PDF generated from a Word template (today's authoring, renamed)
    * **Linked** — a URL to a remote document / web page
    * **Managed** — an M365/SharePoint document: open/edit in Word/Excel Online, PDF via Graph ?format=pdf with the Compass review record injected

    Plus a Domain filter and a Kind column on the Content list. Governance (domain, reviewers, cadence, review records) is uniform across all kinds.
- id: sc5mwga
  title: 24 - Migration to new dev server
  description: A new dev server has been created called g5, to replace the EC2 instance. This is a local server on my internal network.
- id: sevqqwb
  title: Backlog
  description: Ongoing small tech-debt, chores, follow-ups and new features not yet tied to a feature milestone.
next_task_number: 125
---
Compass is a tool for tracking infrastructure and cyber security governance.  
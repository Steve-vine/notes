---
id: 01M7BJC2DNFZZESKBDPX2H3W0B
created: 2026-11-13T23:02:36.725801Z
updated: 2026-11-13T23:03:07.169175Z
type: memo
title: Compass comparison / Summary and priorities
project: 01KXGC5PTGYHV30VM3E78G76S1
---
Summary of the six competitor comparisons (CISO Assistant, Eramba, SimpleRisk, Hicomply, Vanta, Drata), 2026-11-13: every feature they have that Compass doesn't, de-duplicated, rated for effort and value, and ordered with the most value for the effort first. Detail for each feature is in the individual "Compass comparison / …" memos.

**How to read it**
- **Who has it:** CA = CISO Assistant, Er = Eramba, SR = SimpleRisk, Hi = Hicomply, Va = Vanta, Dr = Drata. More products = a stronger sign customers and auditors expect it.
- **Effort:** S = a task or two, fits in a sprint with other work · M = about one sprint · L = about two sprints · XL = several sprints, or a change that reaches every area.
- **Value:** High / Medium / Low — weighing audit relevance (ISO 27001, SOC 2), how many competitors have it, and how well it fits what Compass already does.
- Order: by value band first; within a band, smaller effort first.

## Ranked list

| # | Feature | Who has it | Effort | Value | Why |
|---|---|---|---|---|---|
| 1 | **Device security checks** — a check that raises a gap when a laptop isn't encrypted, compliant or protected | Va, Dr | S | High | Compass already reads Intune's compliance data; auditors sample laptops |
| 2 | **Management review of risks** — a signed review decision, with high risks reviewed more often than low | SR, Er | S | High | Auditors ask who reviewed each risk and when; small change to the existing register |
| 3 | **ISMS context and objectives** — internal/external issues, interested parties, security objectives | CA, Hi | S–M | High | ISO 27001 clauses 4 and 6.2; company scope (ADR 0151) already covers the rest of clause 4 |
| 4 | **More frameworks** — NCSC CAF, ISO 22301, ISO 27701, NHS DSPT first; look at the Secure Controls Framework for many at once | All 6 | M each (SCF: L, licence to check) | High | Every competitor has far more; NCSC CAF and NHS DSPT matter in the UK |
| 5 | **Ticketing sync and webhooks** — actions, gaps and findings sent to Jira / ServiceNow / Azure DevOps, status flowing back | CA, SR, Hi, Va, Dr | M | High | Five of six have it; puts remediation where engineers work |
| 6 | **AI reads vendors' assurance documents** — SOC 2 reports and DPAs assessed against our criteria, follow-ups drafted | Va, Dr | M | High | Removes the slowest part of vendor reviews; reuses Polaris's document reading from contract and pen-test review |
| 7 | **One compliance checklist per person, with background checks** — training, policy acceptance, background check, device | Va, Dr | M | High | Pulls Attestations, devices and training into one view per employee; background checks aren't recorded today |
| 8 | **HR system as the source of joiners, movers and leavers** | Hi, Va, Dr | M–L | High | Joiner/leaver evidence is an audit staple; "left in HR, still has an account" becomes a check. People was left out of Collection feeds earlier; this would revisit that, as configuration, not code per HR system |
| 9 | **Awareness training with quizzes** — videos, quiz with pass mark, recurring rounds, completion % | Er, Va, Dr | M–L | High | ISO 27001 7.2/7.3 and SOC 2 expect proof; Attestations already does the "read and acknowledge" half |
| 10 | **Your own KPIs, dashboards and report builder** — measures recorded each period, dashboards and reports emailed on a schedule | CA, Er | L | High | ISO 27001 9.1 (measuring the ISMS); today's dashboards are fixed |
| 11 | **AI register** — AI tools, agents and MCP servers in use, owners, data reached, linked to AI impact assessments | Va, Dr | M | Medium–High | Fits ISO 42001 and the AI impact assessments Compass already has |
| 12 | **Custom fields** on records | CA, Er, SR, Va | L | Medium–High | Four of six; lets each company record what it needs without a change to Compass |
| 13 | **Data-quality sweeps** — gaps in our own records (risk with no treatment, control with no owner, expired evidence) | CA | S–M | Medium | Cheap on the existing checks engine; keeps the register audit-ready |
| 14 | **Responsibility (RACI) matrices** | CA | S–M | Medium | ISO 27001 5.3 roles and responsibilities |
| 15 | **Spreadsheet import with column matching** into any area | CA, Er, SR | M | Medium | Speeds bringing a new company onto Compass |
| 16 | **Status rules and notifications you define** — e.g. "overdue review turns amber and emails the owner"; any list emailed on a schedule | Er, CA | M | Medium | Lighter-weight than full automation; covers most of what people want from it |
| 17 | **Vendors watched for breaches** — supplier incidents and material changes raise an alert | Va, Dr | M | Medium | Natural extension of the Security Feed |
| 18 | **Questionnaires and forms for our own people** — self-assessments, intake forms (e.g. "request an exception"), answers can raise risks | CA, Er, SR | M–L | Medium | Reuses the vendor questionnaire machinery inward |
| 19 | **More flexible risk scoring** — matrix size, several impact scales, rules for what a treatment must include | CA, Er, SR, Va | M–L | Medium | Four of six; but touches the register, appetite and every risk report |
| 20 | **Business units within a company** — departments own risks and controls, reports roll up | Er, SR, CA | L | Medium | Three of six, but scoping reaches every area |
| 21 | **Configurable workflows and approvals** — no-code "when X, do Y", any record routed through chosen approvers | CA, Er, SR | XL | Medium | Most of the value comes from 5 and 16 at a fraction of the cost |
| 22 | **Target risk and risk trajectory** — level aimed for, by when, forecast | CA | S | Medium–Low | Small addition to the register |
| 23 | **Platform operations** — activity log streamed to a SIEM, IP allowlist, service accounts, monitoring endpoint | CA | S–M each | Medium–Low | Compass's own security posture; pick individually |
| 24 | **New vendors found automatically** (shadow IT) — e.g. from sign-in app consents | Va | M | Medium–Low | Compass already reads the directory |
| 25 | **Campaigns** — one assessment across many companies, compared side by side | CA | M | Medium–Low | Useful as more companies are governed |
| 26 | **Evidence suggested from mailboxes and file stores** | Hi | L | Medium–Low | Attractive, but privacy questions about reading mailboxes |
| 27 | **Trust Centre analytics** — visits, document interest, questionnaire accuracy; link to Salesforce deals | Dr | S–M | Low–Medium | Small improvement to an existing area |
| 28 | **Risk in money (FAIR / quantification)** | CA, SR | L | Low–Medium | Only pays off if the business wants risk in pounds |
| 29 | **Priority / Kanban board** for actions | CA, Hi | S | Low | Nice to have; Actions and Initiatives already cover the work |
| 30 | **Attacker-technique catalogues** (MITRE ATT&CK, ATLAS, OWASP) and threat modelling | CA | M | Low | Specialist; Compass's own threat catalogue serves risk assessments |
| 31 | **External security ratings for vendors** | CA | M + paid service | Low | Needs a ratings subscription |
| 32 | **Requirement-to-requirement mapping explorer** | CA | M | Low | Compass lines frameworks up through controls already |
| 33 | **System accreditation** (authority to go live, renewal) | CA | M | Low | Little demand in UK practice |
| 34 | **Standards beyond security** (ISO 9001, ISO 14001) | Hi | M each | Low | A change of scope — only if the business wants one combined management system |
| 35 | **Risks visible to one team only** | SR, CA | L | Low | Role-and-company access is enough for now |
| 36 | **Checking infrastructure code before deploy** (compliance as code) | Dr | L | Low | Only where Compass governs teams writing infrastructure code |
| 37 | **Multi-language interface** | CA | XL | Low | Not needed for UK companies |
| — | **DORA register of information and DORA incident reports** | CA (DORA content: Er, Va, Dr) | L | Parked | Waits with DORA/NIS2 |

## Themes worth running as a sprint each
- **ISO 27001 ISMS completeness** — 2 management risk review, 3 ISMS context and objectives, 13 data-quality sweeps, 14 RACI; then 10 KPIs and dashboards. Mostly S–M, all things an auditor checks.
- **Personnel compliance** — 1 device checks, 7 per-person checklist and background checks, 8 HR system, 9 awareness training. Appears in four of the six products.
- **Vendor assurance with AI** — 6 AI reads vendors' documents, 17 breach watch, 24 vendor discovery.
- **Self-service configuration** (bigger platform bet) — 12 custom fields, 15 import, 16 status rules, 18 forms; 21 full workflows only if those prove not to be enough.
- **Reach** — 4 more frameworks and 5 ticketing sync stand on their own and can go in any sprint.

## Source memos
Compass comparison / CISO Assistant · / Eramba · / SimpleRisk · / Hicomply · / Vanta · / Drata
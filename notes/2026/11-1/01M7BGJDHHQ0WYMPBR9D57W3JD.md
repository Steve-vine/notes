---
id: 01M7BGJDHHQ0WYMPBR9D57W3JD
created: 2026-11-13T22:31:07.569388Z
updated: 2026-11-13T22:31:07.569388Z
type: memo
title: Compass comparison / CISO Assistant
project: 01KXGC5PTGYHV30VM3E78G76S1
---
Comparison of CISO Assistant (intuitem, open-source GRC) against Compass, 2026-11-13, to find candidate future features. Based on CISO Assistant's public docs and feature list (not hands-on), each item checked against the Compass codebase.

**Summary:** Compass matches CISO Assistant on most core GRC work. The gaps are in four areas: how risk is measured, which frameworks come built in, KPIs and reporting, and general-purpose tools (automation, configurable approvals, custom forms).

## Missing from Compass

### Risk
1. **Risk in money (quantification).** Each risk gets a likely financial loss, a chart of how bad losses could get, and the return on each control. Compass scores risk on a 5×5 likelihood × impact grid only.
2. **Target risk and risk trajectory.** Each risk records the level aimed for and a date, with a forecast of when treatment gets it there. Compass records inherent and residual only.
3. **Configurable risk matrices.** 3×3, 4×4 or your own scale and labels. Compass's grid is fixed at 5×5.
4. **Attacker-technique catalogues and threat modelling.** Ships with MITRE ATT&CK, MITRE ATLAS (attacks on AI) and the OWASP Top 10, with threat models built on them. Compass's threat catalogue is its own list.

### Frameworks
5. **Many more frameworks, and a mapping explorer.** 200+ against Compass's 12. UK-relevant: NCSC Cyber Assessment Framework, ISO 22301, ISO 27701, NIST 800-53, NIS2, DORA, EU AI Act, Cyber Resilience Act. Two frameworks can be compared requirement by requirement; Compass only lines frameworks up through the controls each requirement maps to.

### Measuring and reporting
6. **Your own KPIs and dashboards.** Define a measure (e.g. "% of staff trained"), record a value each period, calculate measures from other measures, build dashboards from them; Power BI connector. Compass's dashboards are fixed. ISO 27001 clause 9.1 is about measuring the ISMS, so auditors ask for this.
7. **ISMS context and objectives.** Registers of internal and external issues, interested parties and security objectives (ISO 27001 clauses 4 and 6.2). Not in Compass yet.
8. **Data-quality sweeps.** Flags gaps in the governance records: a risk with no treatment, a control with no owner, expired evidence. Compass's checks test the real environment (MFA, dormant accounts), not whether the records are complete.

### Getting work done
9. **No-code automation.** "When X happens, or every Monday, do Y" set up without a code change. Outgoing webhooks; Jira, ServiceNow and n8n connections so remediation flows into ticketing tools.
10. **Configurable sign-off routes.** Any record (assessment, policy, evidence) sent through one or more chosen approvers. Compass's approvals are fixed per area.
11. **Responsibility (RACI) matrices.** Who is Responsible, Accountable, Consulted and Informed for each activity.
12. **Custom forms.** An administrator builds an intake form (e.g. "request a security exception", "new project security review") and publishes it to a group. Compass's forms are fixed.
13. **Campaigns.** The same assessment run across many companies at once, results compared side by side.
14. **System accreditation.** Formal sign-off that a system may go live, tracked to renewal (the US "authority to operate" idea).
15. **Kanban board and priority/effort view.** Controls and actions dragged between status columns; a chart of priority against effort.

### Third parties
16. **External security ratings for vendors.** Outside-in scores (SecurityScorecard, BitSight style) on each vendor.
17. **DORA register of information and DORA incident reports.** Sits with DORA/NIS2, which are parked.

### Platform
18. **Custom fields** on any record, sensitivity labels (TLP classifications), and your own names for things.
19. **28 interface languages.** Compass is English only.
20. **Operations:** activity log streamed to a SIEM (e.g. Sentinel), a monitoring metrics endpoint, IP allowlist, machine-to-machine service accounts, a spreadsheet import wizard with column matching, export/import of one company's data on its own.

## Already in Compass
Audits and evidence, vendor questionnaires and tiering, the privacy register (lawful basis, purpose, retention, international transfers), DPIAs and subject requests, the business impact analysis, incidents with notification deadlines, exceptions, vulnerabilities with security feeds, recurring assurance tasks, initiatives, the Trust Centre, the AI assistant over MCP, single sign-on, personal API tokens, framework levels, notifications and search.

## Suggested starting points
- **KPIs and dashboards (6) plus ISMS context and objectives (7)** — ISO 27001 clauses an auditor will check; both self-contained.
- **More frameworks (5)** — NCSC CAF and ISO 22301 are cheap additions to the existing library.
- **Jira/webhooks (9)** — connects Compass's actions to where engineers already work.
- Risk in money (1) is CISO Assistant's biggest difference, but only pays off if the business wants risk in pounds.

## Sources
- https://github.com/intuitem/ciso-assistant-community
- https://intuitem.com
- https://intuitem.gitbook.io/ciso-assistant/llms.txt
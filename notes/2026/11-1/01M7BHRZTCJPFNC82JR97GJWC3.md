---
id: 01M7BHRZTCJPFNC82JR97GJWC3
created: 2026-11-13T22:52:11.468868Z
updated: 2026-11-13T22:52:11.468868Z
type: memo
title: Compass comparison / Drata
project: 01KXGC5PTGYHV30VM3E78G76S1
---
Comparison of Drata (commercial compliance-automation and trust platform) against Compass, 2026-11-13, to find candidate future features. Based on Drata's website product pages and help-centre search results (not hands-on), each item checked against the Compass codebase. Companion to the CISO Assistant, Eramba, SimpleRisk, Hicomply and Vanta comparisons.

**Summary:** Drata is Vanta's closest competitor and covers much the same ground, so most of its gaps are already on the Vanta list. Two things are new; six more repeat items already on the earlier lists.

## New compared with the earlier lists
1. **Checking infrastructure code before it's deployed ("compliance as code").** Drata scans infrastructure definitions during development and flags control gaps (e.g. an unencrypted bucket) before they reach production. Compass checks what is already running in AWS, Azure and Google Cloud, after the fact.
2. **Trust Centre analytics tied to sales.** Dashboards show Trust Centre visits, access requests, which documents get attention, and how the AI questionnaire answers perform (accuracy, completion). Through Salesforce, the activity is linked to deals and revenue. Compass's Trust Centre records visitor activity, but has no dashboards of this kind and no link to sales.

## Also on an earlier list
- **Device security checks** (Vanta #1) — the Drata Agent checks password manager, disk encryption, OS updates and antivirus daily, or reads them from the MDM.
- **Per-person compliance, training and background checks** (Vanta #2, Eramba #1) — Drata's own training by default; background checks started by the employee through a partner, or uploaded.
- **HR system as the source of people** (Hicomply #1).
- **AI reads vendors' documents and drafts follow-ups** (Vanta #4) — an agent evaluates all of a vendor's documents and questionnaire answers against your criteria in one assessment, flags gaps and drafts targeted follow-up questions to the vendor; humans make the decision.
- **An AI register, with enforcement** (Vanta #6) — a sensor registers each AI agent as it is created (owner, identity, permissions, scope), checks every agent action against plain-language policy, and blocks violations before they run. In limited availability.
- **Linked tickets** (CISO #9) — remediation tasks and linked tickets on failing tests.

## Already in Compass
Continuous tests mapped to controls with pass/fail history (control checks and collected evidence); bringing in evidence from homegrown and on-premises systems (Collection integrations defined on screen, including approved internal addresses); control owners; the auditors' space (Audit Hub ≈ the auditor portal and audit requests); internal risk register; vendor reviews with risk tiers; user access reviews; the Trust Centre; AI questionnaire answering (DDQs); several companies in one place (Drata's "enterprise workspaces"); custom frameworks; an open API and an MCP server.

## Takeaway
- Little new beyond Vanta. **Compliance as code (1)** only pays off where Compass governs teams that write infrastructure code; lower priority. **Trust Centre analytics (2)** is a small, contained improvement to an area Compass already has.
- Drata adds weight to the Vanta shortlist: device checks, the AI register and AI vendor-document review are in both.

## Sources
- https://drata.com/platform
- https://drata.com/products/compliance/monitoring-and-tests
- https://drata.com/products/compliance-automation
- https://drata.com/products/governance/agents
- https://drata.com/products/risk/agentic-tprm-assessment
- https://drata.com/products/assurance/trust-measurement
- https://help.drata.com/en/collections/16397079-personnel-management
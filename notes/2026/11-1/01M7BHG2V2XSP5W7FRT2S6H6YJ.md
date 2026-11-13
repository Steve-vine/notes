---
id: 01M7BHG2V2XSP5W7FRT2S6H6YJ
created: 2026-11-13T22:47:19.650371Z
updated: 2026-11-13T22:47:19.650371Z
type: memo
title: Compass comparison / Hicomply
project: 01KXGC5PTGYHV30VM3E78G76S1
---
Comparison of Hicomply (UK compliance-automation platform) against Compass, 2026-11-13, to find candidate future features. Based on Hicomply's website, which is mostly marketing pages with no public documentation (not hands-on), so thinner than the other comparisons; each item checked against the Compass codebase. Companion to "Compass comparison / CISO Assistant", "Compass comparison / Eramba" and "Compass comparison / SimpleRisk".

**Summary:** Hicomply is aimed at getting to ISO 27001 and SOC 2 certification, and Compass already covers almost all of it. Two things are new compared with the earlier lists, plus a set of extra standards; four more repeat items already on those lists.

## New compared with the earlier lists
1. **The HR system as the source of joiners, movers and leavers.** Hicomply links to about 45 HR systems (Workday, BambooHR, Rippling, SAP SuccessFactors, ADP…) for people data and evidence. Compass learns about people from the directory (Entra and on-prem AD), and joiners and leavers are raised by hand. With the HR system as the trigger, a joiner or leaver request could be raised automatically when HR records a start or leaving date, and "left in HR, still has an account" could show as a failing check.
2. **Evidence suggested from mailboxes and file stores.** Hicomply searches connected mailboxes, SharePoint, OneDrive, Google Drive and Dropbox for documents that look like evidence, suggests which control each one belongs to, and someone accepts, changes or rejects the suggestion; it learns from those decisions. Compass collects evidence from the services it reads (the checks Polaris designs), but doesn't go looking through documents and email for evidence people have already produced.
3. **Standards beyond security.** New territory rather than just more frameworks: ISO 9001 (quality) and ISO 14001 (environment), so one platform can run a combined management system; the **NHS Data Security and Protection Toolkit**, which is UK-specific and required for any organisation handling NHS data; and ISO 27018 (cloud privacy).

## Also on an earlier list
- **ISMS context and scope** (CISO #7) — guided ISO 27001 clause 4.1–4.3 work producing a scope document from templates. Compass already has company scope (ADR 0151); what's missing is the context and interested-parties part.
- **More frameworks** (CISO #5) — NCSC CAF, ISO 27701, CMMC, FedRAMP, CCPA.
- **Ticketing integrations** (CISO #9, SimpleRisk Jira) — incidents and findings go to Jira, Zendesk, Azure DevOps or ServiceNow.
- **Priority board** (CISO #15) — tasks dragged between Low, Medium and High columns.

## Already in Compass
The risk register with treatment plans; policy management with versions, approvals, reminders and acknowledgement; incidents; internal and external audits with corrective actions; the information asset register with classification; recurring compliance tasks with evidence attached; control monitoring; collected evidence from cloud and security tools; the Trust Centre; the privacy register; single sign-on; the AI assistant (Polaris), which covers Hicomply's help assistant and AI risk mapping. Hicomply also sells access to a consultant network and a content library — services, not product features.

## Takeaway
- **Add to the shortlist:** the HR system as the source of joiners and leavers (1) — it closes a real gap in the joiner, mover and leaver evidence auditors look at, and fits Compass's Access Control well.
- **Worth a look:** the NHS Data Security and Protection Toolkit (3), if any company Compass governs handles NHS data — a cheap framework addition.
- **Evidence from mailboxes and file stores (2)** is attractive, but a bigger piece of work, and raises privacy questions about Compass reading mailboxes.

## Sources
- https://www.hicomply.com
- https://www.hicomply.com/platform/isms-scoping
- https://www.hicomply.com/platform/integrations
- https://www.hicomply.com/framework/all-frameworks
- https://www.hicomply.com/platform/hicomply-ai
- https://www.hicomply.com/product/task-management
- https://www.hicomply.com/product/hicomply-privacy
- https://www.hicomply.com/product/information-asset-management
- https://www.hicomply.com/llms.txt
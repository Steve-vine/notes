---
id: 01M7BHRMB6XX08HXV6V0SFTGB0
created: 2026-11-13T22:51:59.718335Z
updated: 2026-11-13T22:51:59.718335Z
type: memo
title: Compass comparison / Vanta
project: 01KXGC5PTGYHV30VM3E78G76S1
---
Comparison of Vanta (commercial compliance-automation and trust platform) against Compass, 2026-11-13, to find candidate future features. Based on Vanta's website product pages (not hands-on), each item checked against the Compass codebase. Companion to the CISO Assistant, Eramba, SimpleRisk and Hicomply comparisons.

**Summary:** Vanta overlaps heavily with Compass (continuous checks, risk, vendors, questionnaires, Trust Centre, audits, an AI agent), but is stronger in two places: the individual employee's compliance (their laptop, training, background check) and third parties and AI as things to discover and watch. Six things are new compared with the earlier lists; five more repeat items already on them.

## New compared with the earlier lists
1. **Device security checks.** An agent on each laptop (or the MDM) checks disk encryption, screen lock, antivirus and a password manager, and the evidence sits in Vanta. Compass already reads devices from Entra and Intune, including whether Intune says each one is compliant, but runs no check on them, so a non-compliant or unencrypted laptop never raises a gap.
2. **One compliance checklist per person, including background checks.** Each employee has onboarding, recurring and offboarding tasks (training, policy acceptance, background check, device) tracked against deadlines, with a dashboard of who is behind. Background checks are run through a partner (Certn) or uploaded. Groups decide who gets which tasks. In Compass these live in separate places (Attestations, access requests), and background checks aren't recorded at all.
3. **New vendors found automatically.** Vanta connects to procurement systems and other sources to find suppliers and AI tools people have started using without a review ("shadow IT"). Compass's vendor register is maintained by hand.
4. **AI reads vendors' assurance documents.** SOC 2 reports, DPAs and questionnaires are read by AI, which pulls out SLAs, data-processing terms and security terms, runs an assessment against your criteria and drafts a remediation plan. Compass records a vendor's certifications by hand; its AI contract review is for our own contracts, not suppliers' assurance documents.
5. **Vendors watched for breaches.** Vendors are monitored for breaches, emerging threats and material changes, with an alert to the team. Compass's Security Feed watches products for vulnerabilities, not suppliers for incidents.
6. **An AI register.** AI tools, agents, models and MCP servers are discovered through connected systems and recorded with owners, use cases and the data each can reach; AI impact assessments run before approval and repeat on a schedule; rules can block unapproved agents or MCP servers. Compass already has AI impact assessments and ISO 42001, but no register of the AI in use.

## Also on an earlier list
- **HR system as the source of people** (Hicomply #1) — personnel kept current from the HR system and identity provider.
- **Security awareness training** (Eramba #1) — Vanta's own training videos inside the platform, or your provider linked in.
- **Task sync with Jira, GitHub and Asana** (CISO #9) — risk treatment actions sent to where teams work.
- **Custom risk scoring dimensions and register columns** (CISO #3, Eramba #4, CISO #18).
- **More frameworks** (CISO #5) — NIS2, DORA, EU AI Act, NIST AI RMF, Essential Eight, CMMC, FedRAMP, CJIS, CPS 234.

## Already in Compass
Continuous control checks and collected evidence; the risk register with inherent and residual scores, treatment and heatmap; a library of threats; access reviews (recertification); the MFA and leaver checks; vendor questionnaires and risk tiers; AI questionnaire answering (DDQs); the Trust Centre; audits with auditor access; customer commitments (from contract review); an AI agent that drafts policies and answers questionnaires (Polaris); custom frameworks; an API and MCP.

## Takeaway
- **Add to the shortlist:** device security checks (1) — cheap, because Compass already reads Intune's compliance flag; the AI register (6) — it fits the ISO 42001 work already in Compass; and AI reading of vendors' SOC 2 reports (4) — it fits Polaris and the vendor assurance profile.
- **A "personnel compliance" theme is forming:** the per-person checklist and background checks (2), the HR system as the source (Hicomply #1) and awareness training (Eramba #1) belong together as one piece of work.

## Sources
- https://www.vanta.com
- https://www.vanta.com/products/personnel-access
- https://www.vanta.com/products/risk
- https://www.vanta.com/products/third-party-risk-management
- https://www.vanta.com/products/ai-governance
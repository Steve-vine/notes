---
id: 01KRNT0ARFJ999SJBD7XWK21CV
created: 2026-05-15T12:32:57.615634544Z
updated: 2026-05-15T14:41:22.922715871Z
type: memo
title: 'Cyber Tabletop Exercise — Feb 2026: Findings & Actions'
imported_from: Obsidian
---
15-05-2026 13:17

Tags: #cyber #incident-response #tabletop #moneypenny


---

# Cyber Tabletop Exercise — Feb 2026: Findings & Actions

Source: *Moneypenny — Incident Response Exercise Report (Protos Networks, Darren Kewley, 11.02.2026, v1.0)*. Findings extracted from the Post Exercise Review (p.14 onwards), including the NIST SP 800-61r3 verdict table and the themed Areas for Improvement.

---

## Govern

### Finding 1 — No formal information security governance framework
- **Action:** Adopt SOC2 framework and work towards accreditation.

### Finding 2 — No dedicated information security risk register
- **Action:** Stand up a dedicated information security risk register alongside the business register. 

### Finding 3 — Weak supply chain security (MarketingAdminUser entry point came from a third-party supplier)
- **Action:** Expand on Vendor Onboarding process and migrate into GRC platform as part of the SOC2 work.

### Finding 4 — Concentration risk on SSO / Microsoft / Azure / Entra
- **Action:** Identify the top 5–10 services where tenancy loss would be catastrophic and define a tenancy-compromise contingency for each (break-glass, out-of-band auth, manual fallbacks, alternate IdP for the most critical).

---

## Identify

### Finding 5 — ROPA and personal data privacy assessment underway but incomplete
- **Action:** Set a completion target date and owners for the ROPA and DPIA work.

### Finding 6 — Policies under review with no published schedule
- **Action:** All policies to be reviewed, future reviews scheduled and tracked, and staff review recorded as part of the SOC2 work. 

### Finding 7 — Light threat modelling; no enforced commit/PR blocks in SSDLC
- **Action:** Introduce threat modelling for new services and material changes. Configure tooling to block commits or PRs on defined severity thresholds (e.g. critical secrets, high CVEs, IaC misconfigurations).

### Finding 8 — Asset management gaps; information assets and Asterisk assets not fully documented
- **Action:** Produce and maintain an asset list covering Asterisk and other legacy VOIP infrastructure. Reconcile against SentinelOne and SOC coverage and remediate gaps. Bring under the same asset-management process as the UK estate.

---

## Protect

### Finding 9 — Staff feedback that cyber awareness training is "boring" and "long"
- **Action:** Refresh the cyber awareness programme. Move toward shorter, more frequent, role-relevant modules. Measure with simulated phishing click rate (already in CultureAI) and an annual culture pulse, not just completion percentages.

### Finding 10 — EDR / SOC coverage incomplete, especially legacy VOIP
- **Action:** Map every endpoint and server (UK + US) against SentinelOne and SOC monitoring. Where coverage is missing, either onboard the asset, isolate it, or document an explicit risk acceptance with expiry.

### Finding 11 — Admin app/account approval and review in Entra
- **Action:** Run a full review of all admin accounts and Enterprise Applications in Entra. Check MFA status, ownership, last-used date, role assignments, and whether shared with a third party. Hard-deprecate any account matching the MarketingAdminUser pattern (legacy, MFA-less, multi-role, shared). Introduce a quarterly recertification cycle and a formal approval workflow for any new admin account or Enterprise App.

### Finding 12 — Azure EntraID recovery relies on manual app rebuild
- **Action:** Review options for backup and recovery of EntraID apps and other identities.

### Finding 13 — SentinelOne break-glass account not stored with Protos
- **Action:** Store the SentinelOne break-glass credential securely with Protos under an agreed access protocol, so it's reachable when the M365 tenancy is unavailable. Apply the same logic to any other tools that depend on SSO into the M365 tenancy.

---

## Detect

### Finding 14 — Not all devices under SOC monitoring
- **Action:** Run a coverage audit with Protos SOC and close gaps (see also Finding 10).

### Finding 15 — SOAR automations not yet defined for routine containment
- **Action:** Work with Protos SOC to identify the top 5–10 SOAR workflows (auto-isolate on confirmed ransomware, auto-disable on impossible-travel, etc.), agree the authorisation model up front, and implement them.

### Finding 16 — US-side comms ownership and contact details inconsistent
- **Action:** Maintain a US-side incident contact list (primary, secondary, out-of-hours) in the BCDR plan and with Protos. Confirm it as part of the quarterly BCDR review.

---

## Respond

### Finding 17 — Only the Service Desk operates on-call; no on-call escalation rota
- **Action:** Establish a senior on-call rota beyond the Service Desk so that a P1 arriving out of hours reaches a decision-maker.  Review whether the current level of out-of-hours technical support is appropriate. Add the current gap to the risk register.

### Finding 19 — No US-based member on the CIRT
- **Action:** Add a US-based representative to the CIRT. Ensure they are in all relevant fallback channels and run-throughs.

### Finding 20 — US Stakeholder ownership for US-facing comms is vacant
- **Action:** Identify a replacement owner for US-facing client and staff comms and document the role in the incident comms plan.

### Finding 21 — Heavy reliance on Teams (and Twilio) for incident comms
- **Action:** Define and document out-of-band comms channels in detail: E.g. primary Teams, secondary Webex/Zoom, tertiary WhatsApp groups and personal mobile. Confirm group membership (especially Team Managers), test quarterly, and add fallback comms to BCDR plan.

### Finding 22 — Comms decision-making and ownership beyond Marketing's templates is unclear
- **Action:** Build a comms RACI for incidents — who decides, who drafts, who approves, who delivers — for each audience (internal staff, customers, partners, regulators, media). Pre-sign-off a set of holding statements (including a deliberately vague "we are experiencing technical issues" template). Define SLAs for each comms type.

### Finding 23 — No standing reminder to staff not to speak to media during incidents
- **Action:** Make an all-staff "do not discuss externally" reminder a standing element of the incident comms plan. Trigger automatically when an incident is declared P1 or higher.

### Finding 24 — HIPAA reporting obligations and HIPAA-covered US clients not documented
- **Action:** Confirm which clients fall under HIPAA and document reporting obligations and timeframes. Maintain the list as part of the incident response pack.

---

## Recover

### Finding 25 — Recovery achievable but slow, particularly in Azure / Entra
- **Action:** See Finding 12 (declarative recovery for Entra). Set internal RTO/RPO targets for the M365 tenancy and the call-handling stack, and measure against them in the next exercise.


---

## Next steps

- Stand up the information security risk register (Finding 2) and use it as the spine to track Findings 1–26 through to closure.
- Mirror Findings 17 (senior on-call), 11 (Entra admin review) and 3 (supply chain assurance) as top priorities — these are the highest-leverage controls against a repeat of the scenario.
- Consider creating a Linear project ("Post-IR-Exercise Remediation, Feb 2026") with one issue per finding, owners and target dates.

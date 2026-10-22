---
id: 01M5G5MSMWW9GSEARB69GRXTWP
created: 2026-10-21T21:24:59.676743Z
updated: 2026-10-22T19:32:39.962108Z
type: task
title: 'ADR: Risk Assessments — a company records each risk assessment as a dated exercise with a scope, assessors and a named approver, frozen once approved; four kinds (risk assessment, DPIA, PCI targeted risk analysis, AI impact assessment) on one base; UK GDPR joins as a framework'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1219
sprint: s33gwqy
comments:
- id: 01M5G5XY82XZ46YZJ2NDJ5J21G
  author: Steve Vine
  at: 2026-10-21T21:29:59.298094Z
  text: |-
    Sprint plan, in build order (each blocked by the one before):

    1. COM-1219 — this ADR, 0123 (independent)
    2. COM-1220 — Risk Assessments in the menu, permissions (chain: API)
    3. COM-1221 — the register holds up to an audit: Accepted only via accept, closed out of figures, link changes in Activity (chain: migration + API)
    4. COM-1222 — risk review dates; acceptance needs an approver and expires (chain: migration + API)
    5. COM-1223 — threat catalogue, Admin ▸ Rubrics ▸ Threats (chain: migration + API)
    6. COM-1224 — start an assessment (chain: migration + API)
    7. COM-1225 — work through the threats (chain: migration + API)
    8. COM-1226 — submit, approve, send back; freeze; writes the register (chain: migration + API)
    9. COM-1227 — next one due, Actions, start from the last or on change (chain: migration + API)
    10. COM-1229 — the PDF record (chain: API)
    11. COM-1230 — evidence: Audit ▸ Evidence, Evidence of operation, SAP activity (chain: API)
    12. COM-1231 — import threats from a spreadsheet; the Carbide assessment (chain: API)
    13. COM-1232 — SoA "Risks treated"; fuller register export (chain: API)
    14. COM-1233 — controls library wording and crosswalk gaps (chain: migration)
    15. COM-1234 — Risk to people rubric (chain: migration + API)
    16. COM-1235 — DPIA screening (chain: migration + API)
    17. COM-1236 — the DPIA (chain: migration + API)
    18. COM-1237 — ICO prior consultation; DPIA review on change (chain: migration + API)
    19. COM-1238 — PCI targeted risk analyses (chain: migration + API)
    20. COM-1239 — PCI customised-approach analyses (chain: migration + API)
    21. COM-1240 — AI system impact assessments (chain: migration + API)
    22. COM-1228 — the Overview, once every kind exists (chain: API)
    23. COM-1242 — the assistant (independent, built last)

    Off the chain: COM-1241 — UK GDPR as a framework (independent; blocked only by the ADR; can merge whenever green).

    Sprint 82 (Evidence) is being built now; this chain starts after its last on-chain task has merged — COM-1230 needs its Evidence register (COM-1205) in any case.
- id: 01M5JHKT2NY7T54MFF3QEJ2S13
  author: Steve Vine
  at: 2026-10-22T19:32:39.125389Z
  text: |-
    Done — merged in PR #1236 (docs only).

    - ADR 0123 (decisions/0123-risk-assessments.md) sets out how Risk Assessments works. Every later task in the sprint is built from it.
    - The IA brief has Risk Assessments in the Modules table, after Inventory and before SAP. Its tabs are Assessments and Overview, plus a Settings tab for managers.
    - The permission catalogue has the three permissions: View, Manage, and Approve risk assessments and accept risks. Only Admin holds them; the starter roles are unchanged.
    - The rubrics brief has Threats (9 categories, 30 default threats) and Risk to people (the ICO 3×3 scale).

    My calls, made while writing it to reconcile the tasks (ADR calls 14–21, alongside your 1–13):
    - RA-n numbers come from one sequence across all companies, like R-, G- and INC-. This task said "per company"; one sequence keeps each reference unique in search, Activity and the assistant, but a company's own numbers won't run in order.
    - A DPIA screening is its own kind with an RA number and no approver. It is Completed and frozen once saved with its outcome and reason. The PCI customised-approach analysis is a variant of the PCI kind, not a separate kind.
    - An assessment moves from Draft to In progress at the first change to it. Only Draft and In progress can be withdrawn.
    - A Settings tab holds the cadences, the risk review cadence and the acceptance period. The PCI cadence can't be set longer than 12 months.
    - An approved assessment's PDF is made once, on approval, and kept. Drafts are rendered when downloaded.
    - Measures a DPIA or AI impact assessment leaves to do become follow-ups (owner, due date, done) beside the frozen record, not register treatments. Only risk assessments write to the register.
    - AI evidence follows COM-1240: impact assessments count for AIG.6 and AIG.7, and risk assessments whose scope names ISO 42001 count for AIG.5.
    - Two threats were added to reach 30: "Misdirected email or disclosure" and "Failed software change".

    To check: the default Risk to people grid is the helper's recollection of the ICO's example matrix. I'll have it checked when COM-1234 is built.
assignee: steve
label:
- brief
priority: high
task_status: review
---
Sprint 83, Risk Assessments. The decision record for the sprint: **ADR 0123**, plus the IA brief's Modules table, the permission catalogue and the rubrics brief. Every other task builds on it.

**Chain:** independent

## Why (review, 2026-10-21)

Compass has a complete risk register (scored before and after controls, treated, accepted against appetite, linked, versioned, exported). What it has never had is the **risk assessment itself**: a dated exercise with a scope, the people who did it, what they looked at, and a sign-off. Every framework expects that record:

- **SOC 2** CC3.1–CC3.4 (incl. fraud, CC3.3, our weakest-covered requirement, and change, CC3.4), CC5.1, CC9.1/9.2.
- **ISO 27001** 6.1.2, 6.1.3 (with the SoA), 8.2 (planned intervals *and* on change), 8.3, 9.3.
- **ISO 42001** 6.1.2 AI risk assessment, 6.1.4/8.4 AI system impact assessment, A.5.2–A.5.5.
- **NIST CSF** ID.RA-01..10, GV.RM-01..07. **HIPAA** 164.308(a)(1)(ii)(A)/(B), records kept 6 years (164.316). **HITRUST** 03.a–03.d, 13.q. **PCI DSS** 12.3.1/12.3.2 targeted risk analyses (in force since 2025-03-31).
- **GDPR** Art. 35 DPIA and Art. 36 prior consultation — not loaded as a framework today; only control PDH.12 exists, nothing behind it.

The crosswalk marks all of these covered, but the controls (RIM.2, RIM.3, RIM.4, RIM.6, INA.4, PDH.12, AIG.5, AIG.6) describe a process; nothing in Compass produces the record proving it ran.

The register also has holes an auditor would find: a risk can be set to Accepted directly, skipping the appetite check; acceptance has no expiry and no approver but the owner; closed risks still count in the posture figures and heat-map; no risk has a review date; risk↔control/gap/vendor link changes aren't in Activity; the export leaves out the band, appetite and treatments.

## What Steve decided (2026-10-21)

1. **All four kinds** this sprint: risk assessment (company-wide or scoped — ISO/SOC 2/HIPAA/NIST/HITRUST, and AI risk under ISO 42001), **DPIA** (GDPR), **PCI targeted risk analysis**, **AI system impact assessment** (ISO 42001).
2. **UK GDPR** joins as a framework this sprint, with its crosswalk.
3. A finished assessment is signed off by a **named approver** who isn't one of its assessors; their approval freezes it.
4. A company's first assessment can start from a **built-in threat catalogue**, and the existing **Carbide assessment is imported** so nothing is retyped.

## How it works

- **Modules ▸ Risk Assessments.** Each assessment (`RA-7`) has a kind, title, scope, assessors, other participants, an approver, why it was started (scheduled, significant change, incident, new system or processing, other) and dates.
- **Lifecycle:** Draft → In progress → Awaiting approval → **Approved** (frozen) — or sent back with a comment, or Withdrawn (kept, never deleted).
- **The register stays the one list of risks.** An assessment works on its own copy; approving it writes the scores, owners and decisions to the register (a revision "from RA-7"). A risk shows every assessment it appeared in.
- **Approved means frozen:** the answers, and the scales and appetite as they stood that day. To reassess you start the next one *from* it. Next one falls due on a cadence (12 months by default per kind) and appears in Actions; a significant change or incident can start one early.
- **The record an auditor reads:** a PDF in the company's house style; it joins Audit ▸ Evidence (sprint 82) and is Evidence of operation for the controls it proves.
- **DPIA and AI impact assessments assess harm to people, not to the company** — their own scale (Admin ▸ Rubrics ▸ Risk to people, ICO 3×3 by default), and a DPIA cannot be closed by accepting high risk: it goes to prior consultation with the ICO.

## My calls (for Steve to confirm)

1. **Place:** Modules ▸ Risk Assessments, after Inventory and before SAP (what you hold → what could go wrong → the work that proves it). The Risks register stays under Posture.
2. **Permissions:** View risk assessments, Manage risk assessments, **Approve risk assessments and accept risks** (the last also needed to approve an acceptance in the register). Built-in Admin only; starter roles stay frozen.
3. **One numbering** (`RA-n`) per company across all four kinds, the kind shown beside it.
4. **Threat catalogue** lives in Admin ▸ Rubrics ▸ Threats (organisation-wide, like the other rubrics), written fresh for Compass (~30 threats incl. fraud and the AI risk sources) — not copied from Carbide's templates.
5. **Fraud (CC3.3):** an assessment with no fraud threat in it can still be submitted, but the assessor must say why fraud isn't relevant; that line is in the PDF.
6. **Residual is judged, not computed.** Each threat shows the company's current status of the controls relied on (Implemented, Partial, Not implemented, Not assessed) to inform the judgement.
7. **Acceptance** expires after 12 months by default and needs an approver with the approve permission (may be the owner if they hold it).
8. **Closed** risks drop out of posture figures and the heat-map; **Accepted** ones stay in (they're still risks).
9. **DPIA:** screening is recorded for every processing activity (data asset) whether or not a DPIA follows; the DPO is named on the DPIA (a person in Compass or an external name); approval waits for the ICO's reply when prior consultation is needed.
10. **PCI TRAs** exist only where PCI DSS is in scope for the company; one per requirement that lets the company set its own frequency, plus one per customised-approach requirement.
11. **AI impact assessments** scope to technology assets marked "AI system" in Inventory.
12. **Carbide import** is a general "import threats from a spreadsheet" on an assessment; I prepare the spreadsheet from Carbide's 23-threat assessment ("Risk Assessment Inherent Risk", Moneypenny org). Its scores land as **inherent**, residual left for the assessors; it imports as a **Draft** into the **Moneypenny** company. Carbide's own control codes (ECM4, IAM1…) are matched to Compass controls by hand where clear; the rest go in the threat's notes.
13. **UK GDPR** (Crown copyright, Open Government Licence) — articles 5–49 at article/paragraph level, mapped to the privacy controls and the DPIA.

## Not in this sprint

Opportunities (RIM.8); per-company scales; business impact analysis as its own kind; legitimate interests and international transfer risk assessments; a Carbide connector; deleting assessments.

**Done when:** ADR 0123 is merged, the IA brief has Risk Assessments in the Modules table, the permission catalogue has its table, and the rubrics brief has Threats and Risk to people.
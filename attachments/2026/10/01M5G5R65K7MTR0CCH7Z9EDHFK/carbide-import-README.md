# Carbide → Compass threat import (COM-1231)

Attached to the task, not committed: it is a customer's own risk assessment, with staff email addresses.

## `carbide-moneypenny-risk-assessment.csv` (COM-1231, ADR 0123 §18)

Moneypenny's Carbide assessment **"Risk Assessment Inherent Risk"**
(Carbide id `4624987c-9800-4954-a245-53199b4ddbd7`, a draft there), read on
2026-10-22 with Carbide's read tools only, in the template of Risk
Assessments ▸ an assessment ▸ Threats ▸ **Import threats**. Import it into a
Draft risk assessment in the Moneypenny company once its approver and
assessors are chosen. The repo's test imports a synthetic file of the same
shape (`app/backend/tests/fixtures/risk_import_carbide_shape.csv`).

What came across, and how:

- **23 threats.** Carbide holds 24; *Theme: Financially Motivated Attacks
  (Meta)* is left out — Carbide's own record says it is a reporting tag, not a
  threat, and that scoring it would double-count the mechanism threats.
- **Threat and description** are Moneypenny's own words (Carbide's threat
  text), not Carbide's template description, which for several repurposed
  threats still describes the old threat. Line breaks Carbide's export lost
  between list items are put back.
- **Scores as inherent.** Carbide scores each threat once, as likelihood and
  impact on five words; they are the inherent likelihood and impact, Very
  low = 1, Low = 2, Moderate = 3, High = 4, Very high = 5. Residual is left
  for the assessors. Carbide's overall risk score is kept in the notes.
- **Decisions.** Reduce is Mitigate (19). Carbide's four Accepts are left
  without a decision — Compass accepts only a scored residual within
  appetite — with "Carbide's treatment was Accept" in the notes.
- **Rationale** is Carbide's treatment procedure; **notes** carry Carbide's
  mitigating-controls text, its notes, and the control matching below.
- **Owners** by email: the four Carbide users who own threats.
- **Category** set by hand, following the threat catalogue's categories; left
  blank for *Delayed Incident Response*, which has no clear one.
- *Malicious Insider* is named as in the catalogue, so it links to it and takes
  the catalogue's controls (Carbide names none).

Carbide's control codes, matched by hand to Compass control references:

| Carbide | Compass |
| --- | --- |
| ECM4 malware protection | THP.10 |
| IAM1 access control and identity lifecycle | ACC.1, IDM.3 |
| VM1 vulnerability scanning and remediation | VUM.5, VUM.6, VUM.8 |
| VM3 patch management | VUM.1, VUM.2, VUM.3, VUM.4 |
| ECM8 penetration testing | VUM.7, VUM.11 |
| CNS1 boundary defence | NES.10 |
| CNS2 capacity management | EVM.1 |
| CNS6 logging and monitoring | EVM.2, EVM.5 |
| CNS8 network and data-flow diagrams | NES.8, INS.9 |
| BCIM1 continuity, recovery and incident plans | BCR.2, BCR.4, IMA.1 |
| BCIM2 annual continuity test | BCR.8 |
| BCIM3 incident reporting, incl. third-party notification | IMA.2, VEM.13 |
| BCIM4 backups and restore testing | BCR.13, BCR.15 |
| TPM1 third-party management | VEM.1 |
| TPM2 third-party risk assessment | VEM.5, VEM.7 |
| PRV2 breach notification | IMA.8, IMA.19 |
| PRV18 privacy impact assessment | PDH.12 |
| PRV19 lawful basis | PDH.1 |
| HRS1 employee agreements and workplace policies | PEO.1, INS.1 |
| HRS3 roles, responsibilities and authority | INS.8 |
| DM1 data classification and inventory | INC.3, INC.4, INC.7 |
| DM2 protecting data in transit and removal | KMC.5, INS.10 |
| AM1 asset inventory | ASM.1 |
| AM2 asset protection, incl. off-site | ASM.15 |
| PS1 physical protection | PES.3, PES.7 |
| GV3 security awareness | SEA.1 |
| GV8 audit and compliance | INA.2, INA.6 |
| RM1 risk-based control selection | RIM.2, INS.16 |

No clear match, kept in each threat's notes: **PRV12** (limiting the use and
disclosure of personal data), **PRV3** (collecting only what is needed),
**HRS11** (effective communication practices).

References are as of migration 0535 (main at ef15d755). If the library is
renumbered before the import, check them against the table above.

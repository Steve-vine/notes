---
id: 01M0Z9C7MJZXVR6XJWXD8RZ4ES
created: 2026-08-26T15:00:20.754887Z
updated: 2026-08-26T15:02:30.138578Z
type: task
title: 'New controls: Govern — the layer that answers to a board, not a firewall'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 425
sprint: s8cjs5n
blocked_by:
- 01M0Z97CSYY5PCWNAXCXVM05XX
- 01M0Z9AM5JGCYXEFZ5XA0XATVR
assignee: steve
company:
- moneypenny
label:
- feature
priority: urgent
task_status: backlog
---
Thirty-two new controls. The highest-leverage task in the sprint: it unblocks 31
NIST CSF subcategories, 17 SOC 2 criteria, the ISO clauses, and the 14 PCI `x.1`
requirements in one pass.

The governance layer is a stub. Information Security holds 9 controls and
Technology Risk Management holds 4, and between them they are supposed to answer
the whole Govern function of CSF 2.0, SOC 2's CC1–CC5, and ISO's organisational
controls. It is why Cyber Essentials scores 100% and NIST CSF scores 60% — the
library was built to satisfy a technical baseline.

## What to write

**Information Security Governance `INS` — 9 new**
Organisational context and mission as an input to security decisions · interested
parties and their security expectations · leadership accountability for security
risk · resources allocated in proportion to the risk strategy · policy lifecycle:
owner, approval, review cadence, communication · how control activities are
selected against risk · security objectives communicated internally · external
communication about security matters · management review of the security
programme.

**Technology Risk Management `RIM` — 3 new**
Risk appetite and tolerance, stated and communicated · a documented method for
calculating, documenting and prioritising risk · lines of communication for
security risk across the organisation.

**Compliance & Internal Audit `INA` — 2 new**
Control deficiencies tracked to closure with an owner and a date · the compliance
programme itself: scope defined, validated, and someone accountable for it.

**People Security `PEO` — 8 new, the whole domain**
Screening and background checks proportionate to the role · security
responsibilities in employment terms · confidentiality and non-disclosure
agreements · a disciplinary process for security breaches · workforce
authorisation and supervision for access to sensitive systems · obligations on
change of role, not just on leaving · obligations that survive termination ·
security in recruitment and onboarding.

**Supply Chain & Third Party `VEM` — 9 new**
Supplier inventory with criticality tiering · due diligence before entering a
relationship · security requirements written into contracts · ICT supply chain
risk · cloud service provider assurance and the shared responsibility model ·
subcontractor flow-down · monitoring supplier activity and service delivery ·
suppliers included in incident planning and response · exit provisions and secure
decommissioning.

**Security Awareness & Training `SEA` — 1 new**
Secure development training for engineers, distinct from general awareness.

## Notes

- **The PCI `x.1` pattern.** Fourteen PCI requirements test that a policy is
  documented, kept current, in use, and assigned to an owner. The `INS` policy
  lifecycle control is what answers them — write it so it is assessable per
  policy, not once for the whole library.
- **Align the supplier controls to the vendor module.** Compass already has
  vendor lifecycle states, questionnaires, owners and reviews (ADRs 0039, 0050,
  0051). These controls should describe what that module does, so evidence is a
  link into it rather than a document someone wrote separately.
- Each control gets the three-part description from the identity ADR. For this
  domain especially, "what good looks like" is where the value is — governance
  controls are the easiest to claim and the hardest to evidence.

Depends on the control identity ADR and the domain consolidation. Map as you
write — writing and mapping together is far cheaper than writing then mapping.

---
id: 01M0Z9AM5JGCYXEFZ5XA0XATVR
created: 2026-08-26T14:59:28.050217Z
updated: 2026-08-26T14:59:28.050217Z
type: task
title: The domain list becomes 23, and Identity splits into Identity Management and Access Control
company: moneypenny
assignee: steve
label: feature
priority: urgent
task_status: backlog
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 423
---
Thirty-five domains for 269 controls, ten of which hold four or fewer: Capacity
Management (2), Data Retention and Disposal (2), IT Acceptable Use (2), Wireless
Communication (2), BYOD (3), Removable Media (3), Internal Audit (4), Patch
Management (4), Technology Risk Management (4), Equipment Handling (4). Together
they hold 11% of the controls and a third of the navigation.

The list is shaped like one organisation's policy index rather than a risk
taxonomy — which is why there is a domain for wireless and none for people, and
why the nearest thing to cloud is called "Data Centre Architecture Standards".

## The new list

Organised on the NIST CSF 2.0 functions — the same spine CIS adopted in v8.1, so
the domain view and the CIS view answer the same question.

**Govern** — Information Security Governance `INS` · Technology Risk Management
`RIM` · Compliance & Internal Audit `INA` · **People Security `PEO`** (new) ·
Supply Chain & Third Party `VEM` · Security Awareness & Training `SEA`

**Identify** — Asset & Configuration Management `ASM` · Information
Classification `INC` · Privacy & Personal Data `PDH` · Threat & Vulnerability
Management `VUM`

**Protect** — **Identity Management `IDM`** (new, from the split) · Access
Control `ACC` · Cryptography & Key Management `KMC` · Endpoint & Mobile Security
`END` · Network & Remote Access `NES` · **Cloud & Infrastructure Security `CLD`**
(reframed from Data Centre Architecture) · Secure Development `SOD` · Change &
Release Management `CHM` · Physical & Environmental Security `PES` · Threat
Protection `THP`

**Detect** — Logging, Monitoring & Detection `EVM`

**Respond** — Incident Management `IMA`

**Recover** — Business Continuity & Backup `BCR`

## The merges

Fourteen domains fold into survivors, keeping every control: BYOD, Mobile Device
Management and Removable Media → Endpoint. Wireless and Remote Access → Network.
Data Backup → Business Continuity. Data Retention → Information Classification.
Equipment Handling and Workspace Security → Physical. External Network Equipment
→ Network. Patch Management → Threat & Vulnerability. User Credentials →
Identity Management. Capacity → Logging & Monitoring. Acceptable Use →
Governance.

## The Identity split

Access Control plus User Credentials is 33 controls after the new ones land —
the largest domain by some margin, and really two things:

- **Identity Management** — who exists and how they prove it. Accounts,
  credentials, the directory, joiner and leaver provisioning, service and machine
  identities, authentication strength. Roughly 19.
- **Access Control** — what an identity may reach. Authorisation, least
  privilege, privileged rights, segregation of duties, recertification,
  restriction to source code and privileged utilities. Roughly 14.

The split is worth making because they are assessed by different people and
evidenced differently — identity by whoever runs the directory, access by the
asset owner.

## What changes for the reader

Twenty-three domains, each with a function, none with fewer than five controls.
A policy per domain still holds — which means the policy library merges too: the
BYOD, Mobile Device and Removable Media policies become one Endpoint Security
policy. That is the real cost of this task and it should be planned, not
discovered.

## Implementation

- Depends on the control identity ADR. Domains gain `function` (the six CSF
  functions) as an enum with a display order.
- `domains.code` is `String(3)` and unique — `END`, `IDM`, `CLD` are new codes,
  `DBC` and `CRD` retire. Retiring a code while controls still carry its ref
  prefix is the ordering trap here: renumber inside the same migration.
- Merged domains are **not** deleted — they are soft-deleted after their controls
  move, so history and the audit trail resolve (ADR 0023).
- Content: each domain's policy needs to point at the right domain. Check
  `content` links before the merge and re-point them, or the playbook loses its
  anchors.
- Display order follows the function order, not alphabetical.

Tests: every control has a domain after the merge; no domain has zero controls;
soft-deleted domains still resolve in the audit trail; content links survive.

---
id: 01M0Z9DFWZQ29QRCWM0VZW09JB
created: 2026-08-26T15:01:01.983367Z
updated: 2026-08-27T00:33:31.144742Z
type: task
title: 'New controls: Identify, Detect, Respond, Recover — the half of CSF that stops at "respond per the plan"'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 427
sprint: s8cjs5n
blocked_by:
- 01M0Z97CSYY5PCWNAXCXVM05XX
- 01M0Z9AM5JGCYXEFZ5XA0XATVR
assignee: steve
company:
- moneypenny
label:
- feature
priority: high
task_status: active
---
Thirty-five new controls. Incident response is the worst-covered area in the
library after governance: it has a plan, a register of contacts and a
post-incident review, and nothing in between. The entire Respond and Recover half
of CSF 2.0 rests on nine controls.

## What to write

**Incident Management `IMA` — 9 new**
Triage and validation of reported events · categorisation and prioritisation ·
severity thresholds that define when an event becomes an incident · escalation
criteria and paths · containment · eradication · criteria for initiating recovery
· estimating and validating incident magnitude · declaring the end of an incident
and completing its documentation.

Also cover the notification mechanics HIPAA requires and Compass cannot currently
evidence: content and method of individual breach notification, notification to
media where thresholds are met, notification to the regulator, and breach
notification by a third party on your behalf. `IMA.10` covers the obligation in
principle; these are the specifics an auditor tests.

**Logging, Monitoring & Detection `EVM` — 8 new**
Adverse events analysed to understand what happened · information correlated
across sources · estimated impact and scope of an event · log content standards —
what a log record must contain to be useful · DNS query logging · URL request
logging · command-line audit logging · periodic review of logs by someone whose
job it is.

Plus one the library does not have at all: **detection of security control
failure** — knowing, within a defined window, that logging stopped, anti-malware
stopped updating, or a scan stopped running (PCI Req 10.7, and a future-dated
requirement mandatory since March 2025). Not PCI-specific in spirit: a control
that has silently stopped working is worse than one you know is missing, because
it still reads as green.

Note `EVM` already has strong collection and alerting controls. What is missing
is everything between "an alert fired" and "we understand what happened" — and
now, whether the alerting itself is still alive.

**Business Continuity & Backup `BCR` — 4 new**
Redundancy of information processing facilities · ICT readiness for business
continuity (distinct from the business plan — `BCR` covers the business side
well and the technology side thinly) · an isolated or immutable copy of recovery
data · integrity of backups verified before they are relied on in a restore.

The immutable copy is the ransomware control the library does not have. `DBR.4`
gives 3-2-1 and off-site, which is not the same thing as offline or immutable.

**Privacy & Personal Data `PDH` — 6 new**
Data protection impact assessments · records of processing activities ·
international transfer safeguards · responding to correction and erasure requests
(`PDH.12` covers access only) · a register of personal data disclosures,
authorised and unauthorised · privacy complaints handled and monitored.

**Information Classification `INC` — 6 new**
A retention schedule per data classification · secure deletion with proof of
destruction · protection of records against loss, falsification and unauthorised
access.

Plus three from the PCI `x.y.z` analysis, which found the library carries **no**
control mentioning masking, truncation or tokenisation (Req 3.2–3.5):

- storage of sensitive data kept to the minimum the business actually needs, with
  a defined retention period and documented justification;
- authentication data not retained after it has served its purpose — for cards
  this is track data, verification codes and PIN blocks after authorisation, and
  the same principle applies to credentials and tokens generally;
- sensitive data rendered unreadable wherever it is stored, and masked when
  displayed, with copy and relocation restricted to those with a business need.

Write these to scope themselves by data classification rather than naming card
data, so they earn their place for every company and get marked applicable where
they bite. See COM-422 on sector-specific controls.

**Threat & Vulnerability Management `VUM` — 1 new**
Threat intelligence: received, evaluated and acted on. Nothing in the library
mentions it, and ISO gives it a dedicated control (`A.5.7`).

**Asset & Configuration Management `ASM` — 1 new**
Security of assets off-premises. `ASM.3` and `ASM.4` cover authorisation and risk
assessment before an asset leaves; neither covers protecting it while it is out
there.

## Notes

- The incident controls should describe how Compass's own Actions queue and
  notifications work where they overlap (ADR 0055) — triage, escalation and
  ownership have a home in the product already.
- Watch the boundary with `EVM`: detection engineering and incident analysis
  overlap. Put "understanding an event" in `EVM` and "running an incident" in
  `IMA`, and say so in the descriptions so assessors do not evidence the same
  thing twice.

Depends on the control identity ADR and the domain consolidation. Map as you
write.

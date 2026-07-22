---
id: 01JRHTD1NVESEG0R9ENP5MBTQ9
created: 2025-04-11T07:00:38.203438997Z
updated: 2026-05-06T08:41:21.210374542Z
type: memo
title: Protos
imported_from: Obsidian
---
11-04-2025 08:00

Tags: #noc #soc


---
11-04-2025
NOC and SOC Review

Why is Firepower the top data source for log ingestion?
What visibility is missing (infrastructure in USA and Cloud Infrastructure i.e. AWS)?
Cisco ISE Renewal time?
Options for certificate management PKI?
What access is NOC missing?

- WiFi poor quality, unusable for Teams calls
- Roaming seems a bit extreme
- USM Agent not installed to all Mac's
- Set date for incident response exercise
- SOC needs access to Abnormal
- Organise a review of systems

~~CAB Notifications for SOC and NOC support@ soc@~~
~~Setup PIM Access for NOC~~
Setup planning session (future direction, ISE and PKI)
Tabletop exercise (September)
USM on all servers

NOC:
Phil Lewis
Jamie Barnes-Hockings
Sean Kinsella
Tim Shotton
Darren Kewley

SOC
Luke Payne
Nathan Halter
Jack Hobden
Rob Zabel
Darren Kewley

---

07-05-2025
Strategy Meeting

ISE - Do we really need it?
Cert services

USM for MSG, what do we need to do?
USM for servers, what's missing?

<hr>

20-08-2025
NOC Review
- Wrexham MX's are they powerful enough, seem to have lots of resource constraints?
- How do we get real-time resource usage out of them?
- Automated failover between MX's seems to happen a lot (VRRP Events).
- Failover between carriers didn't happen during an issue with Cogent last week
- Can we prevent them failing back automatically?
- WiFi is still perceived to be problematic.

SOC Review
- Joe joining the team - roles and responsibilities
- USM Sensors need deploying in AWS.
- We're not keeping USM up to date, should we see this in reports?


- AbnormalAI/S1 permissions not right.
- Protos will provide a Wireless scan
- Protos will look into MX possibilities

26-08-2025
Call with Darren about MDR

#### Key elements of MDR for Moneypeny
EDR (Enhanced Detection and Response)
- Workstation and server protection
- Device isolation
- Automated actions
IDP (Identity Threat Protection)
- PAM (Privileged Access Management), JIT - Enforces least privileged
- Misconfiguration - Admin without MFA / Excessive privileges
- Human, service account, AI Agents (CoPilot)
- Entra ID, AD, SaaS products
- Detect anomalies
CSPM (Cloud Security Posture Management)
- Cloud security evaluation and recommendations
SOAR (Security Orchestration, Automation and Response)
 - Runs playbooks (automated workflows) to triage, contain, remediate, and notify
 - Consistent, repeatable handling of incidents

Actions:
Moneypenny/Protos to look into options for IDP and CSPM
Moneypenny/Protos to take of free offer from Croudstrike on IDP
Protos to continue working on SOAR
Protos will update the contract wording to help define the service as MDR

21-11-2025
Contract Wording
SCEPman in budget
ISE Replacement

Vanta

## 7th May 2026

- FIDO2 keys



---
## References
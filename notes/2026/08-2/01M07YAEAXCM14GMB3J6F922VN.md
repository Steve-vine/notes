---
id: 01M07YAEAXCM14GMB3J6F922VN
created: 2026-08-17T13:24:35.805637Z
updated: 2026-08-19T13:56:46.275927Z
type: memo
title: Compass Roadmap
project: 01KXGC5PTGYHV30VM3E78G76S1
---
## Release V1
- [ ] Frameworks
    - [ ] CIS
    - [ ] Cyber Essentials Plus
    - [ ] HIPAA
    - [ ] ISO2 27001
    - [ ] NIST Cybersecurity Freamework
    - [ ] PCI DSS
    - [ ] SOC 2
- [ ] Domains
- [ ] Controls
- [ ] Decisions
- [ ] Risks
- [ ] Gaps
- [ ] Actions
- [ ] Reports
- [ ] Content
    - [ ] Templated
    - [ ] Linked
    - [ ] Uploaded
    - [ ] Managed
- [ ] Single Sign On (SSO)

## Release V2
- [ ] Vendor Management
    - [ ] Internal Vendor Portal
    - [ ] External Vendor Portal - Vendor Questionnaires

## Release V3
- [ ] Access Control
    - [ ] Access Recertification
    - [ ] Scheduled Leavers

## Future Features
### Access Control
**Capabilities**
Manage Groups - Requires validation/signoff to ensure description is good enough
Role Matrix
JML - Provision/De-provision users
Assign users to groups
Group audit - Requires owner


### Trust Centre
Create an invite only trust centre that can be used to share documents ant information with interested parties.

### Policy attestation campaigns
staff periodically confirm "I've read and accept the Acceptable Use Policy”.

### Exceptions / waivers register
Controls that a company deliberately doesn't meet, with justification, compensating controls, owner, expiry and mandatory review.

### Evidence pack export
bundle assessment/risk evidence attachments into a zip per framework.

### Asset & information inventory
An asset register (systems, applications, data stores) with data-classification using the ADR 0042 data rubric, linked to risks, vendors and controls.

### Audit management
Model an external audit as an entity: scope (framework), evidence-request (PBC) list, findings mapped to gaps, and an auditor-facing read-only portal.

### Incident register 
(governance-grade, not operational). Not competing with ISE — a lightweight record of security incidents with severity, timeline, linked risks/controls, and lessons-learned that spawn gaps/actions.

### Continuous control monitoring
automated evidence. This is what separates Drata-class platforms from trackers: integrations that test controls automatically ("MFA enforced?", "stale accounts?", "backups ran?"). Access Control quietly builds your first one — the Entra mirror can answer MFA coverage, dormant accounts, privileged-group membership as scheduled checks that auto-update assessment evidence or raise gaps. Start there, add checks per integration (M365 Secure Score, your k8s cluster, backup jobs). Design the "check → evidence/gap" contract once, in an ADR, like the email-transport contract.
Posture over time. You have append-only assessment/risk revisions — there's an untapped time-series in the database. Maturity and coverage trend charts, "what changed this quarter" digests for management. Read-only, no new writes, high perceived value.

### Posture over time
Maturity and coverage trend charts, "what changed this quarter" digests for management. Read-only, no new writes, high perceived value.

### AI assist
draft policy sections from templates, propose Core↔new-framework crosswalk mappings (the conservative-starter CSVs you hand-curate today), summarise evidence for an auditor, or "explain this control and what would satisfy it". The crosswalk-suggestion one is the most concretely valuable.

### Teams/webhook notification channels
riding the ADR 0044 transport pattern.

### BC/DR exercise scheduling 
Runbook tests with evidence, on the content-review cadence machinery.

### DORA/NIS2 frameworks 
As seed data if any company in scope touches them.

## Definition
GRC Tool -> Internal Trust Platform
 holds the playbook, measures reality, and reconciles the two.


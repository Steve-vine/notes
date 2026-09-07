---
id: 01M1YC2DQQDA80GTA9R42CQW43
created: 2026-09-07T16:43:52.439347Z
updated: 2026-09-07T16:43:52.439347Z
type: task
title: 'DM2: Protection of sensitive data during transmission, movement, and removal'
priority: medium
assignee: steve
task_status: backlog
project: 01KY4JNC6MPPNNFXN416S398SG
number: 41
---
## Control Objective

Callitech Limited restricts the transmission, movement, and removal of sensitive and confidential information — including customer PII, CRM data, call recordings, and customer content — to authorized users and processes, and protects such data during transmission, movement, or removal.

## Implementation Guidance

Access to sensitive data in transit or being moved/removed from Callitech systems (e.g., between UK and US offices, to/from cloud-hosted systems in the EU and US, or to third-party telecom, workflow, and AI answering platforms) is restricted based on user role and business need.

Sensitive data is protected during transmission using encrypted communication channels (e.g., TLS or equivalent secure protocols) between internal systems, client systems, and third-party providers.

Movement or removal of sensitive data (e.g., export of CRM records, extraction of call recordings, use of removable media, or transfer to external parties) is governed by policy requiring authorization and, where feasible, technical controls or monitoring to detect and prevent unauthorized transfer.

Activity involving the movement of sensitive data is monitored on an ongoing basis to identify unusual or unauthorized transfer, with findings feeding into the incident response process.

Personnel handling PII, call recordings, CRM data, or customer content receive guidance on secure handling, transmission, and removal practices as part of onboarding and periodic security awareness activities.

Data protection practices are reviewed periodically and updated to reflect changes in systems, vendors, or regulatory obligations (e.g., GDPR, and client-driven HIPAA/PCI requirements).

## Evidence Request

Documentation of access restrictions governing transmission, movement, and removal of sensitive dataEvidence of encryption in transit (e.g., configuration records) for systems handling PII, CRM data, call recordings, or customer contentRecords of monitoring activity or alerts related to data movement/removalTraining materials/records covering secure handling and transmission of sensitive dataRecords of periodic review of data protection practices
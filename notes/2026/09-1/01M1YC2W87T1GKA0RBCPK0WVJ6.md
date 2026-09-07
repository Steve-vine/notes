---
id: 01M1YC2W87T1GKA0RBCPK0WVJ6
created: 2026-09-07T16:44:07.303927Z
updated: 2026-09-07T16:44:07.303927Z
type: task
title: 'DM4: Encryption and key management for sensitive data'
priority: medium
assignee: steve
task_status: backlog
project: 01KY4JNC6MPPNNFXN416S398SG
number: 43
---
## Control Objective

Callitech Limited implements encryption and key management controls to protect sensitive data — including PII, CRM data, call recordings, and customer content stored or processed across UK and US offices and EU/US-hosted cloud systems — from unauthorized access, interception, or exposure.

## Implementation Guidance

Sensitive data is encrypted at rest and in transit using industry-standard methods (e.g., strong encryption for stored data, secure transport protocols such as TLS for data moving between offices, cloud providers, telecom providers, and third-party workflow/AI answering tools).

Encryption keys are generated, stored, and managed in a manner that limits access to authorized Infrastructure and Cybersecurity personnel only, consistent with role-based access principles.

Access to encryption keys is reviewed periodically, and keys are rotated, revoked, or replaced when personnel roles change, when a key is suspected of compromise, or on a defined periodic basis, to limit the risk of unauthorized use.

Backup and disaster recovery data is protected using the same encryption standards applied to live production data.

Encryption and key management practices are reviewed periodically to reflect evolving threats, regulatory requirements (e.g., GDPR, and HIPAA/PCI obligations tied to certain clients), and changes to Callitech's technology environment.

## Evidence Request

Documentation or configuration evidence of encryption applied to data at rest and in transitRecords of key access restrictions, rotation, or revocationEvidence of periodic review of encryption/key management practices

Note on requirement mapping

This control addresses authorization and access restriction specifically for cryptographic key access. It does not itself cover the broader lifecycle of general system user account registration, authorization, and deprovisioning (new hire/leaver credential issuance and removal), which is addressed by the organization's access management controls outside this domain.
---
id: 01M1YCG4XG4485H4PJ2BW0WS0D
created: 2026-09-07T16:51:22.160859Z
updated: 2026-09-07T16:51:22.160859Z
type: task
title: 'TPM1: A comprehensive third-party management methodology is followed to oversee external parties with access to systems, applications, or data'
priority: medium
assignee: steve
task_status: backlog
project: 01KY4JNC6MPPNNFXN416S398SG
number: 81
---
## Control Objective

Callitech Limited follows a documented methodology to oversee third parties with access to its systems, applications, call recordings, PII, CRM data, or customer content — including telecom carriers, cloud hosting providers, AI-processing/answering-system vendors, and third-party workflow/CRM tools through which APIs are exposed.

## Implementation Guidance

Third-party inventory: A current inventory of all third-party relationships with access to in-scope systems or data is maintained (currently tracked via SharePoint/spreadsheets, transitioning to the Vendor module in the Carbide platform). The inventory identifies the service provided, data/systems accessed, and criticality (e.g., telecom and cloud providers are treated as operationally critical given their role in telephone answering services).Ownership: Pending a dedicated vendor management function, third-party oversight is coordinated by the service desk under the direction of the Head of Infrastructure and Cybersecurity, who is accountable for the methodology's execution.Access control: Access granted to third parties (e.g., support access to telecom/cloud platforms, integrations with workflow tools) is restricted to authorized individuals and systems, with multi-factor authentication and privileged access controls applied to any third-party or vendor-facing accounts.Contracting: Agreements and, where personal data is processed, data processing terms are put in place with vendors prior to onboarding, reflecting Callitech's security and privacy requirements (including GDPR obligations, confidentiality of call recordings and customer content, and, where relevant to a client engagement, HIPAA or PCI DSS flow-down terms).Due diligence and onboarding: Risk-based due diligence is performed before onboarding a third party and at defined intervals thereafter, informed by the criticality tiering in the inventory (see the related third-party risk assessment control).Software and data integrity: Software, updates, or data received from third-party sources (e.g., workflow tool or AI-vendor releases integrated into Callitech's environment) are validated through reasonable means (e.g., use of vendor-published release notes, staged rollout, or verification checks) before deployment.Communication: Communication channels are maintained with critical suppliers (telecom and cloud providers, key platform vendors) so that changes affecting service availability, security posture, or compliance are shared in both directions, and so Callitech can communicate its own requirements, incidents, or concerns to these parties.

## Evidence Request

Use the Vendor module within the Carbide Platform. Evidence should demonstrate that the third-party management methodology is in place and being followed, including:

Current third-party/vendor inventory with criticality tieringSample vendor contracts or data processing terms showing security/privacy requirementsRecords of due diligence performed at onboarding and periodically thereafterEvidence of access controls (e.g., MFA, privileged access) applied to third-party accessExamples of communication with critical suppliers (e.g., status updates, security notices, incident coordination)
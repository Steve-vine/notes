---
id: 01M1YC75D80KENJMBWB2VZ9X18
created: 2026-09-07T16:46:27.752422Z
updated: 2026-09-07T16:46:27.752422Z
type: task
title: 'IAM1: Access Control and Identity Lifecycle Management'
priority: medium
assignee: steve
task_status: backlog
project: 01KY4JNC6MPPNNFXN416S398SG
number: 56
---
## Control Objective

Callitech Limited implements and maintains a structured access control system to regulate and monitor access to systems and data across its UK (Wrexham) and US (Atlanta, Florida) operations, ensuring access to PII, call recordings, CRM data, customer content, and other protected assets is granted on a least-privilege, need-to-know basis and is authorized, modified, and removed in a controlled and auditable manner.

## Implementation Guidance

Access assignment and role management

Access to production systems, cloud infrastructure, CRM platforms, telephony/call recording systems, and AI-based answering platforms is assigned based on job function and business need, following role-based principles rather than ad hoc grants.New access, and changes to existing access (e.g., promotions, transfers, or expanded responsibilities), requires documented approval from the employee's manager and/or the relevant system owner (e.g., the Head of Infrastructure and Cybersecurity or service desk lead) before provisioning occurs.Where full separation of duties is limited by team size (IT, infrastructure, and security functions are consolidated under a single leadership structure), Callitech mitigates this through mandatory second-person approval for access grants, changes, and removals, and periodic independent review of access assigned to privileged/administrative accounts.Access rights are reviewed on a regular, defined cadence (at minimum annually, and following significant role changes) to confirm they remain appropriate; identified discrepancies are remediated and tracked to closure.

Authentication and credential security

Multi-factor authentication (MFA) is required for privileged/administrative accounts, remote access into corporate and production environments, and access to systems containing sensitive customer or employee data (PII, call recordings, CRM records).Default credentials on systems and devices are changed as part of setup/onboarding.Password requirements (complexity, length, and secure storage) are enforced for accounts not otherwise protected by SSO/MFA, and credentials are not shared between users.

Account lifecycle management (joiner/mover/leaver)

Account creation, modification, and deactivation follow Callitech's joiner-mover-leaver (JML) process, with provisioning and de-provisioning requests initiated by HR/managers and executed by the service desk.User system credentials and access are removed or disabled promptly upon termination or when access is no longer required for the individual's role, across UK and US locations and all in-scope systems (including cloud-hosted and third-party platforms).The service desk periodically reviews active accounts to identify and remove inactive, orphaned, or otherwise unnecessary accounts, including accounts for contractors and satellite office (Florida) staff.

Remote access and single sign-on

Given Callitech's distributed footprint (Wrexham, Atlanta, and Florida) and cloud-hosted systems (EU and US), remote access to corporate and production environments is secured using encrypted connections, and combined with MFA.Where single sign-on (SSO) is implemented, it is used to centralize authentication and simplify credential management for supported applications, and is paired with MFA rather than used as a standalone control.Remote access activity is monitored by the service desk/infrastructure team to identify anomalous or unauthorized use.

Monitoring and auditing

The Head of Infrastructure and Cybersecurity (or delegate) periodically audits access rights, authentication configurations, and account lifecycle records to confirm the above practices are being followed consistently across UK and US operations.Access-related logs and audit trails are retained to support incident investigation and compliance reporting.

## Evidence Request

Access control and account lifecycle (JML) policies/procedures.Records of access approval requests (grants, modifications, removals) including approver identity.Most recent access review records/reports, including identified exceptions and remediation.Evidence of MFA enforcement for privileged, remote, and sensitive-system access.Termination/deactivation records showing timely removal of access.Remote access and, if applicable, SSO configuration or logs.List of privileged/administrative accounts and periodic review evidence.
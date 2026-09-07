---
id: 01M1YCCYVFFFDQNTP09MRRSZ6S
created: 2026-09-07T16:49:37.647858Z
updated: 2026-09-07T16:49:37.647858Z
type: task
title: 'PS1: Security measures are implemented to protect sensitive areas and critical equipment from unauthorized access and physical or logical threats that could impact their confidentiality, integrity, or availability (CIA triad)'
priority: medium
assignee: steve
task_status: backlog
project: 01KY4JNC6MPPNNFXN416S398SG
number: 71
---
## Control Objective

Callitech Limited restricts physical access to sensitive areas and critical equipment — including any on-premises network/comms rooms, server racks, and telecom equipment located at its Wrexham (UK), Atlanta (US), and Florida (US) offices — to authorized personnel only, in order to protect the confidentiality, integrity, and availability of employee PII, CRM data, call recordings, and customer content processed by the organization.

## Implementation Guidance

Access to office premises and any internal areas housing network equipment, telecom infrastructure, or local servers (e.g., comms/IT rooms) is restricted using badge/key access, locked doors, or equivalent physical access controls, limited to personnel with a documented business need.Visitor access to restricted areas is logged and supervised.Where surveillance capabilities (e.g., CCTV) or alarm/intrusion detection systems are in place at office locations, they are used to monitor and record access to sensitive areas, and any incidents are reviewed by the Head of Infrastructure and Cybersecurity or delegate.Access lists for restricted areas are periodically reviewed to ensure they remain limited to current authorized personnel, with removal of access upon role change or termination as part of the joiner/mover/leaver (JML) process.Basic environmental protections (e.g., temperature control, fire suppression/detection, power backup where applicable) are maintained for any locally hosted equipment to reduce the risk of damage or outage.Because Callitech's core production workloads (application hosting, cloud infrastructure, identity, and communications systems) are hosted with third-party cloud and telecom providers rather than in a Callitech-operated data center, the physical security of those environments is addressed through vendor due diligence — reviewing provider SOC 2, ISO 27001, or equivalent attestations as part of onboarding and periodic reassessment — rather than through direct physical controls managed by Callitech. This vendor review is tracked manually pending implementation of a dedicated vendor/GRC management tool.Any logical controls protecting building or utility systems that are integrated with IT networks (e.g., building access control systems on the corporate network) are segmented and access-restricted consistent with standard network access control practices.Physical security arrangements are reviewed periodically (e.g., annually or upon significant change to office footprint) by the Head of Infrastructure and Cybersecurity to confirm they remain adequate as the organization grows.

## Evidence Request

Documentation or description of physical access control mechanisms at each office location (Wrexham, Atlanta, Florida).Access lists / logs for restricted areas (e.g., comms rooms) and evidence of periodic review.CCTV or alarm system records, where such systems are deployed.Evidence of third-party cloud/telecom provider security attestations (SOC 2, ISO 27001, or equivalent) reviewed as part of vendor due diligence.Records of any physical security review or update performed by the Head of Infrastructure and Cybersecurity.
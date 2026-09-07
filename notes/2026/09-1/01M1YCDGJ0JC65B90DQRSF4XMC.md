---
id: 01M1YCDGJ0JC65B90DQRSF4XMC
created: 2026-09-07T16:49:55.776744Z
updated: 2026-09-07T16:49:55.776744Z
type: task
title: 'RM1: Threat and risk management methodology drives risk-based control selection'
priority: medium
assignee: steve
task_status: backlog
project: 01KY4JNC6MPPNNFXN416S398SG
number: 72
---
## Control Objective

Callitech Limited maintains a threat and risk management methodology that integrates proactive threat detection, risk assessment, and risk-based selection and development of control activities — including general control activities over technology — tailored to its operating environment as a telephone answering (TAS) and live chat service provider handling employee and customer PII, call recordings, CRM data, and customer content across its Wrexham (UK), Atlanta (US), and Florida (US) offices.

Ownership

The Head of Infrastructure and Cybersecurity owns this methodology, working with the service desk, DevOps, and infrastructure teams who operate and monitor the organization's mission-critical systems (telephone answering platform, AI-based answering systems, cloud infrastructure, identity systems, and communications platforms) and the third-party telecom and cloud providers these depend on.

## Implementation Guidance

Proactive threat detection

Infrastructure, cloud, identity, and communications systems supporting TAS and the AI-based answering platform are monitored on an ongoing basis for indicators of malicious activity, service degradation, and anomalous behavior, using the monitoring, logging, and vulnerability scanning capabilities available to the infrastructure and DevOps teams.Growth-driven changes to the AI-based answering systems (new features, scaling changes, new integrations) are reviewed for emerging threats as they are introduced.

Risk assessment of changes

Significant changes — adoption of new technology (e.g., expansion of the AI-based answering platform), organizational growth, new office locations, new client requirements (e.g., HIPAA obligations or PCI DSS self-certification scope), and regulatory changes affecting UK or US operations — are evaluated for their potential impact on the system of internal control before and after implementation.Outcomes of this evaluation feed into the formal risk assessment process (see the related risk assessment control) and into decisions about which controls need to change.

Risk-based control selection

Control activities, including general controls over technology (access management, change management, configuration management, network segmentation, and encryption of data in transit/at rest for PII, call recordings, and customer content), are prioritized according to the risk they mitigate to Callitech's most critical systems: the TAS platform, cloud infrastructure, identity systems, and communications systems.Because Callitech does not currently operate a dedicated GRC platform, control selection decisions, rationale, and review outcomes are documented manually (e.g., in shared documentation/spreadsheets) until tooling such as Carbide is fully adopted for this purpose.

Control activity mix and segregation of duties

Mix and level of control activities

When selecting controls to mitigate an identified risk, the Head of Infrastructure and Cybersecurity considers a balanced mix of control activity types: preventive controls (e.g., access restrictions, approval gates, encryption of PII, call recordings and customer content) and detective controls (e.g., logging, monitoring alerts, vulnerability scans, access reviews), and automated controls (e.g., platform-enforced configuration and identity controls) versus manual controls (e.g., documented reviews and approvals).The level at which each control is applied is determined as part of selection — entity-wide (policy, awareness, identity platform), business-process (service desk call handling, live chat, CRM data handling), or transaction/system level (TAS platform, AI-based answering systems, cloud infrastructure) — so that reliance is not placed solely on high-level controls where risk is concentrated in a specific system or process.

Segregation of duties

Control selection explicitly considers segregation of incompatible duties, including separation between: development and deployment to production; request/approval and provisioning of access to systems holding PII, call recordings and CRM data; and administration of a system and independent review of its logs.Where Callitech's team sizes in Wrexham, Atlanta and Florida make full segregation impractical, the segregation limitation is recorded and compensating controls are selected instead (e.g., independent management review of activity by an administrator, peer review of changes, or additional logging and alerting), together with the accountable reviewer and the review frequency.Segregation of duties conflicts and their compensating controls are re-examined whenever roles change, headcount changes, or a significant change is evaluated under the risk assessment of changes described above, and the outcome is documented alongside the control selection rationale.

## Evidence Request

Records of identified changes and their risk evaluation, documentation of control selection rationale tied to identified risks, and evidence of monitoring/detection activity (e.g., monitoring alerts, vulnerability scan results, change records) for critical systems.
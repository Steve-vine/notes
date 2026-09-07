---
id: 01M1YC18E4VZBV931DZEWS7B5D
created: 2026-09-07T16:43:14.244466Z
updated: 2026-09-07T16:43:14.244466Z
type: task
title: 'CNS5: Intrusion detection and prevention systems for network traffic monitoring'
priority: medium
assignee: steve
task_status: backlog
project: 01KY4JNC6MPPNNFXN416S398SG
number: 37
---
## Control Objective

Callitech Limited implements intrusion detection and prevention systems (IDPS) to continuously monitor network traffic across its office and cloud environments, detecting unauthorized access attempts and preventing misuse, modification, or denial of resources supporting telephone answering, live chat, and AI-based answering services.

## Implementation Guidance

IDPS capabilities are deployed at critical network and cloud boundary points to monitor traffic to and from mission-critical systems, including TAS infrastructure, cloud environments, and identity/communications systems.Alerting is configured for high-risk indicators such as repeated failed authentication attempts, unusual data transfer volumes, or anomalous traffic patterns involving third-party telecom or cloud provider connections.IDPS alerts are reviewed by the Infrastructure and Cybersecurity team, with escalation to incident response procedures where warranted.IDPS signatures and detection rules are updated regularly to address emerging threats relevant to the organization's cloud-hosted, multi-region environment.The effectiveness of IDPS configuration is periodically tested and tuned based on findings.

## Evidence Request

IDPS configuration and rule set evidence.Sample of IDPS alerts/logs generated during the review period.Evidence of periodic testing or tuning of IDPS configuration.
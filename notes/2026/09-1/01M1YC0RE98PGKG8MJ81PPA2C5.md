---
id: 01M1YC0RE98PGKG8MJ81PPA2C5
created: 2026-09-07T16:42:57.865364Z
updated: 2026-09-07T16:42:57.865364Z
type: task
title: 'CNS16: Encrypted traffic visibility and malicious software prevention at the network boundary'
priority: medium
assignee: steve
task_status: backlog
project: 01KY4JNC6MPPNNFXN416S398SG
number: 35
---
## Control Objective

Callitech Limited establishes mechanisms to gain visibility into encrypted communications entering and leaving its network and cloud environments, and to detect and prevent the introduction of unauthorized or malicious software carried over network traffic.

## Implementation Guidance

Given that call recordings, PII, CRM data, and customer content transit between UK/US office locations, EU/US-hosted cloud infrastructure, and third-party telecom/cloud providers, encrypted network traffic at key gateways is decrypted and inspected (where legally and technically permitted) to identify threats, policy violations, or unauthorized data movement.Decryption and inspection capabilities are restricted to authorized Infrastructure and Cybersecurity personnel, and configuration/policy for what traffic is inspected is documented and reviewed periodically to align with privacy obligations (GDPR) and client contractual requirements (including HIPAA-in-scope clients).Network gateway/proxy inspection is configured to identify known malicious content, signatures, or behavior within inspected traffic, generating alerts for suspicious patterns that may indicate malware introduction or data exfiltration.Alerts from encrypted traffic inspection are reviewed and, where warranted, escalated through the organization's incident response process.Inspection policies and rule sets are reviewed periodically and updated as threats, regulatory obligations, or business systems (e.g., AI-based answering platforms) evolve.

## Evidence Request

Configuration or dashboard evidence of the decryption/inspection tooling in active use at network gateways.A sample of alerts generated from encrypted traffic inspection (with sensitive content masked as needed).Documentation of access restrictions limiting who can configure or view decrypted traffic.Record of periodic review of inspection policy.
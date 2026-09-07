---
id: 01M1YCF609W9PCBC31GJD731WD
created: 2026-09-07T16:50:50.505835Z
updated: 2026-09-07T16:50:50.505835Z
type: task
title: 'SSD4: Dedicated testing environments for quality assurance (QA), user acceptance testing (UAT), and pre-deployment activities are established and maintained to ensure software quality and security'
priority: medium
assignee: steve
task_status: backlog
project: 01KY4JNC6MPPNNFXN416S398SG
number: 77
---
## Control Objective

Callitech Limited maintains dedicated development, staging, and user acceptance testing (UAT) environments, separate from production, to support quality assurance and pre-deployment validation of changes to its telephone answering, live chat, CRM integration, and AI-based answering platforms.

## Implementation Guidance

Development, staging, and UAT environments are maintained as distinct, logically separated environments from the production systems that process live PII, call recordings, CRM data, and customer content.Access to non-production environments is restricted to authorized development, QA, and DevOps personnel.Where test data resembling production data is needed (e.g., for the databases in use — MySQL, MongoDB, PostgreSQL, SQL Server), sanitized or synthetic data is used in preference to live customer or call data wherever practicable.Staging and UAT environments are used to validate changes under conditions that approximate production before release, reducing the risk of defects or security issues reaching live systems supporting mission-critical telephone answering services.Environment configurations are periodically reviewed against production to identify and correct drift.

## Evidence Request

Description or diagram showing separation of development, staging, UAT, and production environments.Access control listing or configuration showing restricted access to non-production environments.Examples of sanitized/synthetic test data usage, where applicable.Records showing use of staging/UAT for recent pre-deployment validation.
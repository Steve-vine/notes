---
id: 01M1YC02GGDBBAAB7XWCBDMP53
created: 2026-09-07T16:42:35.408392Z
updated: 2026-09-07T16:42:35.408392Z
type: task
title: 'BCIM4: System backups and backup restoration testing'
priority: medium
assignee: steve
task_status: backlog
project: 01KY4JNC6MPPNNFXN416S398SG
number: 33
---
## Control Objective

Callitech Limited performs regular backups of critical systems and data to safeguard against data loss and support business continuity, and periodically tests the ability to restore from those backups.

## Implementation Guidance

Critical systems and data — including CRM data, call recordings, customer content, and supporting infrastructure for the telephone answering and live chat services hosted across Callitech's EU and US environments — are backed up on a defined schedule appropriate to their criticality. Backup copies are stored so that they are logically or physically isolated from the primary production environment (for example, in a separate storage location, account, or region, or on media disconnected from the network) to reduce the risk that a single event — such as a cyberattack, misconfiguration, or system failure — could compromise both production data and its backups. Access to backup data is restricted to authorized personnel.

Backup restoration is tested periodically to confirm that critical data and configurations can be successfully restored within an acceptable timeframe, and results (including any issues found and corrective actions taken) are documented and used to improve the backup process.

## Evidence Request

Provide documentation showing:

Critical systems and data identified for backup, together with their backup frequency and method.Backup configuration records (e.g., screenshots/logs from backup tooling) showing scheduled jobs, storage location, and access controls.Records of the most recent backup restoration test, including scope, results, and any corrective actions.
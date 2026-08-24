---
id: 01M0TGSJ6H5NHNYK7AJATTTWXH
created: 2026-08-24T18:33:45.425924Z
updated: 2026-08-24T18:33:45.425924Z
type: task
title: 'Module: Continuous control modeling'
assignee: steve
priority: medium
sprint: sol7xb5
task_status: backlog
project: 01M0T7Z3W00Z3H5DQ07H4SS47M
number: 13
---
automated evidence. This is what separates Drata-class platforms from trackers: integrations that test controls automatically ("MFA enforced?", "stale accounts?", "backups ran?"). Access Control quietly builds your first one — the Entra mirror can answer MFA coverage, dormant accounts, privileged-group membership as scheduled checks that auto-update assessment evidence or raise gaps. Start there, add checks per integration (M365 Secure Score, your k8s cluster, backup jobs). Design the "check → evidence/gap" contract once, in an ADR, like the email-transport contract.
Posture over time. You have append-only assessment/risk revisions — there's an untapped time-series in the database. Maturity and coverage trend charts, "what changed this quarter" digests for management. Read-only, no new writes, high perceived value.
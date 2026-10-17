---
id: 01M54KBHACTXED5FXGB0QDW92H
created: 2026-10-17T09:33:43.116342Z
updated: 2026-10-17T09:33:50.169562Z
type: task
title: Start from the standard plan — one click lays out a typical SOC 2 / ISO 27001 year of security work, each activity repeating and already linked to its controls, all editable
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1057
sprint: sxflvhs
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Sprint 75, SAP - Schedule (ADR in COM-1041; suggestion 7). Built on COM-1046 (repeats) and COM-1050 (control links).

## What people see

- On an empty plan, the Schedule shows **Start from the standard plan** next to Add entry. It stays in the page's menu afterwards for anyone with `sap.manage_plan`.
- It opens a window listing the standard activities, each with its type, how often it repeats, a suggested month, and the controls it will link to. Everything is ticked by default; untick what you don't want. Pick the **first month** the plan starts from, then pick an **owner** for each activity (or one owner for all, to change later).
- The standard set (the builder confirms each control with Steve in the PR):

| Activity | Type | Repeats | Links (to confirm) |
|---|---|---|---|
| Security awareness training | Training | Yearly | SEA.1 |
| Phishing simulation | Training | Quarterly | SEA.2 |
| Role-specific security training | Training | Yearly | SEA.9 |
| External penetration test | Testing | Yearly | the pen-testing control |
| Vulnerability scan review | Testing | Monthly | the vulnerability-management control |
| Backup restore test | Testing | Every 6 months | the backup control |
| Disaster recovery / BCP exercise | Testing | Yearly | the continuity-testing control |
| Incident response tabletop | Testing | Yearly | the incident-response control |
| Access review | Review | Quarterly | the access-review control |
| Risk assessment review | Review | Yearly | RIM.2 |
| Policy review | Review | Yearly | the policy-review control |
| Supplier security review | Review | Yearly | s42.VEM.7 |
| Internal audit | Audit | Yearly | INA.2 |
| Management review | Review | Yearly | INS.13 |

- **Add to plan** creates those entries (as repeating series), linked and laid out a year ahead, and opens the Schedule. Each is an ordinary entry from then on.

## Rules

- Running it on a plan that already has entries warns "your plan already has 12 entries; these will be added alongside". It never replaces or merges.
- It is in Activity as one action ("added 14 entries from the standard plan").

## Notes (technical)

- The standard set is data (`data/sap/standard-plan.csv`), not code: title, type, cadence, suggested month, description and control keys. Load the controls by key and fail loudly in a test if any key doesn't exist in `controls.csv`, so a library change can't silently drop a link. Don't open the licensed framework PDFs to choose controls (sprint 66 rule); work from the mappings.
- One transaction: all or nothing.

**Done when:** the standard plan can be added (all or some, with owners and a start month), arriving as linked, repeating entries, with a test pinning every control key.
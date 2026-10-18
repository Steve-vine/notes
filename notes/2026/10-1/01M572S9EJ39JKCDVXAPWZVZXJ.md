---
id: 01M572S9EJ39JKCDVXAPWZVZXJ
created: 2026-10-18T08:41:51.314258Z
updated: 2026-10-18T13:03:09.001202Z
type: task
title: An AI incident names the AI system and what went wrong — harmful output, material error, bias, drift, misuse — and records whether the people affected were told; Inventory can mark a technology asset as an AI system
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1072
sprint: serbigk
blocked_by:
- 01M572R2V4X8RKBMXYFRQJ4E4B
assignee: steve
label:
- feature
priority: high
task_status: active
---
Sprint 76, Incidents - Register (ADR in COM-1063). Builds on COM-1069. It answers ISO 42001 A.8.4, AIG.16 and 10.2.

## What people see

**Inventory**: a technology asset gains an **"AI system"** switch, with an optional note on what the AI does ("drafts customer replies", "scores leads").
- The Technology register can filter to AI systems.
- Nothing else in Inventory changes.

**AI** section on the incident, shown when a category brings it:
- **The AI system**, picked from the company's AI systems in Inventory, or typed if it isn't registered (a supplier's model, say). An unregistered one shows "not in Inventory".
- **What went wrong**: harmful or inappropriate output, material error, unfair or biased outcome, drift or performance degradation, misuse, data or privacy issue, other. Several can apply.
- **Who was affected**: customers, employees, the public, other, with a description.
- **What was done to the system**: none, guardrail changed, retrained or reconfigured, rolled back, suspended, withdrawn.
- **People affected told?** Yes (when, how) / No (why) / Not applicable. A "yes" also adds a notification row (COM-1071) so it is decided like the others.
- **Supplier involved?** If the AI comes from a vendor, link it (COM-1069), and record whether the supplier was told.

## Rules

- AI incidents always need a post-incident review (Rubrics default, COM-1064).
- The AI system's page in Inventory lists its incidents.

**Done when:** assets can be marked as AI systems; the AI section records the system, failure, affected people and action; telling people affected is recorded as a notification.
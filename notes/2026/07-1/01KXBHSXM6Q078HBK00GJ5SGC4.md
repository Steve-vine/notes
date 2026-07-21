---
id: 01KXBHSXM6Q078HBK00GJ5SGC4
created: 2026-07-12T16:15:43.750952389Z
updated: 2026-07-21T09:53:46.454356Z
type: task
title: ProposedChange state machine + API
project: 01KX671DATY39VW6GWK3M2T3DN
number: 48
sprint: sdcd2jr
blocked_by:
- 01KXBHSKPWP680MMG29TNA9ANH
assignee: steve
label: null
priority: high
task_status: done
---
THE HEART OF THE SPRINT. ADR 0016 names the approval state machine the top testing priority in the product.

The ProposedChange table already exists in full (models.py:237-256, migration 0002) — no migration needed. CHANGE_STATUSES = proposed, awaiting_approval, approved, rejected, executed, failed.

Service layer: create a proposal — the operation must exist in the connector's catalogue, parameters validated (ISE-46), tier resolved by policy (ISE-47) — then the transitions.

SEPARATION OF DUTIES, enforced in the state machine, not by convention (ADR 0017 / security-model brief): for T2/T3, decided_by != proposed_by. An admin self-approving is PERMITTED but audited DISTINCTLY as such. Not implemented anywhere today — no code compares proposer to approver.

API: GET /proposed-changes (filters: system, status, tier), GET /{id}, POST /proposed-changes (operator — manual proposal), POST /{id}/approve (ApproverUser — its FIRST real use; the role exists at rbac.py:47 but no route uses it), POST /{id}/reject (comment REQUIRED).

Every transition audited in the same transaction (audit.record never commits — it joins the caller's transaction, so the change and its audit row are atomic).

Tests: exhaustive. Every legal AND illegal transition, self-approval blocked at T2/T3, admin self-approval allowed-but-audited, policy-raised tiers, protected-target refusal.
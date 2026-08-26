---
id: 01M101XTAR3PD4WDR95CGCMD3N
created: 2026-08-26T22:09:22.776267Z
updated: 2026-08-26T22:09:22.776267Z
type: task
title: Every membership remembers where it came from — provenance, and 1,500 users who start unattributed
assignee: steve
company: moneypenny
label: feature
priority: high
task_status: backlog
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 447
---
The keystone of COM-446, and the first thing built — everything else in the sprint is unsafe without it.

Compass reads membership from live Entra state, which cannot tell someone in Finance Approvers *because they are an Accounts Payable Clerk* from someone in Finance Approvers *because somebody asked in March*. Both are just membership. Build exceptions before provenance exists and the first mover to run silently deletes every exception ever granted.

## What changes

Nothing on screen yet. Compass gains a record of **why** each governed membership exists.

## Scope

**Three provenance values, and the third matters as much as the other two:**

- **role-derived** — the person holds a business role that grants this group
- **exception** — approved through a request, with the requester, approver and reason attached
- **unattributed** — true before Compass governed it, and nobody has yet said why

Keep unattributed and exception firmly apart. An exception was decided; unattributed was inherited. Collapse them and you lose the ability to tell access somebody reviewed from access nobody has ever looked at — which is the whole point of the record.

**Where it lives.** A membership fact per (directory user or group, directory group) that Compass governs, carrying its provenance, its source (which business role, or which request), and when it was attributed. Existing patterns: company-scoped, audited, ADR 0015 mixins.

**Reconciliation on sync.** The mirror is the truth about *what* the memberships are; this record is the truth about *why*. A membership that appears in the mirror with no record becomes **unattributed** — that is the backfill and the steady state, not a special case. A membership that disappears takes its record with it.

**Execution writes provenance.** Every `_add_member` in `tasks/access_execute.py` already knows why it is adding — a joiner's roles, a mover's new role set, a recert removal. Stamp it at the point of the write rather than inferring it afterwards.

**The number.** A count of explained vs unattributed membership, per company. It is the metric that makes anyone finish the migration and the thing an auditor wants to see moving. Expose it on the API here; COM-4xx (the coverage tool) puts it on the dashboard.

## The migration

No backfill script that guesses. Every existing membership lands as **unattributed** on the first sync after deploy, and that is the correct answer — 1,500 users with no history is the honest launch state, drained later by the coverage tool and recertification.

## Tests

Integration tests against real Postgres: a membership gains a record on first sync as unattributed; an executed joiner writes role-derived; a membership vanishing from the mirror takes its record; a re-run of the sync creates nothing new. Plus the count endpoint over a mixed set.
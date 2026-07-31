---
id: 01KYW2QXZM12V16RYKSA5XA5FP
created: 2026-07-31T12:35:17.108504Z
updated: 2026-07-31T12:36:08.844689Z
type: task
title: Docs skeleton — getting started, concepts, integrations, security
project: 01KX671DATY39VW6GWK3M2T3DN
number: 406
sprint: sp3en5k
blocked_by:
- 01KYW2Q2N03YTZX0VEAMZAKN9N
assignee: steve
label:
- feature
priority: medium
task_status: backlog
---
Starlight sidebar structure plus stub pages (frontmatter + short operator-facing summary + TODO markers):

- **Getting started** — what ISE is, requirements, **installation**, **upgrading**.
- **Concepts** — the core loop, signals & incidents, the estate & knowledge base, tiered actions & approvals, playbooks.
- **Integrations** — one stub per released connector: DataDog, Kubernetes, AWS, Azure, Cloudflare, EntraID, M365, webhooks.
- **Security & governance** — roles, approval tiers, audit trail.

Written for operators, not copied from ADRs/briefs; document only released capability (what is on `main` in the app repo).

Depends on ISE-403.
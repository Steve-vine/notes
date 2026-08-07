---
id: 01KYW2QXZM12V16RYKSA5XA5FP
created: 2026-07-31T12:35:17.108504Z
updated: 2026-08-07T10:38:01.849602Z
type: task
title: Docs skeleton — getting started, concepts, integrations, security
project: 01KX671DATY39VW6GWK3M2T3DN
number: 406
sprint: sp3en5k
blocked_by:
- 01KYW2Q2N03YTZX0VEAMZAKN9N
comments:
- id: 01KYW4HJBC3G8BJQ0DVJ3JH8QY
  author: Steve Vine
  at: 2026-07-31T13:06:45.740019Z
  text: |-
    Done on feature/ise-406-docs-skeleton (PR #3 → main, squash-merged).

    16 stub pages in four sidebar groups: Getting started (introduction, installation, upgrading), Concepts (core loop, signals & incidents, estate, actions & approvals, playbooks), Integrations (DataDog, Kubernetes, AWS, Azure, Cloudflare, Entra ID, M365, webhooks — all released connectors), Security & governance (roles & access, audit trail). Each page: frontmatter, a short accurate operator-facing summary, a visible "stub" note, and TODO comments for authors. Template example pages removed; hero CTA now points at /getting-started/introduction/. 20 pages build, search index included.

    Note: did this before ISE-405 so the landing page can link to real docs slugs.
assignee: steve
label: null
priority: medium
task_status: done
---
Starlight sidebar structure plus stub pages (frontmatter + short operator-facing summary + TODO markers):

- **Getting started** — what ISE is, requirements, **installation**, **upgrading**.
- **Concepts** — the core loop, signals & incidents, the estate & knowledge base, tiered actions & approvals, playbooks.
- **Integrations** — one stub per released connector: DataDog, Kubernetes, AWS, Azure, Cloudflare, EntraID, M365, webhooks.
- **Security & governance** — roles, approval tiers, audit trail.

Written for operators, not copied from ADRs/briefs; document only released capability (what is on `main` in the app repo).

Depends on ISE-403.
---
id: 01KZVEPMVRWPQX3KW5KBXC7DHE
created: 2026-08-12T17:00:45.30413Z
updated: 2026-08-12T17:00:45.30413Z
type: task
title: Brief 113 — Declared Scope store (company-scoped) + tags; retire Target
task_status: done
assignee: steve
label:
- brief
- feature
imported_from: linear
priority: medium
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 260
---
First brief in the ADR-037 sequence (milestone "Resolve asset DB conflicts").

Stand up **Declared Scope** as a company-scoped, **tagged** operator feed, retiring the vestigial project-scoped `Target`.

Grounding: a `targets` table from Phase 1 already has the core shape (kind domain/ip_range/cidr/url, value, enabled, description, company_id via TenantMixin) but is project-scoped (the duplication problem) and vestigial-for-selection (nothing in …

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-384](https://linear.app/stevevine/issue/DEV-384/brief-113-declared-scope-store-company-scoped-tags-retire-target)
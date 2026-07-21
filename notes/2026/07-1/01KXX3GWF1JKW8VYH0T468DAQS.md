---
id: 01KXX3GWF1JKW8VYH0T468DAQS
created: 2026-07-19T11:52:27.361492341Z
updated: 2026-07-21T18:32:17.807917Z
type: task
title: Estate UI — the pane of glass for the knowledge base
project: 01KX671DATY39VW6GWK3M2T3DN
number: 132
sprint: sp5m61e
assignee: steve
label: null
priority: high
task_status: done
---
**Sprint 12 (the missing pane of glass).** ISE-125…131 shipped the Estate Knowledge Base as models + APIs + AI tools with **no screen** — this closes that gap and is the reason the "Definition of done — ship the pane of glass" rule was added to CLAUDE.md.

- **Estate** nav section (left nav; the IA already shows placeholders for the unbuilt).
- **Estate list** — entities filtered by type + name search, alias counts.
- **Entity detail** — integration aliases (provenance), context annotations (operator can add/remove — the Enrich write class), linked signals (the join key), and a visual **dependency graph** off `/entities/{id}/graph` (blast-radius traversal).
- Read for everyone; enrichment actions gated to operator.

Consumes only the ISE-125…131 API. Vertical-slice completion of Sprint 12.
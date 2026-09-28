---
id: 01M3MYK5WYQM3T4VEZD5Q554XY
created: 2026-09-28T21:26:35.166822Z
updated: 2026-09-28T21:27:06.118245Z
type: task
title: 'Website: Pricing page — needs the Personal / Pro decision first'
project: 01KY6W9951TW0904DT0GGJVGE7
number: 487
sprint: spqrtwg
blocked_by:
- 01M3MY1APNGC5GRXYGCCWJJ9T3
assignee: steve
label:
- brief
priority: medium
task_status: backlog
tech: null
---
The design's Pricing page, "Free to write. Pay if you sync.": **Personal £0 forever** and **Pro £4 per month**, with a pricing FAQ.

## Decision needed first (Steve)

The design puts Git sync, the MCP server, the HTTP API, scheduled tasks and early access behind Pro. The app today has no licence, payment or feature gating, and all of those features are free. The page can't go live until one of these is true:

- **Pro is real:** payment and licensing exist, and the app enforces them. That is app work, and it needs its own ADR in the app repo.
- **Pro is announced but not yet charged**, e.g. "Pro — coming soon", with everything free until then.
- **No Pricing page for launch:** remove it from the header, and drop the "Pay if you sync" framing.

The home page ("Free · No account"), the FAQ ("Is it free?", "What happens if I stop paying?"), the Features page and the docs all follow from this decision.

## Scope (once decided)

- [ ] The two plan cards, feature lists and pricing FAQ from the design, reflecting the decision.

**Done when:** the page states only what a visitor can actually buy today.
---
id: 01KZVEP9Q91VMN0T0SJSYQ5P5Y
created: 2026-08-12T17:00:33.89757Z
updated: 2026-08-12T17:01:41.192672Z
type: task
title: 'Scope tags-input: dropdown always visible; tags not lower-cased'
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 258
sprint: sv10nf2
assignee: steve
imported_from: linear
label:
- bug
priority: null
task_status: done
---
Two UI/data-quality bugs on the Scope feature shipped in DEV-384 (`features/scope/tags-input.tsx` + Scope create/update path).

**Finding 1 — suggestion dropdown always visible.** `showList` is driven solely by `matches.length > 0` (no focus condition), so the autocomplete lis…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-388](https://linear.app/stevevine/issue/DEV-388/scope-tags-input-dropdown-always-visible-tags-not-lower-cased) · parent DEV-384
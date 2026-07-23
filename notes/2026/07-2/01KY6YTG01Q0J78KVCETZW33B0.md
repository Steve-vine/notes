---
id: 01KY6YTG01Q0J78KVCETZW33B0
created: 2026-07-23T07:42:43.713952Z
updated: 2026-07-23T11:04:50.863617Z
type: task
title: 'Theme foundation: design tokens + light/dark/system selector'
number: 61
assignee: steve
imported_from: linear
task_status: done
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
sprint: sr2wq8c
---
The base for M8. Replace the ad-hoc styling with a **design-token theme** and a **light / dark / system** selector in **Settings**.

Today: dark mode is OS-driven via `prefers-color-scheme` duplicated across 7 components; the accent `#396cd8` is hardcoded ~33×; popover/grey colours are copy-pasted. There's no global stylesheet or theme.

**Checklist**

- [ ] Central **design tokens** as CSS variables (`--accent`, `--bg`, `--surface`, `--text`, `--muted`, `--border`, radius/spacing/typography) on `:root`, with a `[data-theme="dark"]` override set. Light + dark palettes.
- [ ] **Theme-dependent accent:** a **darker blue** in light, a **lighter blue** in dark (per design call).
- [ ] **Theme store + selector in Settings:** `light / dark / system`. `system` follows `prefers-color-scheme`; explicit choices set `data-theme` on the root. Persist the choice and **apply it in both windows** (main + capture — same-origin localStorage is shared, or persist in the Rust config).
- [ ] **Migrate components** off `prefers-color-scheme`/hardcoded colours onto the tokens so the toggle works app-wide (no flash; correct on first paint).

Foundation for the Linear restyle and layout-stability issues. Pure styling/theming — no data model or ADR change (additive on ADR 0008).

---

Linear DEV-593 · M8 - Styling · created 2026-06-23 · done 2026-06-23
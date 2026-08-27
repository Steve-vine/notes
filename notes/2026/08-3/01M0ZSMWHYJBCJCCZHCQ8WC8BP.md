---
id: 01M0ZSMWHYJBCJCCZHCQ8WC8BP
created: 2026-08-26T19:44:41.534453Z
updated: 2026-08-27T21:20:10.242904Z
type: task
title: Write the two rules down so the next screen is built right — pills never truncate, no subtitles
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 441
sprint: smnkt3k
assignee: steve
company:
- moneypenny
label:
- chore
priority: medium
task_status: active
---
COM-433 fixed truncating pills once; COM-435 has to fix them again. Nothing in the repo says a pill must show its whole label, or that a screen does not get an explanatory line under its heading — so every new screen is free to reintroduce both, and the next sweep is only a matter of time.

## What changes

Not the app. The written rules, so the fix holds without another sweep.

## Scope

There is no design-system or UI-conventions document today — the closest is `brief/information-architecture.md`, which covers navigation and screens but says nothing about how a screen is dressed. Assume a new **Screen conventions** section there unless something better presents itself while writing it, with a pointer from `app/frontend/README.md` and a line in `CLAUDE.md` so it is found without being looked for.

Two rules, stated so someone can apply them without asking:

- **A pill shows its whole label.** No ellipsis, no clipping, no shrinking to fit. Where a pill cannot fit, the layout gives — the column widens, or the table scrolls. Say where the shared rule lives so a new screen inherits it and does not restyle its own.
- **A screen does not explain itself.** No dimmed line under a page title or a tab heading restating what the title already said. Note the one exception the sprint found: text that is the entire body of an empty state ("Select a company to see its gaps.") is content, not a subtitle, and stays.

Last task in the sprint — it records what COM-435 through COM-440 settle, so write it after they land and describe what was actually done, not what was planned.

Not an ADR: neither rule changes the architecture. If writing it turns up a decision that does — a shared pill component, say, or a page-header component every screen must use — that is worth an ADR of its own, raised separately.
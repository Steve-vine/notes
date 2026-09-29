---
id: 01M3Q1JNR2Z6QFHGXFZ37BSNN3
created: 2026-09-29T16:57:13.218253Z
updated: 2026-09-29T16:58:32.53299Z
type: task
title: 'ADR: every page shows the way you came — one trail across sections, replacing the fixed back links'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 786
sprint: svq5edz
assignee: steve
label:
- brief
priority: high
task_status: todo
---
Opens the Breadcrumbs sprint. Steve (2026-09-29): *"Lots of screens have 'cross-links' that take you to other sections, Controls, Content, Risks, Gaps, Decisions etc."* In Domains, pick a domain, then open one of its documents: you're now in Content, and the page shows "← Content". Only the browser's Back button returns you to the domain.

Two options were considered: a breadcrumb trail that works across sections, or opening risks, content and so on in pop-ups. **Steve chose the trail on 2026-09-29, with every section in scope.** The vendor portal is out of scope: it's a separate area for outside users.

## What it settles (what people see)

- **The trail is the way you came, not where a page is filed.** It sits above every page: `Domains › Access control › Password Standard`.
- **Starting a trail.** Choosing from the menu starts a new one. So do searching from the top bar (the results page is the first step), opening a notification, and switching company.
- **Adding a step.** Any link inside a page adds a step. Going to a page that's already in the trail cuts back to it rather than adding it twice.
- **Going back.** Clicking a step returns you to that page as you left it: the same tab, the same place on the page, and (with COM-list-memory) the same filters. The steps after it are dropped.
- **A pop-up is not a step.** The page under it is. A pop-up with its own address can be reopened by the trail.
- **One trail per browser tab.** It survives a refresh. The browser's Back and Forward stay in step with it: Back removes the last step.
- **No trail recorded.** A pasted link, a new tab or a bookmark gets the page's natural home instead (`Content › Password Standard`), which is what today's back link offers.
- **It replaces every fixed "← Section" link.** There are 21 on staff screens.
- **Long trails collapse.** They show the first step, "…", and the last two. The "…" opens the rest.
- **Pop-ups remain the answer for side questions**, under the existing convention. A quick-look preview for small records (risks, gaps) may come later, but not this sprint.

**Why not pop-ups:** documents are long; cross-links chain (document → control → risk), which means stacking or navigating away again; a pop-up has no link you can copy; and every record would need a page version and a pop-up version.

## Notes (technical)

- Write `decisions/0084-*.md`. The IA brief says a shared header element *"is an architecture decision and gets one"* (`brief/information-architecture.md:149-161`), and this ADR is that decision. Also add a Screen conventions entry to the IA brief, e.g. "You can always get back the way you came".
- **Mechanism to record.** The trail is computed centrally in the shell on each navigation and stored in `sessionStorage` under the history entry's `location.key`, so no `<Link>` site changes:
  - PUSH extends the previous entry's trail.
  - REPLACE rewrites the current step's URL, so `useTabParam`'s `replace: true` keeps the tab.
  - POP reads the stored trail for that key, which keeps Back and Forward consistent. `location.key` survives a refresh via `history.state`.
  - Starts (the menu, top-bar search, the bell, the company switch) pass `state: { trail: 'start' }`.
  - Pages name their own step with a hook, because the label is the record's name, not its URL.
  - Rejected alternative: carrying the trail in `location.state` on every link, which would touch hundreds of link sites and still miss `navigate()` calls.
- **Placement.** The trail is one line above the page pane, outside the scroll, so it's always visible. Its height comes out of the rows, as the frozen register head already does (`:223-268`).

**Done when:** the ADR and the IA convention are merged.
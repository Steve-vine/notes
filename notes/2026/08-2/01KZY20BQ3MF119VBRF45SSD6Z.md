---
id: 01KZY20BQ3MF119VBRF45SSD6Z
created: 2026-08-13T17:16:35.427026Z
updated: 2026-08-13T17:16:39.662957Z
type: task
title: Remove the orange badge from the Propose remediation button
project: 01KX671DATY39VW6GWK3M2T3DN
number: 694
sprint: sevhjex
assignee: steve
label:
- improvement
priority: low
task_status: backlog
---
Drop the `rightSection` badge from the Propose remediation button (`app/frontend/src/pages/IssueDetailPage.tsx:713-733`).

It renders a single `!` in a filled orange `Badge` with `circle` and `size="xs"`, shown whenever `diagnosed` is false. Circle mode forces equal width and height on a badge whose padding is sized for text, so at that size the glyph is clipped — it reads as an unexplained orange dot. Reported from staging 2026-08-13: *"I think it says something in this dot but I can't see as it's cut off."*

**No information is lost by removing it.** The meaning lives in the button's tooltip, which is unconditional and already says it in full:

> No diagnosis has run yet, so this will draft from recorded evidence only — Diagnose is the run that can probe the live estate.

The badge was only ever a visual echo of that sentence. It is also `aria-hidden` — deliberately, so `!` cannot leak into the button's accessible name — which means it already carries no text alternative and does not exist for a screen reader. Removing it takes nothing away from anyone.

**Scope**
- Remove the `rightSection` prop and its `Badge`, leaving the `diagnosed` tooltip branch exactly as it is.
- `data-testid="propose-blind"` goes with it — check for tests asserting on that id and drop or repoint them.
- `diagnosed` may become unused for the badge but is still needed to pick the tooltip text; do not remove it.

Not doing the alternative fix (an icon that survives the circle, or a visible "not diagnosed" label) — the decision is to remove, since the tooltip already carries the warning.
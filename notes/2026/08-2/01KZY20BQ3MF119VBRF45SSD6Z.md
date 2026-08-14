---
id: 01KZY20BQ3MF119VBRF45SSD6Z
created: 2026-08-13T17:16:35.427026Z
updated: 2026-08-14T08:49:28.001854Z
type: task
title: Remove the orange badge from the Propose remediation button
project: 01KX671DATY39VW6GWK3M2T3DN
number: 694
sprint: sevhjex
comments:
- id: 01KZYD32CQ3RJRQ8EMRRXTH8HY
  author: Steve Vine
  at: 2026-08-13T20:30:18.51917Z
  text: |-
    2026-08-13 — DONE, PR #641 merged to main.

    The `rightSection` Badge is gone from the Propose remediation button. `diagnosed` stays, because it still picks between the two tooltip texts — the task called that out and it was right to.

    **On the two tests that asserted `data-testid="propose-blind"`:** I repointed them at the tooltip rather than deleting them. The ISE-643 intent behind that badge — say that Propose cannot probe the live estate before a diagnosis has run — is a real thing to keep covered; only its worst rendering has gone. So one test now hovers the button and asserts the warning clause is present, and its sibling asserts the clause is absent once a diagnosis exists. Deleting the tests would have removed the last check that the warning is conditional at all.

    **One gotcha worth recording:** the first version asserted `toBeVisible()` on the tooltip and failed. Mantine's `Tooltip` mounts its content at `opacity: 0` and fades in via a CSS transition, which jsdom never runs — so a visible tooltip and a just-mounted one are indistinguishable, and `toBeVisible()` is always false. Presence is the only assertion available in jsdom; anything about actual visibility needs the browser rig. Same family as the jsdom-does-no-layout trap.

    Verified: 9/9 in ProposalFlow.test.tsx, prettier, eslint, tsc build, api-types green; PR CI green (backend path-skipped, frontend 1m58s).
assignee: steve
label:
- improvement
priority: low
task_status: done
tech: null
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
---
id: 01KZ4MHDGC30D2THAQR2HHKERS
created: 2026-08-03T20:20:13.452952Z
updated: 2026-08-07T10:06:59.740026Z
type: task
title: Estate Explorer search — results capped at 20, and the type competes with the name
project: 01KX671DATY39VW6GWK3M2T3DN
number: 523
sprint: skxht3g
comments:
- id: 01KZ4RNPKDQZJ5Q4E02JE6PXCM
  author: Steve Vine
  at: 2026-08-03T21:32:28.140904Z
  text: |-
    Built — PR #447, branch feature/ise-523-explorer-search-cap. Frontend only, branched from main and independent of the other two.

    BOTH DEFECTS, PLUS THE TWIN
    1. The cap moves to the SERVER — limit=100 for the Explorer, 8 for the relationship picker — so what comes back is what is shown, and a capped list says "Showing 100 of 347 matches — refine your search" using the `total` the endpoint already computes before its own slice. Your reading was exact: the dropdown was already scrollable and that was never the bug; results 21+ were fetched and discarded before render, so scrolling could never reach them.
    2. The row reads name-first, two spans, with `c="dimmed"` on the type and the `·` dimmed with it. Not the literally darker colour asked for, for the reason you set out — darker is MORE prominent in light mode and gone in dark; the Mantine token resolves correctly in both.
    3. RelationshipsCard's `.slice(0, 8)` got the same fix, name-first row included. It was the same row rendered twice, and fixing one would have left a known twin.

    SHARED, NOT DUPLICATED
    The caps and the truncation wording live in one small `lib/entitySearch.ts` rather than being written twice — the message an operator reads is the thing most likely to drift between the two dropdowns otherwise.

    TESTING, TO YOUR NOTES
    - Reachability, not array length: the test CLICKS svc-20 and svc-24, both past the old cap. A test counting results passes happily while the 21st is invisible.
    - The colour is asserted on the token that carries the intent — the element's `--mantine-color-dimmed` — because that is the theme-aware part and therefore the whole risk. A unit test cannot see. BOTH THEMES STILL WANT YOUR EYE on staging; that is the one thing I could not verify.
    - The stubs now honour `limit` and report `total`, so a regression that re-slices client-side fails rather than passing quietly.

    NO THIRD SITE
    The endpoint's docstring names three callers. The Dashboards group picker reads it unsliced — checked, not assumed — which is exactly what the opt-in limit exists for.

    VERIFICATION
    Frontend 565 passed; eslint, prettier, npm run build clean. No backend change.
- id: 01KZ4TQPA0MMP0XMJE7W2Q2QQF
  author: Steve Vine
  at: 2026-08-03T22:08:30.527976Z
  text: |-
    FOLLOW-UP FIX — the dropdown compressed instead of scrolling. Steve found it on staging. Second commit on the same branch, PR #447 green, re-merged to staging (frontend image staging-20260803-2205, deploy green).

    THE CAUSE, AND IT WAS NOT THE CAP
    `Stack` is a flex column, and a flex item whose OWN overflow is not `visible` gets an automatic minimum size of ZERO. Mantine's Button sets `overflow: hidden`, so the default `flex-shrink: 1` squashed every row to fit `maxHeight` rather than overflowing it. The list never scrolled — it compressed.

    Measured in Chromium at each count:
    - 10 results — 26px per row, fine
    - 20 (THE OLD CAP) — 14.3px, already squashed by nearly half
    - 40 — 6.1px (exactly where you said it becomes unreadable)
    - 100 — 2.0px, and the "Showing 100 of 347" note had scrolled out of sight

    So this was latent from ISE-268 and my change did not create it — but raising the cap is what turned "a bit tight" into unusable, so it is mine to fix.

    THE FIX
    - `flex-shrink: 0` on the row, so rows hold 26px and the container's overflow actually scrolls (verified: scrollHeight 2806 vs clientHeight 360 at 100 results).
    - The truncation note moves OUT of the scroll area. It is the line you most need when there ARE 100 rows, and inside the list it sat below all of them — readable only after scrolling to the bottom, which is the state it exists to prevent. Now pinned with a divider; verified it does not move when the list is scrolled to the end.
    - Separator spacing: it was rendering `name· type`. The two spans are flex items, so the leading space collapsed. The left gap is a margin now.

    HOW IT WAS VERIFIED, AND THE UNCOMFORTABLE PART
    jsdom performs no layout, so EVERY test in the suite passed while the dropdown was unusable — including the ones I wrote for this ticket claiming the results were reachable. They were reachable in the DOM and illegible on screen. That is the ISE-515 lesson again and I did not apply it to my own change.

    Reproduced and fixed in a real browser: playwright in mcr.microsoft.com/playwright:v1.62.1-noble via docker --network host, driving a throwaway Vite harness that mounts the real EstateExplorerPage over a stubbed fetch. Same rig as ISE-520. Screenshots checked in BOTH themes — which also closes the one thing I flagged as needing your eye: the name/type contrast reads correctly in light and dark.

    The committed guard holds what a layout-free renderer CAN prove: every row carries `flex-shrink: 0`, and the note is not a descendant of the scrolling element. Both verified to FAIL without the fix, not merely to pass with it.

    WORTH A TICKET, YOUR CALL
    This is the second time a real-browser rig has been needed for a bug the vitest suite structurally cannot see (ISE-520 was the first). A permanent one would be a new devDependency plus CI wiring for the playwright image — a bigger decision than a bug fix, so I have not made it unilaterally.
assignee: steve
priority: medium
task_status: done
---
Two defects in the same dropdown, reported from functional testing. Same component, same JSX block, so one branch.

---

# 1. The search silently discards every match past the 20th

## The dropdown is already scrollable — that is not the bug

`EstateExplorerPage.tsx:79-95` already sets `maxHeight: 360` + `overflowY: 'auto'`, with the comment *"Cap the dropdown and scroll the overflow (ISE-268): 20 results must not run off the bottom of the viewport."* Scrolling works today.

The actual cause is one line above it:

```ts
// EstateExplorerPage.tsx:50
const results = (matches?.items ?? []).slice(0, 20)
```

Results 21+ are **thrown away client-side**. No amount of scrolling can reveal them, because they were never rendered. The comment on line 49 — *"the dropdown scrolls past what fits"* — describes the intent the slice contradicts.

## The server is not the constraint

`GET /api/v1/entities` returns **every** match. `limit` is opt-in and defaults to `None` (`api/v1/entities.py:673`), and the docstring calls this out explicitly:

> `limit` is deliberately **opt-in**: three other callers (the Dashboards group picker, **the Explorer search**, the relationship search) read this endpoint expecting every match, and a default page size would silently truncate them — a group missing from a dropdown is not a bug anyone reports, it is one they work around.

The backend was built to serve exactly this case. The frontend then truncated it anyway.

## Same bug, second site

`RelationshipsCard.tsx:252` does `.slice(0, 8)` on the same endpoint — that is the "relationship search" the docstring names. Identical fix, tighter cap. Fold it in rather than leaving a known twin.

## Proposed fix

Deleting the slice is the one-line version, but an unbounded dropdown renders one `Button` per match into the DOM, and a 2-character query against a large estate could return thousands. Better, and barely more work:

1. Pass an explicit `limit` (100?) to the query.
2. Use the `total` the endpoint already returns — computed **before** the slice, precisely for this — to render a footer line: *"showing 100 of 347 — refine your search"*.
3. Keep the existing `maxHeight` + `overflowY` so the 100 scroll.

That turns silent truncation into visible truncation, which is the actual defect: an operator currently has no way to know the thing they searched for exists but sits at position 21.

---

# 2. The type competes with the name for attention

Each row renders as one flat string (`EstateExplorerPage.tsx:108`):

```tsx
{e.name} · {e.type}
```

Name and type are the same weight and colour, so the eye has to parse the `·` to find where the name ends. The name is what the operator is scanning for; the type is context.

## Use `c="dimmed"`, not a literally darker colour

The request was for a *darker* type. Taken literally that breaks in one of the two themes — ISE has a light/dark/auto toggle (`ThemeToggle.tsx`, `localStorageColorSchemeManager` in `main.tsx:17`). Darker text in **light** mode is *more* prominent, the opposite of the intent; in **dark** mode it disappears into the background.

`c="dimmed"` is Mantine's theme-aware token for exactly this — recede the secondary element in whichever direction the current theme requires. It is already the established convention here (369 uses across `src/`), so this also stops the dropdown being a one-off.

## Implementation note

The row content sits inside `<Button variant="subtle">`, which colours its own children. Two colours in one row means wrapping them as `<Text span>` elements with explicit `c` on the type — the button's colour will otherwise win. Dim the `·` separator along with the type; leaving it at full strength keeps the visual break the change is meant to soften.

---

## Definition of done

Searching the Estate Explorer for a term matching more than 20 entities lets the operator scroll to any of them, and — where a cap still applies — the UI says so instead of silently dropping matches. Same for the relationship search on the entity detail page. Entity names read as the primary text in each row, with the type visibly secondary in both light and dark themes.

## Testing notes

- Whatever cap lands, assert on **what the operator can reach**, not on the array length — the ISE-515 lesson. A test that checks `results.length === 100` passes happily while the 101st match is invisible with no indication it exists.
- The colour change is a **visual** property, and ISE-515 is the standing warning here: a test asserting two different components render says nothing about whether they *look* different. Either assert the specific prop that carries the intent, or accept that only Steve's eye confirms it — and check both themes, since that is the whole risk in this change.

---
id: 01KZ4MHDGC30D2THAQR2HHKERS
created: 2026-08-03T20:20:13.452952Z
updated: 2026-08-03T20:40:56.70875Z
type: task
title: Estate Explorer search — results capped at 20, and the type competes with the name
project: 01KX671DATY39VW6GWK3M2T3DN
number: 523
sprint: skxht3g
assignee: steve
priority: medium
task_status: todo
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

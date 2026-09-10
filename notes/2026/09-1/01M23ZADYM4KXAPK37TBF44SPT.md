---
id: 01M23ZADYM4KXAPK37TBF44SPT
created: 2026-09-09T20:56:29.908826Z
updated: 2026-09-10T11:39:59.067993Z
type: task
title: A section's heading is written in its text, not typed into a separate box
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 646
sprint: s9q4m6q
comments:
- id: 01M25HW4MM6MYJNEB9EKR9F8C6
  author: Steve Vine
  at: 2026-09-10T11:39:58.996419Z
  text: |-
    Merged to main (PR #659, squash 0c84b31), 2026-09-10.

    The Heading box is gone from the section editor and the "add a section" form. Migration 0177 folds any existing heading into the top of the section's text as a `# ` line and drops the column. Old published versions are untouched: their snapshot heading is folded on read, so restore, preview and export are unchanged. In the Word merge `#` to `######` now map to Heading 1 to 6, and a top-level heading still appears in the contents list as before (every level is COM-647).

    Not on staging yet: deploys together with COM-648 and COM-647.
assignee: steve
label:
- improvement
priority: medium
task_status: review
---
Decided with Steve, 2026-09-09, reviewing the Content section.

Every section of a content item has an optional **Heading** box beside its text. It is one more thing to fill in, it renders at a fixed level that can outrank a `#` typed into the text, and it means the section's headings live in two places. It goes away: a heading is a heading line in the text, like every other one.

## What changes for the author

- The heading box disappears from the section editor and from the "add a section" form.
- Any heading already typed into that box is moved to the **top of the section's text as a top-level heading** (`# …`), so nothing published, previewed or exported looks different.
- Old published versions still open, preview and export exactly as they did.

## Implementation notes

- `content_section.heading` (and the `heading` key in each version's section snapshot) is retired. One migration folds the existing value into the body as a `# ` line; the column is then dropped. Version snapshots are JSON and stay as they are — the renderer treats a snapshot `heading`, when present, as a `#` line before the body, so a restore or re-export of an old version is unchanged.
- API: `heading` leaves the section create/update/read schemas (public `/api/v1`, so regenerate `schema.d.ts` — run the drift script).
- Word merge (`core/templating.py`): `_insert_section` stops taking `heading`; body `#…######` map to Heading 1–6 (today they cap at 4, and the section heading is a hard-coded Heading 2). Bookmarking every heading for the contents list is COM-647.
- Frontend: `ContentDetailPage.tsx` section editor, add-section form, the read view's `Title order={4}`, and the "unsaved changes" check that compares heading.
- The template help text on the Templates tab still reads correctly ("your section headings"); COM-647 re-words it.

## Done when

- The heading box is gone from both forms.
- Existing sections that had a heading show it as the first line of their text, at `#`.
- Publishing, previewing and Word/PDF export of a content item with old and new sections produce the same output as before this change.
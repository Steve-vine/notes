---
id: 01M526NZF18K6MMT2F9W3GWWF1
created: 2026-10-16T11:13:44.929372Z
updated: 2026-10-16T15:45:19.485116Z
type: task
title: The Read tab shows what Contents, Posture, Domain controls and Document review hold, where they're placed — and no block adds a heading of its own
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1008
sprint: s2ufsxd
comments:
- id: 01M52P73V4QM863VXYPZ6A96F9
  author: Steve Vine
  at: 2026-10-16T15:45:15.108541Z
  text: |-
    Done in PR #1000 (main c8dc3984). On the Read tab each block now shows what it holds, exactly where it's placed — the same content as Print preview:
    - Contents: the headings, numbered when the house style numbers them; click one to go to it.
    - Domain controls: the domain's live controls, ID then title.
    - Posture: the linked controls with the selected company's open gaps, then the decisions — in the flow of the document, in its own type, with no box or "Posture" title.
    - Document review: the review record table, newest first.
    The Posture box at the foot of the Read tab is gone — a document without a Posture block shows no posture (links are still on the Links tab). No block adds a heading anywhere: the Read tab, PDF/Print preview, Word and plain text lose "Contents" and "Document Review" (and the document-name line under it). Posture keeps its small bold Controls / Gaps / Decisions labels — labels inside the list, not headings. The Edit tab still shows placeholders while you write; the review history at the foot of the Read tab stays.

    My calls, not confirmed:
    - Document review also renders on the Read tab, for consistency.
    - No data change: existing documents' Contents and Document review blocks just lose their titles — on staging that includes the Document review block every document gained from COM-1007. Add a heading above a block if you want one.
    - Rows are links on screen (the PDF has none).
    - Read-tab headings stay unnumbered as now; only the Contents list shows numbers.
assignee: steve
label:
- improvement
priority: medium
task_status: review
---
Asked for in Steve's smoke test of sprint 71, 2026-10-16:

> In the content read view it currently shows placeholders (Contents, Domain controls) as placeholders. Can these be made to render the actual content on the read tab.
>
> The exception to this is Posture which always shows, and has its own style. Make this behave like Contents and Domain controls, don't automatically show it unless the placeholder has been inserted and then only in-line like the other content.
>
> Currently the Contents placeholder includes a "Contents" heading, none of the other placeholders contain headings, remove the heading, this can be added in the actual content. Going forward, none of the content inserted by placeholders should contain headings.

## What people see

- **On the Read tab, each block shows what it holds, exactly where it was placed** — the same content as Print preview:
  - **Contents:** the document's headings, indented by level, numbered when the house style numbers headings, to the style's contents depth. Clicking one scrolls to that heading.
  - **Domain controls:** every live control in the document's domain, ID then title, in the library's order. Each ID opens the control.
  - **Posture:** the controls linked to the document, each with the selected company's open gaps, then its decisions — the content of today's Posture box, but in the flow of the document, without the box or its "Posture" title. Each row opens its control, gap or decision.
  - **Document review:** the review record table (Reviewed, Reviewer, Job title, Comment), newest first; "No reviews recorded yet." when there are none.
- **The Posture box at the foot of the Read tab goes.** A document without a Posture block shows no posture on its Read tab; its links are still on the Links tab.
- **No block adds a heading of its own, anywhere** — Read tab, Print preview/PDF, Word and plain text:
  - Contents loses its "Contents" title;
  - Document review loses its "Document Review" title (and the document-name line under it).
  - Posture keeps its small bold "Controls / Gaps / Decisions" labels: they're labels inside the list, not headings, and stay out of the contents.
  - Authors who want a title write it as a heading above the block.
- **The Edit tab is unchanged:** blocks still show as their dashed placeholders while you write.
- **The review history at the foot of the Read tab stays**, as now.

**My calls (not confirmed by Steve):**
- Document review renders on the Read tab too, for consistency, though it wasn't named.
- No data change to existing documents: their Contents and Document review blocks simply lose their titles. On staging that includes the Document review block every document gained today (COM-1007); add a heading above it if wanted.
- Rows link on screen (the PDF has no links).
- Headings on the Read tab keep showing without their numbers, as now; only the Contents list shows the numbers.

## Technical

- **New read:** `GET /api/v1/content/{slug}/blocks` → `{ contents: [{anchor, depth, number, text}], domain_controls: [{ref, title}] }`, built from the same code as the PDF: `outline()` over the draft's docs with the type's house style (`numbered`, `contents_depth`), and `domain_control_lines()`. Posture reuses `GET /{slug}/links` (already shared with the PDF's `[posture]` lines); Document review reuses `GET /{slug}/reviews`.
- **`RichTextView`** takes an optional `renderBlock(kind)`. It serialises once into a container, gives headings the PDF's `h-N` anchors (offset across sections), swaps each `.rt-special` for an empty host, and portals the block into it. No setState in effects.
- **`DocumentPosture`** splits into the list (used inline) and loses its card/title; the Read tab no longer mounts it at the foot.
- **Headings removed:** `html.py` `contents()` (`rt-contents-title`), `document.py` `review_record_html` (title + subject), `word.py` contents title paragraph and `_review_record`'s Heading 1, plain text "CONTENTS" and "DOCUMENT REVIEW". `_STYLE_RENDERER_VERSION` → "7".
- **Tests:** Python — the blocks route (contents numbering/depth, domain controls order), no "Contents"/"Document Review" in HTML, Word or text. Vitest — each block renders in place on the Read tab, no Posture box without the block, the hook tolerates a prefix stub.

## Done when

- [ ] On the Read tab, Contents, Domain controls, Posture and Document review show their content where they're placed.
- [ ] Without a Posture block, the Read tab shows no posture.
- [ ] No block adds a heading in the Read tab, PDF, Word or plain text.

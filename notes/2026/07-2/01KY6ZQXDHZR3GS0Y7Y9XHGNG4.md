---
id: 01KY6ZQXDHZR3GS0Y7Y9XHGNG4
created: 2026-07-23T07:58:47.729838Z
updated: 2026-07-23T09:17:33.636033Z
type: task
title: Render callouts & footnotes in read/live view
label:
- follow_up
comments:
- id: 01KY6ZR5YRDQDG1CPRRCP3RTWX
  author: Steve Vine
  at: 2026-07-23T07:58:56.472346Z
  text: |-
    Steve Vine · 2026-06-28:

    Done — PR #100 (https://github.com/Steve-vine/notula/pull/100).

    **Scope grew during review** (same "Live read-parity" theme): beyond the filed callouts + footnotes, this also covers **Live code blocks** and a **read-view language header**.

    **What was built**
    - **Callouts**: `marked` block extension → styled box in Read; live-preview renders the same box (widget, click-to-edit) off-cursor. Callout CSS made global so both views share it.
    - **Footnotes**: refs → superscript links + a Footnotes section in Read; Lezer `FootnoteRef` inline parser + superscript/def widgets in Live, numbering matched to Read.
    - **Code blocks**: Live renders the read-view box (header + copy + line numbers via `renderMarkdown`, click-to-edit); Read gains the language header; code-block CSS moved global.

    **Fixes from live review with Steve**
    - Footnote ref `[^id]` was being claimed as a shortcut **link** in Live (brackets hidden, stray `^id`) — fixed by ordering `FootnoteRef` **before** Link in the Lezer config.
    - Read-view code header had a gap above the body — the scoped `.markdown pre` margin out-specified the reset; moved spacing to `.code-block` and zeroed the inner `pre` margin.

    **Verification** — full lefthook gate green (check/build/npm test 94, cargo fmt/clippy/test 134) + manual pass across Read/Live.

    Pure helpers (`parseCalloutHeader`, `calloutTitle`, `footnoteNumbers`) are unit-tested.
assignee: steve
task_status: done
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 112
sprint: st23znm
---
Surfaced in DEV-689 (Insert menu). The menu inserts correct markdown for **callouts** (`> [!note] …`) and **footnotes** (`[^1]` + `[^1]: …`), but `marked` styles neither by default:

* **Callouts** render as a plain blockquote (the `[!note]` shows literally).
* **Footnotes** render as literal `[^1]` text with no jump-to / backlink.

If we want these to look right, add rendering support in `src/lib/markdown.ts` (a `marked` extension or post-process) and matching live-preview decorations in `src/lib/livePreview.ts`:

* Callout: parse `> [!type] title` → a styled callout box (icon + type colour), Obsidian-style.
* Footnote: render refs as superscript links and collect a footnotes section; live-preview can keep them inline.

Not a bug — the inserted markdown is valid and greppable; this is presentation polish.

---

Linear DEV-697 · M13 - Hybrid Edit Mode · created 2026-06-28 · done 2026-06-28
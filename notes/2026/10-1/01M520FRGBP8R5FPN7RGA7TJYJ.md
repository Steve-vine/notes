---
id: 01M520FRGBP8R5FPN7RGA7TJYJ
created: 2026-10-16T09:26:25.404219Z
updated: 2026-10-16T16:39:49.279971Z
type: task
title: Callouts on the Read and Edit tabs look as they print — a clear shaded box with a strong edge — not a faint outline
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1002
sprint: s2ufsxd
comments:
- id: 01M52BGVW18QRMTCVAPSCFTGD8
  author: Steve Vine
  at: 2026-10-16T12:38:20.285501Z
  text: |-
    Done — PR #995, merged to main (d03b3a86). On the Read and Edit tabs, callouts now look as they print: the box is filled with the style's shade, there's a strong edge on the left (primary for Note, amber for Warning, red for Important), and the text is in the style's text colour. Measured in a real browser, the light-mode colours are exactly the PDF's. The NOTE / WARNING / IMPORTANT label now shows only on the Edit tab, in the edge colour. In dark mode the fill is a deep tint of the same colour, with light text, and the label reads at 4.5:1 on it. PDF and Word unchanged.
    My calls: in dark mode the edges are a little brighter than the 3:1 a plain rule needs, so the label (which is text) reads clearly. The dark tints are slightly muted, so they read as tints rather than solid blocks of colour.
assignee: steve
label:
- bug
priority: medium
task_status: done
---
![CleanShot 2026-10-16 at 10.25.20.png](attachments/2026/10/01M520FRGBP8R5FPN7RGA7TJYJ/CleanShot-2026-10-16-at-10.25.20.png)


![CleanShot 2026-10-16 at 10.25.56.png](attachments/2026/10/01M520FRGBP8R5FPN7RGA7TJYJ/CleanShot-2026-10-16-at-10.25.56.png)

Found in Steve's smoke test of sprint 71 (COM-988 / COM-989), 2026-10-16. Screenshots above: light mode first, then dark.

## What is wrong

Callouts (Note, Warning, Important) are very faint on a document's Read and Edit tabs. In the generated PDF and Word file they look right.

- **Light mode:** the box is barely shaded, the edge is pale, and the NOTE / WARNING / IMPORTANT label is almost invisible.
- **Dark mode:** the box is grey rather than the style's colour, and the text inside is dark on dark.

**Why:** the house style holds one colour for each kind of callout, and it is the pale **background** shade (e.g. #e8f1fb for Note). The PDF uses it that way:
- the pale shade fills the box;
- the edge is the primary colour, amber for Warning, or red for Important.

The screen treats that same pale shade as if it were a strong colour. It draws the edge and the label in it, then fills the box with only 8% of it, so everything comes out washed out.

## What people see

- **On the Read and Edit tabs, a callout looks as it prints:**
  - the box is filled with the style's shade for that kind;
  - a strong edge on the left: primary for Note, amber for Warning, red for Important;
  - the text in the style's text colour.
- **The label stays on the Edit tab only.** NOTE, WARNING or IMPORTANT, in the edge colour, tells the writer which kind it is. It isn't on the paper, so the Read tab doesn't show it either, and the Read tab matches print.
- **In dark mode,** the shade, edge and text use the dark-background versions from COM-1001: a deep tint of the same hue, a lightened edge, and light text. The callout reads clearly and still looks like a Note, Warning or Important.
- **Changing a callout colour** in the house style changes it on screen the same way as in the PDF.

## Technical

- **Cause:**
  - `frontend/src/content/richtext/richtext.css` lines 93–121: `--rt-callout` is set to `--rt-callout-note|warning|important` (the palette's *background* shades, `style.py` Palette `note`/`warning`/`important`), then used for `border-left`, the `::before` label colour, and `color-mix(… 8%, transparent)` as the fill.
  - The editor's markup is `div.rt-callout[data-callout=…]`. The PDF's is `div.rt-callout.rt-callout-<kind>` (`core/render/html.py:123`), so the house stylesheet's `.rt-callout-note` rules (`css.py` `_shared_rules`) never match on screen.
- **Fix:**
  - Make the screen take the PDF's rules. Either add the `rt-callout-<kind>` class in the Tiptap node's `renderHTML` (`extensions.ts:38`) and in `RichTextView`, or key the shared rules on `[data-callout]` as well. One set of rules, not two.
  - In `css.py`, give the edges variables, `--rt-callout-note-edge` (= primary), `--rt-callout-warning-edge` (#c77700) and `--rt-callout-important-edge` (#b42318), so the screen label and COM-1001's dark mode can use them. The PDF stays byte-identical; test that.
  - `richtext.css`:
    - keep the Mantine fallbacks only for when no house stylesheet is loaded;
    - stop deriving the fill, edge and label from the shade;
    - show the `::before` label only inside the editor (`.ProseMirror .rt-callout::before`).
- **Dark mode:** depends on COM-1001's turned variables (shade → deep tint, edge → lightened, text → light). Build it after COM-1001, or together in the same branch, since both touch `css.py` and `richtext.css`.
- **Tests:**
  - Vitest: the editor and RichTextView both render `rt-callout-<kind>`; the label only appears in the editor.
  - Python: `screen_css` has the edge variables; `document_css` is unchanged.
  - The Playwright harness: screenshots of all three callouts in light, dark, and "Show as on paper" (COM-1001), for the PR.

## Done when

- [ ] In light mode, the three callouts on the Read and Edit tabs match the PDF: a clear shade and a strong edge.
- [ ] In dark mode they're readable, with light text on a deep tint of the same colour.
- [ ] The PDF and Word file are unchanged.

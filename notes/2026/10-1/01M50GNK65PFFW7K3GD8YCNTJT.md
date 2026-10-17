---
id: 01M50GNK65PFFW7K3GD8YCNTJT
created: 2026-10-15T19:29:49.253383Z
updated: 2026-10-16T10:52:26.697314Z
type: task
title: Diagrams are written as text — flowcharts, sequences, states and more from a few lines, redrawn as you type, in the house style's colours
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 994
sprint: s2ufsxd
blocked_by:
- 01M50GJVGJ693A4RS0KN3A2EJ9
- 01M50GKAQT4KHC9X4PZT2WMMKY
- 01M50GM94YF8A03SHS9A4QQGKZ
- 01M50GN3XS189JF474F83YY98D
assignee: steve
label:
- feature
priority: medium
task_status: done
---
Sprint 71, Improve templated content (ADR in COM-986). Builds on COM-988, COM-989 and COM-991. Steve asked for diagrams as text alongside drawn ones on 2026-10-15.

## What people see

- **Insert ▸ Text diagram** opens a split view: you type the diagram's text on the left and see it drawn on the right as you type. Supported kinds:
  - flowchart and sequence;
  - state and entity-relationship;
  - Gantt, timeline and mind map.
- **A mistake** shows a short message under the text. The last good picture stays put until it's fixed.
- **The look** follows the house style's font and colours.
- **Where it appears:**
  - the PDF: crisp at any zoom;
  - Word: as a picture;
  - plain text: `[Diagram: caption]` with the diagram's text underneath, which is still readable.
- **The assistant** can write one: a Mermaid block in its Markdown becomes a text diagram.
- **A diagram the assistant wrote** is drawn the first time anyone opens the document in Compass. Until then, its PDF shows the diagram's text in a box marked *"Not yet drawn — open the document in Compass"*.

## My calls

- The diagram language is **Mermaid**: free, MIT licence, and the most widely known.
- The "not yet drawn" behaviour above, so that the server never has to run a browser.

## Notes (technical)

- `mermaid` (MIT) loaded as a lazy chunk, with `securityLevel: 'strict'` and `htmlLabels: false`. Theme variables come from the house style.
- On save the browser renders an SVG and a PNG, stored with the source (the same record shape as COM-993's drawings). Sanitise the SVG the same way as uploads.
- A Mermaid block arriving through the API (the assistant, COM-978) is stored with source only.
  - The editor finds diagrams without an SVG on load, renders them, and saves the pictures without creating a new version or Activity noise (a "derived assets" write).
  - A published version gets its pictures written into that version's record.
- Semgrep: no template literal as a `console.*` first argument in the error display.

**Done when:** on staging, Steve writes a flowchart and a sequence diagram in a runbook, a typo shows an error without losing the picture, and both appear in the PDF, in Word, and as text in the plain-text export.
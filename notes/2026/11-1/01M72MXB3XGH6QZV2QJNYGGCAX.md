---
id: 01M72MXB3XGH6QZV2QJNYGGCAX
created: 2026-11-10T11:53:49.949337Z
updated: 2026-11-10T11:53:49.949337Z
type: task
title: 'Content Read tab: "Show as on paper" toggle, on by default'
label: improvement
task_status: todo
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1667
---
Raised by Steve while testing (2026-11-10).

**Ask:** the content Read tab gets the same "Show as on paper" toggle the Edit tab already has (COM-1005), and it starts **on** — so reading a templated document always opens as the page it will print as, in the house style. Shortcodes (contents, document review, etc.) are rendered as they are on the Read tab today, not shown as raw placeholders.

**Done when**
- Opening any templated content item on the Read tab shows it on paper, with contents, document review and the other shortcodes rendered.
- The toggle sits on the Read tab as it does on Edit; turning it off shows the current plain reading view.
- Turning it off doesn't stick: the next time the Read tab opens it's on paper again (assumption — "always defaults to the paper view"). The Edit tab's own choice is unaffected.
- Non-templated content (uploaded documents etc.) is unchanged.

**Notes for the build**
- Edit tab toggle: `ContentDetailPage.tsx` EditTab (`preferredPaper`/`rememberPaper` in `content/richtext/convert.ts`, `paper.ts`, `.rt-paper` in `richtext.css`). Edit defaults off and is remembered per browser under `compass.showAsPaper` — the Read tab must not share that key.
- Read tab: `ContentDetailPage.tsx` `// ---- Read ----`. Reuse the paper sheet styling around the rendered (shortcode-expanded) section HTML.
- Independent (frontend only, no migration or API change).
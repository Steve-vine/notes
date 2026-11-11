---
id: 01M72MXB3XGH6QZV2QJNYGGCAX
created: 2026-11-10T11:53:49.949337Z
updated: 2026-11-11T08:10:33.236111Z
type: task
title: 'Content Read tab: "Show as on paper" toggle, on by default'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1667
sprint: s0mep0u
comments:
- id: 01M74BRB07Z65ZH5EM9B19J963
  author: Steve Vine
  at: 2026-11-11T03:52:17.670982Z
  text: |-
    Built in PR #1715.

    Pre-UAT (Claude, 2026-11-11, staging 305de68a): **Passed**, except one point I **couldn't check** (below).
    Steps: as E2E Assessor, in a browser that had never used the switch, I opened Access Control Policy.
    Seen:
    - The Read tab opens on paper: a white A4 sheet in the house style, with the Contents and Document review blocks drawn (no placeholders).
    - Turning the switch off and opening another document (Asset Management Policy) stays off. Edit's own setting is untouched.
    - Joiners, movers and leavers procedure (2 sections) reads as one sheet with no gap, and stays a white page in dark mode.
    Couldn't check: "non-templated content is unchanged". E2E Test Company has only templated documents. The code only adds the switch to templated documents that have sections.
    Screenshots: ~/compass-uat/s0mep0u/COM-1667/
assignee: steve
label:
- improvement
priority: medium
task_status: done
---
Raised by Steve while testing (2026-11-10).

**Ask:** the content Read tab gets the same "Show as on paper" toggle the Edit tab already has (COM-1005), and it starts **on** — so reading a templated document opens as the page it will print as, in the house style. Shortcodes (contents, document review, etc.) are rendered as they are on the Read tab today, not shown as raw placeholders.

**Done when**
- Opening any templated content item on the Read tab shows it on paper, with contents, document review and the other shortcodes rendered — for someone who has never touched the toggle.
- The toggle sits on the Read tab as it does on Edit; turning it off shows the current plain reading view.
- The choice is remembered on that browser (Steve, 2026-11-10): turn it off and the Read tab stays off, for every document, until it's turned back on. The Read tab and the Edit tab remember their choices separately.
- Non-templated content (uploaded documents etc.) is unchanged.

**Notes for the build**
- Edit tab toggle: `ContentDetailPage.tsx` EditTab (`preferredPaper`/`rememberPaper` in `content/richtext/convert.ts`, `paper.ts`, `.rt-paper` in `richtext.css`). Edit defaults off and is remembered per browser under `compass.showAsPaper` — the Read tab needs its own key, defaulting **on** when nothing is stored.
- Read tab: `ContentDetailPage.tsx` `// ---- Read ----`. Reuse the paper sheet styling around the rendered (shortcode-expanded) section HTML.
- Independent (frontend only, no migration or API change).
---
id: 01M3D86QWV2ERDZS5CF9CZR03G
created: 2026-09-25T21:41:03.407994Z
updated: 2026-09-26T12:39:51.311789Z
type: task
title: 'Posture reads as the screenshot: bold IDs, only gaps indented, 12pt between controls — on the Read tab and in [posture]'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 753
sprint: s71mee4
comments:
- id: 01M3D9PTPTDD5FRK3AKVHHSZV7
  author: Steve Vine
  at: 2026-09-25T22:06:53.658605Z
  text: |-
    Done: PR #763, squash-merged to main as 89e3fea.

    The Read tab's Posture box and the `[posture]` PDF now follow the screenshot:
    - **Indents:** only the Gaps label and its gaps are indented, by one tab (half an inch in the PDF, 48px on screen). Everything else sits at the margin, and the vertical lines on screen are gone.
    - **IDs:** shown in bold in the text's own font, followed by one space and the title.
    - **Spacing:** 12pt between one control (with its gaps) and the next, and between decisions, with a wider break (24pt) before Decisions.

    The rows on screen still link to their pages.

    I checked the Read tab in a real (headless) browser using your screenshot's data. Gaps start 48px in, controls are 16px (12pt) apart, and IDs are bold. The result matched the screenshot.

    In the PDF, the bold IDs apply to `[domain-controls]` too, because both placeholders share one line format. Its spacing is COM-754. PDFs made under the old format are regenerated.

    To smoke-test: compare a document's Read tab with the screenshot, then generate a PDF that uses `[posture]`.
assignee: steve
label:
- improvement
priority: medium
task_status: done
---
![CleanShot 2026-09-25 at 22.37.13@2x.png](attachments/2026/09/01M3D86QWV2ERDZS5CF9CZR03G/CleanShot-2026-09-25-at-22.37.13@2x.png)

![CleanShot 2026-09-25 at 22.40.46@2x.png](attachments/2026/09/01M3D86QWV2ERDZS5CF9CZR03G/CleanShot-2026-09-25-at-22.40.46@2x.png)

The first screenshot is the new Posture format. It applies both to the **Read tab's Posture box** and to the **`[posture]` placeholder** in a generated PDF, so the two keep matching. The second screenshot is `[domain-controls]`, which is COM-754.

## The format (first screenshot)

```
Controls
INS.1 An acceptable use policy has been created … wrapped lines return
to the left margin.
        Gaps
        G-2 Close gap: INS.1 … wrapped lines stay at the
        gap indent.
        G-4 INS.1: Do some stuff
                                                  ← 12pt
INS.2 All employees … confirm …
        Gaps
        G-5 INS.2: New gap needs plugging
                                                  ← 12pt
INS.6 Management reviews …
                                                  ← a clear gap before Decisions
Decisions
D-1 All services must support SSO going forward
                                                  ← 12pt
D-2 …
```

- **Only the gaps are indented**, by one tab position (half an inch in the document, the equivalent on screen). The Gaps label sits at the same indent. Controls, decisions and the Controls and Decisions labels sit at the left margin. On screen, the vertical rules down the left of each list go.
- **IDs are bold** (`INS.1`, `G-2`, `D-1`), in the same font as the text, followed by one space and then the title. This replaces the fixed-width font IDs use elsewhere in the app, in this section only.
- **Spacing:**
  - 12pt between controls. The gap falls after a control's own gaps, before the next control. There's no extra space between a control and its Gaps, or between one gap and the next.
  - 12pt between decisions, as in the screenshot.
  - A clear gap (as shown) between the last control and the Decisions label.
- **Labels:** Controls, Gaps and Decisions stay bold, as now. An empty label is still left out.
- **Unchanged:** the scope (COM-749, COM-752). The rows on screen still link to their pages, while the PDF rows are not links.

## Done when

- The Read tab's Posture box and a `[posture]` PDF both match the screenshot's layout: indents, bold IDs and spacing.
- A cached PDF generated under the old format is not reused.

## Notes

- PDF: `BlockLine` (`core/templating.py`) needs a spacing before or after, a bold non-monospace ref, and depth mapped to indent with gaps only at one tab (Word's default tab stop, 0.5in). Set the space as `space_before` 12pt on each control after the first, or `space_after` on a control's last line. Bump `_RENDERER_VERSION`.
- Screen: `content/DocumentPosture.tsx`. Drop the `Branch` rule and indent for Controls and Decisions, indent Gaps by about 2rem, make the ref a bold span instead of `RefText`, and put `mt` 12pt (about 16px) between control groups and between decisions.
- Tests: update `DocumentPosture.test.tsx`, `test_templating.py` and `test_pdf.py` for the new structure.

Raised in sprint 61 (Content upgrade), 2026-09-25.
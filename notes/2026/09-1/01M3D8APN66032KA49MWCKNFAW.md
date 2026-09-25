---
id: 01M3D8APN66032KA49MWCKNFAW
created: 2026-09-25T21:42:47.718903Z
updated: 2026-09-25T21:42:51.705277Z
type: task
title: '[domain-controls] reads as the screenshot: bold IDs, 12pt between controls'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 754
sprint: s71mee4
assignee: steve
label:
- improvement
priority: medium
task_status: todo
---
![CleanShot 2026-09-25 at 22.40.46@2x.png](attachments/2026/09/01M3D86QWV2ERDZS5CF9CZR03G/CleanShot-2026-09-25-at-22.40.46@2x.png)

The new format for the `[domain-controls]` placeholder in a generated PDF (the second screenshot on COM-753). It applies to the document template only, because there's no screen equivalent.

## The format

```
AIG.1 Accountability for AI is named, with defined roles, decision rights and the
competence to exercise them.
                                                  ← 12pt
AIG.2 Objectives for the responsible development and use of AI are defined, approved
and reviewed.
                                                  ← 12pt
AIG.3 …
```

- **IDs are bold** (`AIG.1`), in the same font as the text, followed by one space and then the title. This replaces the fixed-width font.
- **Spacing:** 12pt between controls.
- **No indent.** Wrapped lines return to the left margin.
- **Unchanged:** which controls are listed (COM-751), and no links.

## Done when

- A `[domain-controls]` PDF matches the screenshot.
- A cached PDF generated under the old format is not reused.

## Notes

- This shares the `BlockLine` changes with COM-753: a bold body-font ref and 12pt spacing. Build the two on one branch, or stack this on COM-753. Bump `_RENDERER_VERSION` once for both.

Raised in sprint 61 (Content upgrade), 2026-09-25.
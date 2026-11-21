---
id: 01M7ZGSKAWZ4TVWE0JR3STKJKG
created: 2026-11-21T16:59:51.516875Z
updated: 2026-11-21T16:59:54.175298Z
type: task
title: Older Office and OpenDocument files can be added (no preview), as COM-2052 says
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2074
sprint: s9hexqn
assignee: steve
label:
- bug
priority: high
task_status: active
---
Found by the COM-2052 pre-UAT recheck (21 Nov). COM-2052 says older .doc, .xls and .ppt files and OpenDocument files (.odt, .ods, .odp) "still upload, download and go in packs", with "No preview for this file". But adding one is refused: "Compass doesn't take this kind of file…". That rule is older than this sprint. Steve confirmed that COM-2052 stands (21 Nov), so these files are now accepted.

## What people see
- Adding a .doc, .xls, .ppt, .odt, .ods or .odp file works, wherever Compass takes evidence-style files today (Add evidence, plus the other places that share the same file rule: risks, incidents, the plan, vulnerabilities).
- The piece's preview says "No preview for this file", with COM-2052's reason (Compass previews Word, Excel and PowerPoint files saved in the current formats). Download returns the original file. Packs include it.
- The refusal message's list of accepted types is updated to match.
- A .doc renamed to .docx is still refused (COM-2052). Macro-enabled files (.docm, .xlsm, .pptm) are still refused.
- These files are never sent to the converter, and the backfill skips them.

## Done when
- Each of the six formats can be added through Add evidence, shows "No preview for this file" with the reason, and downloads unchanged.
- Nothing about these files reaches the converter (a test proves it).
- A renamed .doc and the macro-enabled types are still refused.
- The upload window's accepted-types hint and the refusal wording list the older formats.

On the chain or independent: independent, unless an API enum changes.
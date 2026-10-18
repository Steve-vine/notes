---
id: 01M54SRNP3HAHFZ7JRVJAAHMAM
created: 2026-10-17T11:25:45.02774Z
updated: 2026-10-18T08:10:43.060566Z
type: task
title: Content - House Style editor changes
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1061
comments:
- id: 01M57108ZMYEEY21PT0XR2DVVM
  author: Steve Vine
  at: 2026-10-18T08:10:43.060447Z
  text: |-
    Built in PR #1060 (all CI green 2026-10-18 09:10 BST), awaiting merge — my merge was blocked by the permission check.

    What changed:
    - Cover page: words always left aligned; Left/Centred replaced by Top / Middle / Bottom (PDF and Word).
    - The house style's "Classification text" box is gone. Classification stays a tick box under "What it shows" and a header/footer slot choice, and now prints each document's own Classification.
    - Content gets a Classification field (Edit tab, right column under Domain), picked from the data sensitivity scale (Public / Internal / Confidential / Restricted, as worded in Admin ▸ Data Rubric). Last reviewed + Next review now share the left column under Reviewers. The Read tab shows it as a pill.
    - Migration 0285: each templated document takes the level its style's old words named (e.g. "Internal"), so nothing stops printing what it printed.
    - Assistant: playbook_update_content takes a classification.

    My calls: pick from the sensitivity scale rather than free text; Word puts a middle/bottom cover in its own section; a bottom-positioned cover with a bottom-corner logo can overlap (the preview shows it).
assignee: steve
label:
- improvement
priority: medium
task_status: active
---
On the cover page the text (title, content type, version etc.) should always be left aligned, replace the left/centre toggle with a top/middle/bottom one.

Change Classification text to a toggle like the other content, then add a new property to Content 'Classification' that maps to it. On the content edit page, shrink the Last review and Next review fields so that they take up the same width as reviewers above them, then add the Classification field on the right below Domain.
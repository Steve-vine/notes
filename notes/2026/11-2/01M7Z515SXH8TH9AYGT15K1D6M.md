---
id: 01M7Z515SXH8TH9AYGT15K1D6M
created: 2026-11-21T13:34:16.89371Z
updated: 2026-11-21T13:34:19.631999Z
type: task
title: 'Assessment screen: someone who can''t record assessments sees a read-only box, not an editable one that fails on Save'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2072
sprint: s9hexqn
assignee: steve
label:
- bug
priority: medium
task_status: active
---
Found in Claude's pre-UAT pass (staging 12bd442a5, 2026-11-21). It probably predates this sprint, but it sits on the screen this sprint reworked.

**Steps:** Sign in as E2E Viewer ▸ Assessment screen ▸ RIM.9.
**Expected:** Someone who can't record assessments sees the assessment read-only: its status, maturity and notes as text, with no Save. That matches the rest of the screen, where a Viewer gets no buttons.
**Seen:** The Viewer gets clickable status and maturity buttons, an editable Notes box, and enabled Save / Save & next. Pressing Save is refused with "You don't have permission to do that." Nothing is saved.
**Screenshot:** ~/compass-uat/s9hexqn/other/viewer-save-on-box.png

**Done when**
- As E2E Viewer, the Assessment screen box shows the current status, maturity and notes, and none of them can be changed. There is no Save or Save & next, and nothing invites an edit.
- Previous/Next and the keyboard still step through the controls.
- An Admin and an Assessor see the box as now.
- The initiative's Assess drawer behaves the same way for a Viewer.
- A test covers a Viewer.

Frontend only, most likely: the box already knows whether the person can record assessments. Independent.
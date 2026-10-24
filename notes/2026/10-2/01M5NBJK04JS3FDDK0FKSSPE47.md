---
id: 01M5NBJK04JS3FDDK0FKSSPE47
created: 2026-10-23T21:44:50.948091Z
updated: 2026-10-24T10:56:27.223479Z
type: task
title: A DDQ's next step is in its page header — Submit for review, Approve all, Mark as sent — not only on the Review card, which a long question list pushes out of sight
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1274
sprint: shig2cj
assignee: steve
label:
- feature
priority: high
task_status: active
---
Sprint 85, DDQ-2. From Steve's smoke test of sprint 84 (2026-10-23): "I created a DDQ and it's in 'In review' status but I can't see a way to move it forward."

DDQ-1 on staging was In review with all 96 answers approved, so it was Ready to send. **Mark as sent** was there, but only as a small button on the Review card in the side column. With 96 questions, the side column sits beside, or on narrower screens below, a very long Questions card. The page header offered only Decline, Withdraw and Edit, so nothing there said what to do next.

**Chain:** independent (frontend only)

## What people see

- The page header carries the DDQ's **next step** as its main button, beside Edit / Withdraw / Decline:
  - Received / In progress → **Submit for review** (owner / Manage DDQs), once it has questions.
  - In review, answers waiting → **Approve all that can be given** (approvers).
  - **Ready to send** → **Mark as sent** (Manage DDQs).
  - Sent → **Start the next one from this** (already there).
- The status beside the title reads **Ready to send** (green) once every question is approved or Not answered, not just "In review".
- When the DDQ is ready, a short line under the header points to what's left: "Ready to send — download the completed questionnaire and the evidence pack, then mark it as sent", with links to those cards.
- The Review card keeps its buttons; the header just repeats the one that matters now.

## My calls

- One main button at a time, chosen by the DDQ's state and the person's permissions. Approve-all only appears when there's something to approve.
- No change to what any step does.

**Done when:** on a DDQ with 96 approved questions, Mark as sent is visible in the header without scrolling, and the status says Ready to send.
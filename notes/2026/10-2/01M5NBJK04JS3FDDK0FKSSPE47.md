---
id: 01M5NBJK04JS3FDDK0FKSSPE47
created: 2026-10-23T21:44:50.948091Z
updated: 2026-10-25T16:24:23.594908Z
type: task
title: A DDQ's next step is in its page header — Submit for review, Approve all, Mark as sent — not only on the Review card, which a long question list pushes out of sight
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1274
sprint: shig2cj
comments:
- id: 01M5PXKQYM1J1Z40BP0ECTT16T
  author: Steve Vine
  at: 2026-10-24T12:19:17.588584Z
  text: |-
    Done — merged in #1288.

    What changed: the main button in a DDQ's page header is now its next step, next to Edit / Withdraw / Decline:
    - Submit for review, while it's being worked and has questions (people who manage DDQs).
    - Approve all that can be given, while answers are waiting (approvers).
    - Mark as sent, once it's ready (people who manage DDQs).
    - A sent DDQ still offers Start the next one from this.

    Once every question is approved or Not answered, the status beside the title reads Ready to send, in green. While it's ready, a line under the header says "Ready to send — download the completed questionnaire and the evidence pack, then mark it as sent", and the two names link down to those cards. The Review card keeps all its buttons, and every step does exactly what it did before.

    My calls:
    1. One main button at a time, chosen by where the DDQ stands and what you're allowed to do. Approve all only appears when an answer is waiting.
    2. An approver who can't manage DDQs now sees a button in the header (Approve all). Before, they saw nothing there. Read-only people still see none.
    3. Approve all from the header shows its result as a pop-up note ("Approved 12. 2 held back, so left as they are.").
    4. The Ready to send line is a status note shown only while the DDQ is ready, not a permanent subtitle. Only people who can send see it.
    5. The Requests list still says "In review" for a ready DDQ. Only the DDQ's own page says Ready to send.

    To check on staging: open DDQ-1 (96 approved). It should read Ready to send, with Mark as sent in the header without scrolling. Also try a DDQ in progress (Submit for review), and one in review with answers waiting, signed in as an approver (Approve all).
assignee: steve
label:
- feature
priority: high
task_status: done
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
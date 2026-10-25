---
id: 01M5SA8SZ8D1B5TMYAK5GT1WA4
created: 2026-10-25T10:38:59.560157Z
updated: 2026-10-25T12:23:24.860182Z
type: task
title: 'DDQ: "Download evidence pack" sits beside "Download completed file" — the separate Evidence pack card goes'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1302
sprint: ssgnel8
comments:
- id: 01M5SG7WBC39KAYK4XXDMB94ZN
  author: Steve Vine
  at: 2026-10-25T12:23:20.684625Z
  text: |-
    Done — merged to main (PR #1311, ab2757eb).

    - **Download evidence pack** now sits beside Download completed file (or Copy reply / Download record) on the Completed questionnaire card, from In review on. Under it the card says what the pack will hold, or shows "No evidence to include" with the button disabled.
    - **"Left out of the evidence pack · n"** sits beside Left blank in the same card.
    - The separate Evidence pack card, and its "Save it again" line, are gone.
    - The "evidence pack" link in the ready-to-send note goes to the Completed card. The Mark as sent window's hint now says to download it from there.

    My calls (awaiting you), as in the task:
    - The left-out list moves into the Completed card rather than disappearing.
    - "Save it again" is dropped.
    - The card keeps the title "Completed questionnaire".

    Note: a sent DDQ's page shows neither card (as before), so the pack button appears only while the DDQ is In review.
assignee: steve
priority: medium
task_status: review
---
## What Steve said

"Can you create a separate 'Download evidence pack' button next to the 'Download completed file' button and then remove completely the 'Evidence pack' section from the right hand pane, keeping both actions in the same place."

## Behaviour

- **The Completed questionnaire card** has two buttons side by side: **Download completed file** and **Download evidence pack**. The first reads **Copy reply** for an email questionnaire, or **Download record** for an online one.
- **Download evidence pack** works as the old card's Download did:
  - it makes the zip of the evidence on approved answers that can be given to this client (or was released), every PDF watermarked for them, with an index of question to file;
  - it saves it as "DDQ-4 evidence pack 2026-10-25.zip";
  - while it's being made, the button shows it's working, and any error shows beneath it.
- **Under the evidence pack button:** what the pack will hold ("2 files"), or **"No evidence to include"** with the button disabled when no answer has any.
- **Anything the pack leaves out** is listed in the card beside "Left blank", headed **"Left out of the evidence pack · n"**. Each entry names the item, which questions it's on, and why (held back, linking to Held back; or unavailable and why). So nothing is dropped without saying so.
- **The Evidence pack card is removed** from the right-hand pane completely. Its "Last made… · Save it again" line goes too: each download makes a fresh pack, and every download is still recorded in History.
- **When it shows:** the same as the old card. From when the questionnaire is In review, and after it's Sent. Not for withdrawn or declined questionnaires, and only for people who manage DDQs.
- Any link that pointed at the old card, such as the "evidence pack" link in the next-step text, now points at the Completed questionnaire card.

## My calls (awaiting Steve)

- The left-out list moves into the Completed questionnaire card rather than disappearing. Without it, a held-back file would be missing from the pack with no explanation.
- "Save it again" (re-downloading the last pack made) is dropped. Download evidence pack makes a fresh one in a few seconds, and History still records each download.
- The card keeps its title, "Completed questionnaire".

## Implementation notes

- `src/ddq/completed/CompletedCard.tsx`: add a `PackAction` beside `CompletedAction` in the button `Group`, using `useDdqPackSummary` / `useDownloadPack` from `src/ddq/pack/hooks.ts`. Add a `Listed`-style "Left out of the evidence pack" block reusing `LeftOutLine`; move it to a shared spot.
- Remove `DdqPackCard` from `src/pages/DdqRequestPage.tsx`'s card list. Delete `PackCard.tsx`, or keep only what's reused.
- `src/ddq/review/NextStep.tsx:101`: change `#evidence-pack` → `#completed`.
- The completed card currently shows from `hasCompleted(status)`, and the pack from in_review and sent. Check they match, so both buttons appear together.
- Update the tests for both cards and the page's card order.
- Independent: frontend only.

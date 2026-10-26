---
id: 01M5VNKW1CQETC1M8FB8GD096C
created: 2026-10-26T08:35:45.324112Z
updated: 2026-10-26T12:11:21.761219Z
type: task
title: The Polaris conversation — type a prompt, watch the answer stream in with what Polaris is doing, answer its "wants to" cards, and stop it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1333
sprint: s9ls6e7
blocked_by:
- 01M5VNKKW7C21XYT18NXG6VFND
- 01M5VNK363X8HPD6TW8KXZVVFG
- 01M5VNKA3PAFQ4YN339B8FMJVP
comments:
- id: 01M5W1YHZTDFVQ8WXX1H78CCH1
  author: Steve Vine
  at: 2026-10-26T12:11:18.394564Z
  text: |-
    Done — merged to main (PR #1350).

    - **The prompt box:**
      - Enter sends, and Shift+Enter starts a new line. The box grows to five lines.
      - While Polaris works, Send becomes Stop.
      - A refused prompt keeps what you typed, and shows the reason in Compass's words.
    - **The answer streams in** as it's written:
      - formatted as Markdown, including tables;
      - DDQ references (DDQ-4) and control references (ACC.2) become links that open on the page behind; the window stays open.
    - **What Polaris is doing** shows as quiet lines between paragraphs, with a spinner, ✓ or ✕.
    - **Change cards:**
      - "Polaris wants to: …", then exactly what it would send, as a readable list, marked "Can't be undone" or "Asks every time" when they apply.
      - Buttons: Allow, Allow for this conversation (hidden when it always asks), and Deny.
      - Your choice shows on the card, and Polaris carries on.
    - **Notes** (a spending limit reached, switched off, a provider error, stopped) show as a plain coloured line, never a pop-up.
    - **The status bar** has New conversation, and your conversations with title and date, each with Delete behind a confirm.
    - **The window remembers** the conversation you were last in. One still running is followed; one cut off by a restart says so.
    - **If Polaris is switched off or paused while the window is open**, the window stays and says why, and the prompt box waits.
    - **Before your first prompt**, two or three suggestions for the section you're on. On a DDQ: "Draft the questions that are with Polaris" and "What's still unanswered?".

    My calls (beyond the task):
    - **Tool lines can't be expanded.** The stored record carries only the tool's name and whether it worked. Expanding to show the detail would be a follow-up.
    - **Only DDQ and control references become links.** Other references (RSK-12, INC-4) stay as text for now.
    - **A conversation reopened mid-answer** shows "Polaris is still working on this…" rather than the words so far, so nothing appears twice. The full answer appears when it ends.
    - **Tables needed a new library (remark-gfm 4.0.1).** It was installed without any package version newer than 1 October.
assignee: steve
label:
- feature
priority: high
task_status: review
---
## Behaviour

Like the Claude desktop app, inside the Polaris window.

- **The prompt box.**
  - Enter sends; Shift+Enter makes a new line. It grows as you type, up to a few lines.
  - While Polaris is working it shows **Stop** instead of Send.
- **The answer streams in** as it's written. It's formatted (headings, lists, tables, code), and a record it names (DDQ-4, RSK-12, a control) is a link that opens on the page behind the window.
- **What Polaris is doing** shows between paragraphs as quiet one-liners, for example "Read DDQ-4 · 29 questions" or "Searched the library for 'backup'". Each can be expanded to show the detail.
- **"Wants to" cards** (from the ask-before-change task) appear in the conversation where Polaris paused, with Allow / Allow for this conversation / Deny.
- **The conversations list** (from the conversations task) opens from the status bar, along with New conversation.
- **Messages:**
  - a spend limit reached: "back at 15:00";
  - Polaris switched off by an administrator;
  - the provider failing.

  Each appears in the conversation as a plain line, not a pop-up.
- **The empty state**, before your first prompt, suggests two or three prompts for the page you're on. On a DDQ, for example: "Draft the questions that are with Polaris" or "What's still unanswered?"

## My calls (awaiting Steve)

- Record links open on the main page behind the window, and the window stays open.
- Suggested prompts are fixed per section, not generated.

## Notes

- **Independent** (frontend only). Builds on the window, engine, ask-before-change and conversations tasks.
- Stream: EventSource (or fetch streaming) against the engine's SSE. Reconnect on drop, and resume from the stored conversation.
- Markdown: reuse whatever renderer the app already has if there is one. No raw HTML, and sanitise.
- [[react-hooks-lint-is-strict]]: no setState inside effects for the stream. Use a reducer fed by the event handler.

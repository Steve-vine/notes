---
id: 01M5VNKW1CQETC1M8FB8GD096C
created: 2026-10-26T08:35:45.324112Z
updated: 2026-10-26T11:04:31.909528Z
type: task
title: The Polaris conversation — type a prompt, watch the answer stream in with what Polaris is doing, answer its "wants to" cards, and stop it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1333
sprint: s9ls6e7
blocked_by:
- 01M5VNKKW7C21XYT18NXG6VFND
- 01M5VNK363X8HPD6TW8KXZVVFG
- 01M5VNKA3PAFQ4YN339B8FMJVP
assignee: steve
label:
- feature
priority: high
task_status: active
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

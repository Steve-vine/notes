---
id: 01M3MYKK5XQAFZP6K633JNCSMX
created: 2026-09-28T21:26:48.765938Z
updated: 2026-09-28T21:53:52.364292Z
type: task
title: 'Website: FAQ page — categories and search'
project: 01KY6W9951TW0904DT0GGJVGE7
number: 490
sprint: spqrtwg
blocked_by:
- 01M3MY1APNGC5GRXYGCCWJJ9T3
assignee: steve
label:
- brief
priority: medium
task_status: active
tech: null
---
The design's FAQ, "Questions, answered plainly.": six categories (General, Your notes, Sync, AI and integrations, Privacy, Updates), a category list with counts, a search box, and expanding answers.

## Scope

- [ ] Questions in one data file, starting from the design's `faqData`.
- [ ] Answers use native `<details>`, so they work without JavaScript. A small script adds search filtering and the category counts.
- [ ] Check every answer against the app. In particular, the Privacy answers ("Only one thing… anonymous check-in") must match the privacy policy after NOT-471 adds feature requests. "Is it free?" follows the pricing decision.

**Done when:** the page matches the design, every answer is true, and it works with JavaScript off.
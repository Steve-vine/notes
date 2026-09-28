---
id: 01M3MYKK5XQAFZP6K633JNCSMX
created: 2026-09-28T21:26:48.765938Z
updated: 2026-09-28T22:06:53.10623Z
type: task
title: 'Website: FAQ page — categories and search'
project: 01KY6W9951TW0904DT0GGJVGE7
number: 490
sprint: spqrtwg
blocked_by:
- 01M3MY1APNGC5GRXYGCCWJJ9T3
comments:
- id: 01M3N0W651QJC5Q8SC1TB5R03M
  author: Steve Vine
  at: 2026-09-28T22:06:27.489653Z
  text: |-
    Built and pushed to staging (d345257).
    - /faq/: the design's six categories with a sticky aside (search and categories with live counts). Answers are native <details>, so everything works with JavaScript off. A small script adds search (it opens the matches and closes them again when cleared), category filtering, and the "Nothing matches that search." state. The data lives in src/data/faq.ts.
    - Tested in headless Chromium: search, counts, the empty state and the category filter work, and all 20 answers are reachable with JavaScript off.
    - Every answer is checked against the app. Changes from the design:
      - "Is it free?" is a plain yes, with no pricing.
      - Privacy covers both the daily check-in and feature requests (email and message). A new question explains that sending a request makes an install's check-ins linkable to your email (check-ins kept 13 months, requests 12). Both link to /privacy/, and they match the policy.
      - History needs Git sync.
      - Encryption adds that with Git sync, versions saved before encryption stay in history.
      - The API answer is off by default, local unless you open it to your network, and needs a key on every request.
      - Import is markdown files or folders, and the update flow is described accurately.
    - Question for Steve: the "What changed in the latest version?" answer says every release ships with notes, but the change log starts at 0.31.0. Is that wording OK?
    To look at: /faq/ with a search, a category click, and phone width.
assignee: steve
label:
- brief
priority: medium
task_status: review
tech: null
---
The design's FAQ, "Questions, answered plainly.": six categories (General, Your notes, Sync, AI and integrations, Privacy, Updates), a category list with counts, a search box, and expanding answers.

## Scope

- [ ] Questions in one data file, starting from the design's `faqData`.
- [ ] Answers use native `<details>`, so they work without JavaScript. A small script adds search filtering and the category counts.
- [ ] Check every answer against the app. In particular, the Privacy answers ("Only one thing… anonymous check-in") must match the privacy policy after NOT-471 adds feature requests. "Is it free?" follows the pricing decision.

**Done when:** the page matches the design, every answer is true, and it works with JavaScript off.
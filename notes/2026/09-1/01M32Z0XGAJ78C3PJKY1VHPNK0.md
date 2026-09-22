---
id: 01M32Z0XGAJ78C3PJKY1VHPNK0
created: 2026-09-21T21:47:45.546248Z
updated: 2026-09-22T20:55:16.892455Z
type: task
title: Add a social card image for link previews
project: 01M32Q7WT6058ZQFMMRM8KP1K6
number: 8
assignee: steve
label:
- improvement
priority: low
task_status: active
---
When the site's address is pasted into Slack, LinkedIn, Teams or a message, it currently shows a title and description but no picture.

Make one card - the Compass mark, "Compass Integrated Trust Platform" and the one-line description, in the site's colours - and use it for the home page and as the default for docs pages.

Done when: pasting the live address into Slack and LinkedIn shows the card.

Technical: 1200x630 PNG in public/. og:image and twitter:image (card type summary_large_image) in src/layouts/Base.astro, and Starlight's `head` option in astro.config.mjs for the docs. Can only be checked properly once the site is live.
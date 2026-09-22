---
id: 01M32Z0XGAJ78C3PJKY1VHPNK0
created: 2026-09-21T21:47:45.546248Z
updated: 2026-09-22T20:56:40.476533Z
type: task
title: Add a social card image for link previews
project: 01M32Q7WT6058ZQFMMRM8KP1K6
number: 8
comments:
- id: 01M35EG38WSKNS2GBZ1X74YDNY
  author: Steve Vine
  at: 2026-09-22T20:56:40.476307Z
  text: |-
    Pushed to staging. git pull only.

    What changed: a 1200x630 card at /social-card.png - the Compass mark, "Compass", "Integrated Trust Platform", the home page's one-liner and compassitp.com, on the dark ground in Inter. Every page (product pages and docs) now names it as the preview image, with the large-image card type.

    To check now: open public/social-card.png in the repo, or http://localhost:4321/social-card.png, and say if the wording or layout wants changing. Regenerate with `node scripts/social-card.mjs` after any edit (needs Inter installed as a system font; it is on g5 now).

    To check after launch: paste https://compassitp.com into Slack and LinkedIn. That is the task's "done when" and cannot be done before the site is live, so leave this in Review until then. Slack and LinkedIn cache previews, so a card changed after launch needs their debug tools to refresh (LinkedIn Post Inspector; Slack re-fetches on a new message after a while).

    Technical: og:image / og:image:width / og:image:height / og:image:alt and twitter:card=summary_large_image / twitter:image in src/layouts/Base.astro; the same via Starlight's `head` option in astro.config.mjs for docs pages (Starlight's own twitter:card=summary is replaced, checked in the built HTML).
assignee: steve
label:
- improvement
priority: low
task_status: review
---
When the site's address is pasted into Slack, LinkedIn, Teams or a message, it currently shows a title and description but no picture.

Make one card - the Compass mark, "Compass Integrated Trust Platform" and the one-line description, in the site's colours - and use it for the home page and as the default for docs pages.

Done when: pasting the live address into Slack and LinkedIn shows the card.

Technical: 1200x630 PNG in public/. og:image and twitter:image (card type summary_large_image) in src/layouts/Base.astro, and Starlight's `head` option in astro.config.mjs for the docs. Can only be checked properly once the site is live.
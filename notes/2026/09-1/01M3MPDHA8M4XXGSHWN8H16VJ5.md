---
id: 01M3MPDHA8M4XXGSHWN8H16VJ5
created: 2026-09-28T19:03:41.640737Z
updated: 2026-09-28T22:06:51.303556Z
type: task
title: Website Changelog page from changelog.json
project: 01KY6W9951TW0904DT0GGJVGE7
number: 477
sprint: spqrtwg
blocked_by:
- 01M3MPD2B1DPBCJVBF75YE2XJ9
- 01M3MY1APNGC5GRXYGCCWJJ9T3
comments:
- id: 01M3MY2MQHTAY9HKD88WTW2W5Q
  author: Steve Vine
  at: 2026-09-28T21:17:33.296879Z
  text: 'Website stack decided (2026-09-28): Astro + Starlight, repo Steve-vine/notuvia-website (website ADR 0002). Website ADR 0003 (proposed) settles the open question here: changelog.json is a build-time input, not a client fetch. The page is an Astro page using StarlightPage. A 404 (the feed first publishes with 0.31.0) renders an empty state; any other failure fails the build. The site rebuilds on release via NOT-483. Now blocked on the scaffold (NOT-478) instead of "no website".'
- id: 01M3N0VY4PKN30BM20BVK1JJF0
  author: Steve Vine
  at: 2026-09-28T22:06:19.286268Z
  text: |-
    Built and pushed to staging (b6c4873).
    - /changelog/ is built from the update channel's changelog.json at build time (src/lib/changelog.ts), the same feed the app's What's new dialog reads. Releases are newest first, each with version, date, summary and New / Improved / Fixed. Bullets use the app's inline-markdown rules: escaped first, http(s) links only, checked with a `<script>` test bullet.
    - The feed doesn't exist until 0.31.0, so the page shows an empty state ("The change log starts with version 0.31.0") and the build passes. Any other feed failure fails the build.
    - To preview a populated page: `CHANGELOG_FIXTURE=/path/feed.json npm run build`, with a file in the schema-1 shape.
    - Still open on the app side: point Settings → About → View changelog's offline fallback at notuvia.com/changelog/ (NOT-484).
    To look at: /changelog/ and the footer's Change Log link.
assignee: steve
label:
- feature
priority: low
task_status: review
tech: null
---
**On hold until the Notuvia website exists.** As of 2026-09-28 there's no public site: only `updates.notuvia.net` and `checkin.notuvia.net`. This is the same blocker as NOT-471.

## Agreed work

- [ ] A Changelog page on the website, rendered from the channel's `changelog.json` (the schema-1 contract from the changelog-feed task). Use it as a build-time input or a client fetch, whichever the site's stack suits. It must never be hand-edited copy, so it stays in step with the in-app What's new dialog.
- [ ] Same content and order as the app: newest first, with version, date, summary and the New / Improved / Fixed sections.
- [ ] Point Settings → About → View changelog's offline fallback link at the website page instead of the channel's `changelog.html`. Keep `changelog.html` on the channel, or retire it, as ADR 0066 decides.
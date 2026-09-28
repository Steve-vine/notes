---
id: 01M3MPDBR463R563MEQWSMJZTW
created: 2026-09-28T19:03:35.940905Z
updated: 2026-09-28T19:59:25.139628Z
type: task
title: What's new covers skipped versions, and Settings → About shows the changelog
project: 01KY6W9951TW0904DT0GGJVGE7
number: 476
sprint: smd2199
blocked_by:
- 01M3MPD2B1DPBCJVBF75YE2XJ9
comments:
- id: 01M3MSKJEKV0S9T057MP9SH5AM
  author: Steve Vine
  at: 2026-09-28T19:59:25.1392Z
  text: |-
    Built. PR #481 (brief-476-whats-new-changelog), in Review.

    What landed:
    - notuvia_core::changelog::fetch (curl GET, 10s cap, no identifiers) and the fetch_changelog command. A test pins the URL to the updater channel.
    - src/lib/changelog.ts: parseChangelog (schema 1, tolerant of malformed entries), releasesBetween (from < v ≤ current), releaseMarkdown, releaseDate and compactNotes.
    - What's new opens at once with the stash, then swaps in the feed's releases when they load. One release reads as before, several get version/date headings, and the stash and no-notes fallbacks stay.
    - Settings → About → View changelog opens the same dialog in changelog mode (loading, offline with the changelog.html link, or empty). Settings leaves Esc to the dialog while it's open.

    Found and fixed along the way: the note renderer turns each blank line into an empty paragraph (DEV-603), which put a large gap either side of every section heading. The current stash path had it too. compactNotes drops the blank lines before rendering.

    Verification: 12 TS tests and 2 Rust tests. npm test 467/467, check and build ok, Rust fmt/clippy clean, notuvia-core 434/434. Checked visually in the uilab harness in headless Chrome, across four states in both themes.

    Still needed: Steve's visual check in the real app. View changelog will show the offline message until 0.31.0 publishes a feed.
assignee: steve
label:
- feature
priority: medium
task_status: review
tech: null
---
Today the What's new dialog (NOT-390) only shows the notes for the version just installed. An install going from 0.31 to 0.33 never sees 0.32's notes. This task reads the changelog feed so the in-app notes match the public changelog.

## Agreed work

- [ ] Add a Rust command that fetches `https://updates.notuvia.net/changelog.json`, using the same HTTP client and timeout style as the updater and check-in. It's a plain GET with no identifiers or query string. Fetching from Rust avoids CORS on the channel.
- [ ] Extend `whatsNew` in `releaseNotes.ts` to return every release where `from < v ≤ current` (semver compare), newest first. Render each release as its own block: a version heading with the date, the summary, then the sections.
- [ ] Fallbacks, in order: the feed; then the stash (still written on the way out, as now); then the existing "No release notes came with this update" message. A fetch failure never blocks or delays the dialog: show the stash and don't retry.
- [ ] Updating from a version before 0.31.0: show whatever the feed has from 0.31.0 onwards. No backfill is intended (ADR 0066).
- [ ] In Settings → About, add a **View changelog** button that opens the same dialog in list mode with the full feed. When offline, it says it couldn't load and offers the channel's `changelog.html` link.
- [ ] Tests in `releaseNotes.test.ts`: version range selection (skipped, same, downgrade, pre-0.31 `from`) and each fallback.

## Notes

This is a UI change, so a visual check is needed from Steve (no screen capture). Use the restyle idioms from ADR 0063.
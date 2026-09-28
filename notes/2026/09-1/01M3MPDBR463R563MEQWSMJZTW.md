---
id: 01M3MPDBR463R563MEQWSMJZTW
created: 2026-09-28T19:03:35.940905Z
updated: 2026-09-28T19:03:54.068329Z
type: task
title: What's new covers skipped versions, and Settings → About shows the changelog
project: 01KY6W9951TW0904DT0GGJVGE7
number: 476
sprint: smd2199
blocked_by:
- 01M3MPD2B1DPBCJVBF75YE2XJ9
assignee: steve
label:
- feature
priority: medium
task_status: todo
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
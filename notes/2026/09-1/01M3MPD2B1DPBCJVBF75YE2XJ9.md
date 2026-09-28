---
id: 01M3MPD2B1DPBCJVBF75YE2XJ9
created: 2026-09-28T19:03:26.305948Z
updated: 2026-09-28T19:03:52.995424Z
type: task
title: Changelog feed on the update channel, plus generated CHANGELOG.md
project: 01KY6W9951TW0904DT0GGJVGE7
number: 475
sprint: smd2199
blocked_by:
- 01M3MPBX991GHTEVQAAV1TP9PE
assignee: steve
label:
- feature
priority: medium
task_status: todo
tech: null
---
One changelog built from the approved release-notes files (ADR 0066). The app and the future website both read it, so the two can't drift apart.

## Agreed work

- [ ] Add a `release-notes.mjs build [--up-to X.Y.Z]` subcommand. It only includes approved files, newest first. `--up-to` leaves out approved notes for versions after the one being published, so notes written ahead of time never leak early. It generates:
  - **`CHANGELOG.md`** at the repo root: `## X.Y.Z (date)`, the summary, then the sections
  - **`changelog.json`**: `{ "schema": 1, "releases": [ { "version", "date", "summary", "new": [...], "improved": [...], "fixed": [...] } ] }`. Bullets are markdown strings. This is the contract the app and website read, so document it in `release-notes/README.md`.
  - **`changelog.html`**: a self-contained static page with no external assets, light and dark via `prefers-color-scheme`, readable at phone width. It's the public changelog until the website exists.
- [ ] `publish-release.mjs` builds and uploads `changelog.json` and `changelog.html` to the channel root **before** `latest.json`, so an app that updates and then fetches the feed always finds its own version. Use the same short cache headers as `latest.json`.
- [ ] A `build --check` step in the `ci.yml` lint job fails if the committed `CHANGELOG.md` doesn't match the notes files. The bump PR regenerates it.
- [ ] Tests: ordering, `--up-to`, drafts left out, the JSON shape, and a sync-check failure.

## Notes

- The files are world-readable, the same as `latest.json`. That's fine, because the notes are public by design.
- Check whether the channel needs a CORS header, depending on how the in-app task fetches the feed. Fetching from Rust avoids the question.
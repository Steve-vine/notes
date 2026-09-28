---
id: 01M3MPCS8JHFQKXT1MFYZRS5FY
created: 2026-09-28T19:03:17.010382Z
updated: 2026-09-28T19:39:38.78787Z
type: task
title: Release CI ships the approved notes file, plus docs/releasing.md
project: 01KY6W9951TW0904DT0GGJVGE7
number: 474
sprint: smd2199
blocked_by:
- 01M3MPBX991GHTEVQAAV1TP9PE
comments:
- id: 01M3MRFBX3CAVW520WXYY51TC9
  author: Steve Vine
  at: 2026-09-28T19:39:38.787392Z
  text: |-
    Built. PR #479 (brief-474-release-ci-notes), in Review.

    What landed:
    - release-notes.mjs check X.Y.Z (missing, non-linting or draft notes all fail, with file:line) and render X.Y.Z (the summary paragraph, then the sections).
    - release-app.yml runs check right after setup-node, before the build. The GitHub release body is the rendered notes + "---" + the generate-notes API's PR list. Publish uses --notes-file and no longer reads the release body. The dispatch dry run uses the notes file if it exists.
    - publish-release.mjs --notes-file validates the file, refuses one for another version, and publishes the rendered notes. --notes stays for the manual path.
    - UpdateBanner shows only notesSummary(): the first paragraph, or nothing for notes in the old heading/list shape.
    - docs/releasing.md covers the whole process and the failure modes. CLAUDE.md and release-notes/README.md link to it.

    Changed from the task text: added a CLAUDE.md standards line pointing at docs/releasing.md.

    Verification: new check/render and notesSummary tests. npm test 460/460, check 0 errors, build ok. publish-release --dry-run --notes-file smoke-tested for the good, wrong-version and non-linting cases. The live test is 0.31.0.

    Merge note: this is off main next to #478. Both change main() in release-notes.mjs, so the second to merge needs a small rebase.
assignee: steve
label:
- feature
priority: high
task_status: review
tech: null
---
Enforces the review gate from ADR 0066, and stops the private PR list reaching users.

## Agreed work

- [ ] Add a `release-notes.mjs check X.Y.Z` subcommand. It fails unless `release-notes/X.Y.Z.md` exists, passes lint, and has `status: approved`.
- [ ] In `release-app.yml`, run `check` straight after the "Tag must match the app version" step, so an unapproved release fails in seconds rather than after the 20-minute build.
- [ ] Channel notes come from the file, not the GitHub release body. `publish-release.mjs` takes `--notes-file release-notes/X.Y.Z.md` and writes the `latest.json` `notes` as the summary as the first paragraph, then the sections as markdown, with no frontmatter. Keep `--notes` for the manual fallback path.
- [ ] The GitHub release body is the same user notes, then a `---`, then the generated PR list (via `gh api …/releases/generate-notes`). The PR list is still provenance, but it only exists on the private release now. Pass it to `gh release create` with `--notes-file`.
- [ ] The `workflow_dispatch` dry run uses the notes file if one exists for the version, and otherwise a dummy.
- [ ] `UpdateBanner.svelte` currently prints the whole manifest notes as plain text. Change it to show only the first paragraph (the summary). The full notes are for the What's new dialog.
- [ ] Update the comments in `ReleaseNotes.svelte`, `releaseNotes.ts` and `release-app.yml` that describe the notes as "the GitHub release body / `--generate-notes`".
- [ ] Write `docs/releasing.md`, the whole process from start to finish:
  1. `bump-version.mjs` bumps the version and drafts the notes
  2. Claude rewrites the draft into user language in the bump PR
  3. Steve reviews it and sets `status: approved`
  4. squash-merge
  5. push the `v`/`mcp` tags
  6. CI builds, signs and publishes
  7. check What's new and the channel
  Include the gotchas: the Cloudflare token scope, and deleting a half-made GitHub release before rerunning. Link it from `release-notes/README.md`.

## Notes

0.31.0 is the first release to go through this. Treat it as the pilot, and fix the process doc afterwards to match what actually happened.
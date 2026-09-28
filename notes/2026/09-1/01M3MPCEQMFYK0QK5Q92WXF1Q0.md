---
id: 01M3MPCEQMFYK0QK5Q92WXF1Q0
created: 2026-09-28T19:03:06.228118Z
updated: 2026-09-28T19:35:43.34652Z
type: task
title: Release-notes draft generator, run by bump-version
project: 01KY6W9951TW0904DT0GGJVGE7
number: 473
sprint: smd2199
blocked_by:
- 01M3MPBX991GHTEVQAAV1TP9PE
comments:
- id: 01M3MR85ZJKGYHTQ3M0JPVC0RB
  author: Steve Vine
  at: 2026-09-28T19:35:43.346063Z
  text: |-
    Built. PR #478 (brief-473-release-notes-draft), in Review.

    What landed:
    - release-notes.mjs draft X.Y.Z [--force] reads the subjects since the last v* tag with local git only, skipping version bumps. feat goes to New, fix to Fixed, and perf and untyped subjects to Improved. chore, ci, docs, test, build, refactor, style and reverts are left out. Task, ADR and PR refs are stripped from each bullet.
    - The file has status: draft and summary: TODO. The HTML comment lists every subject, marked where it was left out. A release with nothing user-facing gets "## Improved - TODO", so it still lints as a draft but can't pass as approved.
    - It refuses to overwrite without --force.
    - bump-version.mjs runs the draft after bumping and skips it if the file already exists. Its closing instructions now include rewriting and approving the notes.
    - git runs with the GIT_* variables scrubbed (DEV-922).

    Changed from the task text: refactor is left out, not put under Improved. A script can't tell which refactors users would see, and the comment still lists them.

    Verification: 17 new tests (real git in throwaway repos). npm test 472/472, npm run check 0 errors. A dry draft of 0.31.0 against this repo worked, and I deleted the file afterwards.
assignee: steve
label:
- feature
priority: medium
task_status: review
tech: null
---
So that every bump PR starts with a notes draft to rewrite, rather than a blank page. Builds on the parser and format from the lint task (ADR 0066).

## Agreed work

- [ ] Add a `release-notes.mjs draft X.Y.Z` subcommand. It finds the previous `v*` tag and reads the squash-merge subjects since then from `git log`. Local git only: no `gh`, so it works offline.
- [ ] Sort the subjects by conventional-commit type:
  - `feat` goes to **New**
  - `fix` goes to **Fixed**
  - `perf`, and `refactor` subjects that change something users can see, go to **Improved**
  - `chore`, `ci`, `docs`, `test` and `build` are left out of the bullets
- [ ] Each draft bullet is the subject with its prefix, `(NOT-…)`, ADR refs and `(#N)` stripped, so it's a starting point for the rewrite.
- [ ] The output file has `status: draft`, today's `date`, and `summary: TODO`.
- [ ] Below the sections, an HTML comment lists **every** subject since the last tag, including the ones left out, with NOT ids and PR numbers. The writer can check nothing user-facing was missed. The lint task rejects this comment in an approved file, so it has to be deleted before approval.
- [ ] The subcommand refuses to overwrite an existing file unless given `--force`, and the output passes `lint` as a draft.
- [ ] `scripts/bump-version.mjs X.Y.Z` runs the draft step after bumping. It skips the step, with a message, if the notes file already exists (written ahead of time).
- [ ] Tests run against a throwaway git repo: sorting, stripping, the comment block, the refusal to overwrite, and no previous tag (every commit is included).

## Notes

After drafting, Claude rewrites the bullets into user language in the bump PR and Steve reviews them there. The process doc comes with the CI-gate task.
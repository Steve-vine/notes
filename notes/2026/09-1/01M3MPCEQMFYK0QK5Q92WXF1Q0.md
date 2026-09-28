---
id: 01M3MPCEQMFYK0QK5Q92WXF1Q0
created: 2026-09-28T19:03:06.228118Z
updated: 2026-09-28T19:32:40.709469Z
type: task
title: Release-notes draft generator, run by bump-version
project: 01KY6W9951TW0904DT0GGJVGE7
number: 473
sprint: smd2199
blocked_by:
- 01M3MPBX991GHTEVQAAV1TP9PE
assignee: steve
label:
- feature
priority: medium
task_status: active
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
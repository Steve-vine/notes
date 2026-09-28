---
id: 01M3MPBX991GHTEVQAAV1TP9PE
created: 2026-09-28T19:02:48.361023Z
updated: 2026-09-28T19:10:37.2024Z
type: task
title: Release-notes format and lint, plus ADR 0066
project: 01KY6W9951TW0904DT0GGJVGE7
number: 472
sprint: smd2199
assignee: steve
label:
- feature
priority: high
task_status: active
tech: null
---
The foundation for the Release notes sprint: the standard format, a linter that enforces it, and the ADR. Everything else in the sprint builds on the parser that lands here. ADR 0066 lands with this PR.

## Why

Today the notes users see come from `gh release create --generate-notes`. For 0.30.0 that meant raw PR titles ("feat: notuvia-core sends feature requests (NOT-468, ADR 0065) by @Steve-vine") and links into the private repo, shown in the What's new dialog and published on the world-readable update channel.

## ADR 0066: release notes are reviewed files in the repo

Record these decisions (agreed with Steve on 2026-09-28):

- **Source of truth:** one file per version, `release-notes/X.Y.Z.md`, starting with the next release (0.31.0). **No backfill.** Earlier releases have no entry and the changelog starts at 0.31.0.
- **Format.** Frontmatter:
  - `version`: must match the filename
  - `date`: `YYYY-MM-DD`
  - `status`: `draft` or `approved`
  - `summary`: one user-facing line, at most 120 chars
- **Body:** only `## New`, `## Improved` and `## Fixed`, in that order. Leave out any that are empty, but include at least one. Bullets only (`- `), one change per bullet, written for users.
- **Style rules:** notes are for users, not developers. Leave out NOT-/DEV- ids, PR refs (`#123`), GitHub URLs, @handles, conventional-commit prefixes (`feat:`, `fix:` …) and ADR references. Internal-only changes (CI, refactors, chores) don't appear at all.
- **Review gate:** notes are drafted into the bump PR and rewritten into user language there. Steve reviews them in the PR and approves by setting `status: approved`. The release workflow refuses to ship a version whose file is missing, fails lint, or isn't approved (enforced by the CI-gate task).
- **Notes are public.** They go to the update channel, the in-app What's new dialog and, later, the website. The generated PR list stays on the private GitHub release only.
- **One source feeds everything:** the `latest.json` notes, the GitHub release body, a `changelog.json`/`changelog.html` feed on `updates.notuvia.net`, and a generated `CHANGELOG.md`.
- **Out of scope:** `notuvia-mcp` releases keep their fixed one-line note.

## Agreed work

- [ ] `scripts/release-notes.mjs` with a `lint [files…]` subcommand (all of `release-notes/*.md` by default). Export the parse and validate functions so the draft, check and build subcommands in later tasks reuse them.
- [ ] Validation covers the frontmatter schema, filename/version match, the section set and order, bullets only, and the style rules above. An `approved` file additionally must not contain `TODO` placeholders or HTML comments, which is where the draft generator puts its raw PR list. A `draft` file only needs to be structurally valid.
- [ ] Errors report file:line and are clear enough to fix without reading the linter.
- [ ] `release-notes/README.md` covers the format, the style rules with good and bad examples, and a template.
- [ ] `npm run release-notes:lint`, plus a step in the `ci.yml` lint job.
- [ ] Tests in `scripts/release-notes.test.mjs`, on the same runner as `feature-requests.test.mjs`.
- [ ] ADR 0066 in `decisions/`.
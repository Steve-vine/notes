---
id: 01M3MY1RQ3JQAEVVE19WP06EBM
created: 2026-09-28T21:17:04.611058Z
updated: 2026-09-28T21:26:12.701735Z
type: task
title: Release CI rebuilds the website after publishing
project: 01KY6W9951TW0904DT0GGJVGE7
number: 483
sprint: spqrtwg
blocked_by:
- 01M3MY16A65JX6013JXE2Q3MZR
assignee: steve
label:
- chore
priority: medium
task_status: backlog
tech: null
---
Work in the **app** repo. The website builds the download and the changelog from the update channel, so the live site (branch `main`) has to rebuild when a release lands (website ADR 0003).

## Scope

- [ ] After `publish-release.mjs` succeeds, the release workflow sends a `repository_dispatch` to `Steve-vine/notuvia-website`. The website's CI rebuilds `main` and deploys it.
- [ ] Add a fine-grained token, scoped to that repo only, as an app-repo Actions secret. Steve sets it from a real terminal.
- [ ] Add a line to `docs/releasing.md`: publishing a release also refreshes notuvia.com.

**Done when:** a published release triggers the website's deploy, and the new version and changelog entry appear on notuvia.com.
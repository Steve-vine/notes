---
id: 01KY72ZSXW1RFNWQ46A80NNT0M
created: 2026-07-23T08:55:32.028826Z
updated: 2026-07-23T11:04:50.487738Z
type: task
title: Automate the version bump
assignee: steve
imported_from: linear
task_status: done
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 332
---
The 0.7.0 bump (#310) hand-edited seven files. Reduce the version to two sources of truth and script the rest:

* `[workspace.package] version` in `src-tauri/Cargo.toml`, with the three crates on `version.workspace = true`
* Drop `version` from `tauri.conf.json` (Tauri v2 falls back to Cargo.toml); repoint `scripts/publish-release.mjs`, which currently reads it from there
* `scripts/bump-version.mjs <version>`: validate semver > current, write `package.json` + workspace `Cargo.toml`, regenerate both lockfiles, print the changed files

Bump ceremony becomes: run the script, commit, PR, merge, push the `v`/`mcp-` tags.

---

Linear DEV-985 · created 2026-07-14 · done 2026-07-14
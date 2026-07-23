---
id: 01KY72WXEKWB1FPAB5X25SM6CY
created: 2026-07-23T08:53:57.331919Z
updated: 2026-07-23T08:53:57.331919Z
type: task
title: Updater signing keypair and signed update artifacts
task_status: done
assignee: steve
imported_from: linear
label: feature
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 319
---
Foundation for in-app updates (DEV-658, ADR 0042): every update the app installs must be signed, so the keypair and artifact generation come first.

Scope:

* Generate the updater keypair (`tauri signer generate`). The private key stays out of the repo — held locally and later added as a GitHub Actions secret (see the release-CI issue); the public key is committed in the updater config.
* Add `tauri-plugin-updater` to the shell (Cargo + plugin registration + capability/permission wiring) with the public key and the R2 manifest endpoint configured.
* Enable `createUpdaterArtifacts` in the bundle config so `tauri build` produces the update package (`.app.tar.gz`) and its `.sig` alongside the dmg.

Acceptance: a local `npm run tauri:build` emits the signed updater artifact, and the app compiles with the updater plugin registered. No UI yet — the in-app flow is its own issue.

---

Linear DEV-972 · Application Deployment & Update · created 2026-07-13 · done 2026-07-13
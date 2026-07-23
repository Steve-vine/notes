---
id: 01KY72XB581YQ6XDMTJCKX3WRD
created: 2026-07-23T08:54:11.368068Z
updated: 2026-07-23T09:08:58.842573Z
type: task
title: 'Release CI: build, sign, and publish to R2 on tag'
assignee: steve
number: 321
task_status: done
label: feature
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
---
Automate the release build (DEV-658, ADR 0042): pushing a `vX.Y.Z` tag produces and publishes everything the update channel needs — replacing today's manual local dmg build and upload.

Scope:

* A GitHub Actions workflow on `v*` tags using a macOS runner: frontend build, `tauri build` with updater artifacts, signing via the updater private key held as an Actions secret (DEV-972).
* Generate `latest.json` for the release (version, notes, per-platform url + signature) and upload dmg + updater artifact + manifest to R2 with the scoped token (DEV-973). The manifest upload is last, so a half-published release is never offered to clients.
* Fold in the headless artifacts: extend or chain `release-mcp.yml` so the Linux MCP tarballs also land in R2 (they currently go only to a private-repo GitHub release, which headless boxes can't fetch anonymously).
* Keep the GitHub release on the private repo as the provenance/notes record; update the release-process doc/memory once the flow settles.

Acceptance: pushing a tag yields a complete, installable release on R2 with no local build step.

---

Linear DEV-974 · Application Deployment & Update · created 2026-07-13 · done 2026-07-13
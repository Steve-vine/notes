---
id: 01M411MFR4WG0X6VF8H2S9PFFA
created: 2026-10-03T14:10:36.932236Z
updated: 2026-10-03T14:11:05.003315Z
type: task
title: 'Release pipeline for three platforms: matrix build, one latest.json, Windows and Linux installers'
project: 01KY6W9951TW0904DT0GGJVGE7
number: 503
sprint: sw66q9v
assignee: steve
label:
- brief
- chore
priority: medium
task_status: backlog
tech: null
---
So that a `v<version>` tag ships Windows and Linux builds alongside the macOS dmg, and running apps on every platform see the update. Today `release-app.yml` is a single `macos-latest` job and `latest.json` carries one platform entry.

**Draft — re-plan after NOT-498 reports. Last in the sprint: needs the app actually working on each platform first.**

## Proposed work

- [ ] `release-app.yml` `release` job becomes a matrix (macOS arm64, Linux x86_64, Windows x86_64); a final job assembles the GitHub release and the R2 publish once every leg is built, as `release-mcp.yml` already does.
- [ ] Packaging formats per ADR 0068: dmg (unchanged); Linux AppImage + deb; Windows NSIS `-setup.exe`. `bundle.targets` narrows from `all` to that list.
- [ ] `scripts/publish-release.mjs` writes one `latest.json` with `darwin-aarch64`, `linux-x86_64` and `windows-x86_64` entries, each with its own signature; uploads every artifact.
- [ ] Updater artifacts on all three are signed with the existing minisign key (that is the updater's integrity check, independent of OS code signing).
- [ ] Signing stance: unsigned on Windows (SmartScreen warning accepted and documented, as Gatekeeper is on macOS, ADR 0018); nothing needed on Linux.
- [ ] `docs/releasing.md` and the release-notes lint learn about the extra artifacts; `docs/packaging-macos.md` gains per-platform siblings or becomes `docs/packaging.md`.
- [ ] Website download page (NOT-?, Website sprint) flips Windows and Linux from "Coming soon" when the first release lands.

## Notes

The `release-mcp.yml` matrix is the pattern to copy. Consider adding a Windows leg there too, since `notuvia-mcp` on Windows is otherwise an untested binary.
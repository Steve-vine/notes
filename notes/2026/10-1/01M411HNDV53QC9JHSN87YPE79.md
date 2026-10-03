---
id: 01M411HNDV53QC9JHSN87YPE79
created: 2026-10-03T14:09:04.443815Z
updated: 2026-10-03T14:09:12.038276Z
type: task
title: 'Cross-platform CI probe: Linux and Windows bundle legs, plus ADR 0068'
project: 01KY6W9951TW0904DT0GGJVGE7
number: 498
sprint: sw66q9v
assignee: steve
label:
- brief
- chore
priority: high
task_status: active
tech: null
---
So that we know what actually breaks on Windows and Linux before planning the port, rather than discovering it mid-sprint. The whole Rust workspace already compiles on Linux (clippy runs on ubuntu); Windows has never been compiled; neither has ever been bundled.

## Agreed work

- [ ] ADR 0068 — cross-platform strategy: targets and packaging formats, signing stance, the capture-hotkey fallback for platforms where a global shortcut can't be registered, the watcher contract, how the WebView engine differences are handled, and the CI/release matrix shape. Extends ADR 0002 and ADR 0016; narrows ADR 0018 to "macOS only until now".
- [ ] `ci.yml` `build` job becomes a three-leg matrix (`macos-latest`, `ubuntu-latest`, `windows-latest`), still post-merge only (push to main), still skipping updater artifacts. `fail-fast: false` so one platform failing doesn't hide the other's result.
- [ ] Linux leg installs the Tauri system deps the lint/typecheck jobs already use; Windows leg needs nothing extra (WebView2 is on the runner).
- [ ] Each leg uploads its bundle directory as `notuvia-<os>` so the artifacts can be downloaded and tried by hand.
- [ ] Nothing in the app changes. Red legs are the point: the probe's output is the list of what fails, written back here as a comment, and the Cross-platform sprint's drafted briefs are re-planned from it.

## Notes

The probe runs post-merge, so the first result arrives on the merge of this PR. The ubuntu leg is expected to go green (compile already does); the windows leg is the unknown. `targets: "all"` in `tauri.conf.json` means Linux produces deb + rpm + AppImage and Windows produces msi + nsis — the ADR narrows which of those we ship; the probe builds them all because that's the cheapest way to learn which bundlers have problems.
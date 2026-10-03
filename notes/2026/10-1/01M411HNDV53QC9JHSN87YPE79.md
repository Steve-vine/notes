---
id: 01M411HNDV53QC9JHSN87YPE79
created: 2026-10-03T14:09:04.443815Z
updated: 2026-10-03T14:52:49.134011Z
type: task
title: 'Cross-platform CI probe: Linux and Windows bundle legs, plus ADR 0068'
project: 01KY6W9951TW0904DT0GGJVGE7
number: 498
sprint: sw66q9v
comments:
- id: 01M412DC0VZNHGH93YN9RSQGPP
  author: Steve Vine
  at: 2026-10-03T14:24:12.313591Z
  text: 'PR #489 open on brief-498-cross-platform-ci-probe. Pre-push gate passed locally (typecheck, clippy, rust-test 451). Contains ADR 0068 and the three-leg bundle matrix. The probe runs post-merge, so the first Linux/Windows result arrives on the merge of this PR; write the red-leg findings back here and re-plan NOT-499..503 from them.'
- id: 01M4141AJ62FXSZEYBEGN3S7RQ
  author: Steve Vine
  at: 2026-10-03T14:52:34.754162Z
  text: |-
    Probe result — post-merge CI run 37129814651 on 513cd53: all three legs green first time.

    - macOS: 3m44s (warm cache), dmg as before. 23 MB artifact.
    - Linux (ubuntu-latest): 15m cold. Built deb, rpm and AppImage without intervention (linuxdeploy downloaded at bundle time; patchelf + libfuse2 were enough). 242 MB artifact — includes the unpacked AppDir, not just the three bundles.
    - Windows (windows-latest): 21m cold. Built msi (WiX) and nsis setup.exe without intervention; WebView2 bootstrapper default. 19 MB artifact. The sidecar script staged notuvia-mcp-x86_64-pc-windows-msvc.exe fine.

    Only finding in the logs: two dead-code warnings on Windows in notuvia-core git.rs — `SSH_CONTROL_PATH_MAX` and `SSH_CONTROL_HASH_LEN` are only read by `#[cfg(unix)]` functions but aren't themselves cfg-gated. Harmless for the build, but `clippy -D warnings` would be red on Windows, so a Windows lint/test leg can't be added until they're gated. Folded into NOT-501.

    What this tells us for planning: compile and packaging are not the problem on either platform; nothing in the ADR 0068 risk list is a build-time issue. The sprint's work is all runtime behaviour (hotkey, watcher, git spawn, WebView rendering) — which needs the bundles run on real machines. The artifacts from this run are downloadable for exactly that.
assignee: steve
label:
- brief
- chore
priority: high
task_status: done
tech: null
---
So that we know what actually breaks on Windows and Linux before planning the port, rather than discovering it mid-sprint. The whole Rust workspace already compiles on Linux (clippy runs on ubuntu); Windows has never been compiled; neither has ever been bundled.

## Agreed work

- [x] ADR 0068 — cross-platform strategy: targets and packaging formats, signing stance, the capture-hotkey fallback for platforms where a global shortcut can't be registered, the watcher contract, how the WebView engine differences are handled, and the CI/release matrix shape. Extends ADR 0002 and ADR 0016; narrows ADR 0018 to "macOS only until now".
- [x] `ci.yml` `build` job becomes a three-leg matrix (`macos-latest`, `ubuntu-latest`, `windows-latest`), still post-merge only (push to main), still skipping updater artifacts. `fail-fast: false` so one platform failing doesn't hide the other's result.
- [x] Linux leg installs the Tauri system deps the lint/typecheck jobs already use (plus patchelf + libfuse2 for the bundlers); Windows leg needs nothing extra (WebView2 is on the runner).
- [x] Each leg uploads its bundle directory as `notuvia-<os>` so the artifacts can be downloaded and tried by hand.
- [x] Nothing in the app changes. Red legs are the point: the probe's output is the list of what fails, written back here as a comment, and the Cross-platform sprint's drafted briefs are re-planned from it.

## Notes

The probe runs post-merge, so the first result arrives on the merge of this PR. The ubuntu leg is expected to go green (compile already does); the windows leg is the unknown. `targets: "all"` in `tauri.conf.json` means Linux produces deb + rpm + AppImage and Windows produces msi + nsis — the ADR narrows which of those we ship; the probe builds them all because that's the cheapest way to learn which bundlers have problems.

Outcome: all three legs green on the first run — see the result comment. Merged as 513cd53 (PR #489).
---
id: 01M4R5BFB6XEQZ8EH9M8YW78TQ
created: 2026-10-12T13:38:07.846652Z
updated: 2026-10-12T14:33:50.137234Z
type: task
title: Dev app couldn't take keyboard focus on macOS 26 — fixed by a reboot, no code change
project: 01KY6W9951TW0904DT0GGJVGE7
number: 540
assignee: steve
label:
- chore
priority: low
task_status: cancelled
tech:
- rust
---
**Cancelled — not a code problem. A restart of the laptop fixed it.**

## Symptom

On macOS 26.7.1, `npm run tauri:dev` opened a window that never became the
active app: the caret blinked in the note, but every keystroke went to
whichever window had focus before. The app was absent from Cmd-Tab, and the
tray's "open" (`show()` + `unminimize()` + `set_focus()`) made no difference.

## Cause

Machine state, cleared by a reboot. After restarting, plain `npx tauri dev`
— the unbundled binary, no changes — takes keyboard focus normally. Most
likely a stuck LaunchServices / WindowServer session that was refusing to
activate newly launched apps.

## If it happens again

1. **Restart the laptop first.** That is the fix.
2. As a stopgap without restarting: stop `tauri dev`, run `npm run dev`, and
   launch the debug binary from inside a minimal `.app` (an `Info.plist` plus
   `Contents/MacOS/notuvia` symlinked to `src-tauri/target/debug/notuvia`)
   with `open`. That worked before the reboot when nothing else did.

## What was ruled out

- **Today's code.** Reverting the frontend to the commit before NOT-537/538/539
  changed nothing, none of those touched `src-tauri/`, and the same commit
  worked on another laptop.
- **A hung webview.** The app and its WebContent process sat at 0% CPU.
- **Embedding an Info.plist in the binary** (`__TEXT,__info_plist` via
  `build.rs`). The running binary carried the section and LaunchServices still
  reported `bundleID=[ NULL ]`. Does not give a process an app identity on
  macOS 26.

## What was wrong in the diagnosis

The working theory was "macOS 26 will not activate an unbundled binary", and a
custom `tauri dev` runner that wrapped the binary in a `.app` was written on
the strength of it. That theory never explained why the app had worked earlier
the same day, and the runner did not work either until the reboot. Both the
embedded-plist commit and the runner were discarded unpushed; `main` was never
touched.

`bundleID=[ NULL ]` and absence from Cmd-Tab are normal for a `tauri dev`
binary and are not evidence of a fault on their own.

## Separate finding, not yet filed

The dev build reads `~/Library/Application Support/uk.stevevine.notuvia/config.json`,
the same file as the installed app, so `npm run tauri:dev` opens the **real
vault**. `brief/ways-of-working.md` says dev builds run against a scratch
vault, which is not what the code does.

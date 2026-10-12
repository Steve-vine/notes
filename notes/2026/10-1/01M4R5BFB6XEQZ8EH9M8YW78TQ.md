---
id: 01M4R5BFB6XEQZ8EH9M8YW78TQ
created: 2026-10-12T13:38:07.846652Z
updated: 2026-10-12T13:38:07.846652Z
type: task
title: 'macOS 26: the dev app can''t take keyboard focus — embed an Info.plist in the debug binary'
priority: high
tech: rust
label:
- chore
- bug
assignee: steve
task_status: active
project: 01KY6W9951TW0904DT0GGJVGE7
number: 540
---
On macOS 26.7.1, `npm run tauri:dev` opens a window that **never becomes the
active app**: the caret blinks in the note, but every keystroke goes to
whichever window had focus before. The app is absent from Cmd-Tab, and the
tray's "open" (which calls `show()` + `unminimize()` + `set_focus()`) makes no
difference — `set_focus()` can't activate an app macOS won't activate.

## Cause

`tauri dev` runs the bare binary, `src-tauri/target/debug/notuvia`:

```
"notuvia" ASN:0x0-0x292292
    bundleID=[ NULL ]
    Info.plist=not bound        (codesign; adhoc, linker-signed)
```

No bundle, so no bundle identifier. macOS 26 won't let such a process become
the frontmost application, and the app switcher — which lists apps by bundle
id — never shows it.

**Proved, not guessed.** Reverting the frontend to the previous commit changed
nothing, and the same commit works on another laptop. Symlinking the *very
same* `target/debug/notuvia` into a minimal `.app` with nothing but an
`Info.plist`, then launching it against `npm run dev`, made typing work
immediately.

## Agreed work

- [ ] `src-tauri/dev-Info.plist`: the minimum macOS needs — `CFBundleName`
      ("Notuvia (dev)", so the switcher tells it apart from the installed
      app), `CFBundleIdentifier` `uk.stevevine.notuvia.dev`,
      `CFBundleExecutable`, `CFBundlePackageType`, `NSHighResolutionCapable`.
- [ ] `src-tauri/build.rs`: on a **macOS debug** build, emit
      `cargo:rustc-link-arg-bins=-Wl,-sectcreate,__TEXT,__info_plist,<path>`
      so the plist is embedded in the binary's `__TEXT,__info_plist` section —
      Apple's documented mechanism for a single-file tool that needs an
      Info.plist. Gated on `CARGO_CFG_TARGET_OS` + `PROFILE`, with a
      `rerun-if-changed`.
- [ ] **Debug only.** A release build gets a real `Info.plist` from the Tauri
      bundler; a second, conflicting one embedded in the Mach-O would be asking
      for trouble at bundle and codesign time.
- [ ] Only the `notuvia` binary. `notuvia-mcp` is a separate workspace member
      with its own build script, so it is untouched — and a headless stdio
      server must not acquire a GUI bundle identity.
- [ ] `docs/` or `CLAUDE.md`: a line on why the debug binary carries a plist,
      so it doesn't look like clutter later.

## Verification

- [ ] `npm run tauri:dev` on macOS 26: the window takes keyboard focus, and
      typing in a note goes to the note.
- [ ] It appears in Cmd-Tab as "Notuvia (dev)", distinct from the installed
      app.
- [ ] `npm run tauri:build` still bundles and launches — one Info.plist, the
      bundler's.
- [ ] `cargo check --workspace` and the CI Linux/Windows legs are unaffected
      (the flag is macOS-only).

## Notes

A bundle identity is what WebKit keys its data store on, so the dev app may
start with default view preferences (column widths, tab state) rather than
inheriting whatever the unbundled binary was using. That is a one-off, and
arguably the right thing — dev state separate from the installed app's.

Vault and config are **not** affected: Tauri derives `app_config_dir()` from
the identifier compiled in from `tauri.conf.json`
(`uk.stevevine.notuvia`), not from the Mach-O plist.

Separately noticed while diagnosing, worth its own task: the dev build shares
`~/Library/Application Support/uk.stevevine.notuvia/config.json` with the
installed app, so it opens the **real vault** — `CLAUDE.md` claims dev builds
run against a scratch vault, which isn't what the code does.

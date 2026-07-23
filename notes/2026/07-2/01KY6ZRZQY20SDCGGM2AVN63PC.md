---
id: 01KY6ZRZQY20SDCGGM2AVN63PC
created: 2026-07-23T07:59:22.878952Z
updated: 2026-07-23T11:04:51.242665Z
type: task
title: macOS packaging & distribution — unsigned aarch64 .dmg
assignee: steve
task_status: done
comments:
- id: 01KY6ZS8TEXS83KATCK7SNQ0WT
  author: Steve Vine
  at: 2026-07-23T07:59:32.173974Z
  text: |-
    Steve Vine · 2026-06-28:

    Done — PR #101: https://github.com/Steve-vine/notula/pull/101

    ## What was done
    - **`tauri.conf.json`:** explicit ad-hoc signing (`macOS.signingIdentity: "-"`), `minimumSystemVersion: "11.0"`, `copyright` + `category` metadata; `targets` stays `"all"`.
    - **`docs/packaging-macos.md`** (new, linked from README): build recipe, output location, the one-time receiving-Mac quarantine-clear step, and Finder-automation troubleshooting.
    - **ADR 0018:** records the unsigned/ad-hoc · aarch64-only · documented-local-build strategy; Developer ID notarization deferred.

    ## Verification
    - `npm run tauri:build` produces a correctly ad-hoc-signed arm64 `Notula.app`; Info.plist carries `LSMinimumSystemVersion 11.0` + copyright + productivity category from the new config.
    - End-to-end install path tested on a real disk image: mount → install → apply `com.apple.quarantine` → documented `xattr -dr` clear → `codesign --verify` still OK. `spctl` rejects the un-notarized app, confirming the clear step is required.
    - Pre-push gate all green (fmt, clippy, frontend typecheck/build, 134 tests).

    ## Decisions / notes made on the fly
    - **Local dmg bundling needs a GUI session.** `tauri build`'s dmg step styles the image window via a Finder AppleScript, which fails from a headless/agent shell ("Failed running `bundle_dmg.sh`"). It works from a normal Terminal session (macOS prompts to allow Terminal→Finder automation on first run) — documented in the troubleshooting section. Full `tauri build` → `.dmg` is confirmed green by the post-merge CI `build` job (uploads the `notula-macos` artifact), so packaging itself is sound.
    - Verified the install path with a plain `hdiutil`-built dmg (skips the cosmetic AppleScript) to prove mount/install/quarantine/clear independently of that GUI limitation.

    ## Candidate follow-ups (out of scope; file if wanted)
    - Apple Developer ID sign + notarize (frictionless distribution).
    - Tagged-release GitHub workflow attaching the `.dmg` to a Release.
    - Windows / Linux packaging.

    Moving to In Review — merge call is yours.
imported_from: linear
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 114
sprint: shsh0ka
---
Package Notula into a `.dmg` that can be installed and run on another Apple-Silicon Mac, via a documented local build. No paid Apple Developer account — the app is **unsigned / ad-hoc signed**, so the receiving Mac must clear Gatekeeper quarantine once.

## Decisions (agreed in planning)

* **Signing:** unsigned / ad-hoc (`signingIdentity: "-"`). No notarization. Fits "primarily personal use".
* **Architecture:** Apple Silicon only (`aarch64-apple-darwin`). Host is arm64; no extra Rust target needed.
* **Automation:** documented local build only — no release CI in this brief.

The app already produces `Notula_<ver>_aarch64.dmg` via `bundle.targets: "all"`; the real gap is Gatekeeper on a second Mac and the absence of a recorded build/install recipe.

## Scope (checklist)

- [ ] **ADR 0018 — macOS packaging & distribution strategy.** Record: unsigned/ad-hoc, aarch64-only, documented local build, Developer ID notarization explicitly deferred, and the receiving-Mac quarantine consequence.
- [ ] `src-tauri/tauri.conf.json` **bundle polish:** `bundle.macOS.signingIdentity: "-"`, `bundle.macOS.minimumSystemVersion: "11.0"`, plus `copyright`/`category` metadata. Keep `targets: "all"`.
- [ ] `docs/packaging-macos.md` (new), linked from README: build command (`npm run tauri:build`), output location, and the receiving-Mac quarantine-clear step (right-click → Open, or `xattr -dr com.apple.quarantine /Applications/Notula.app`).
- [ ] **Verify:** build the `.dmg`, install to `/Applications`, apply the quarantine attribute to simulate transfer, confirm Gatekeeper blocks it and the documented clear step then launches it.

## Out of scope (future follow-ups)

* Apple Developer ID sign + notarize (frictionless distribution).
* Tagged-release GitHub workflow attaching the `.dmg` to a GitHub Release.
* Windows / Linux packaging.

## Definition of Done

A documented `npm run tauri:build` produces an installable `aarch64` `.dmg`; following `docs/packaging-macos.md` a second Apple-Silicon Mac can install and launch Notula; ADR 0018 records the strategy.

---

Linear DEV-702 · M14 - Package for deployment (Mac) · created 2026-06-28 · done 2026-06-28
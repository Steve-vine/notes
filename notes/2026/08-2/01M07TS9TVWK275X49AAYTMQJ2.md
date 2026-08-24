---
id: 01M07TS9TVWK275X49AAYTMQJ2
created: 2026-08-17T12:22:48.411554Z
updated: 2026-08-24T22:03:56.792582Z
type: task
title: Table Issue
project: 01KY6W9951TW0904DT0GGJVGE7
number: 400
sprint: segj1dz
comments:
- id: 01M0TJCH1HDB37ADS35VQWHQGM
  author: Steve Vine
  at: 2026-08-24T19:01:35.406621Z
  text: |-
    Done — PR #390 (branch brief-400-401-substitutions-and-gantt-rail), landed alongside NOT-401.

    The em dash was never ours: macOS applies automatic dash substitution to the CodeMirror contenteditable, and WKWebView reads that state from the app's own user defaults. The DEV-980 spellcheck seed grew into seed_webkit_text_checking(), which now seeds WebAutomaticDashSubstitutionEnabled, WebAutomaticQuoteSubstitutionEnabled and WebAutomaticTextReplacementEnabled off before the first webview is created.

    Decision on the fly (agreed with Steve): quotes and text replacement go too, not just dashes — smart quotes corrupt markdown and code identically, and ADR 0017 makes the literal buffer the thing that reaches disk.

    Seed-if-unset semantics kept, so the editor's Substitutions context menu still wins if you ever want them back.

    Needs an eyeball in the running app: type "| --- |" in the editor and confirm the dashes survive.
assignee: steve
priority: medium
task_status: done
---
When creating tables in markdown, typing in three dashes followed by a space gets replaced with — (an M-Dash) making it Impossible to create tables.

## Cause

Nothing in the app rewrites dashes. It is macOS's **automatic dash
substitution**, applied by WKWebView to the CodeMirror contenteditable surface.
WebKit reads its substitution state from the app's user defaults
(`WebAutomatic*Enabled`), seeded from NSSpellChecker if the app sets nothing.

## Agreed work

Extend the existing `seed_webkit_spellcheck()` precedent in
`src-tauri/src/lib.rs` (DEV-980, which seeds `WebContinuousSpellCheckingEnabled`
on) to also seed **off**, before the first webview is created:

- `WebAutomaticDashSubstitutionEnabled`
- `WebAutomaticQuoteSubstitutionEnabled`
- `WebAutomaticTextReplacementEnabled`

Smart quotes corrupt markdown and code the same way dashes do, so all three go
(agreed with Steve). Seed-if-unset semantics are kept, so a value the user has
since set from the editor's Substitutions context menu is never overridden.
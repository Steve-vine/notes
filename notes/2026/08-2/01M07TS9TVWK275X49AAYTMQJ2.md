---
id: 01M07TS9TVWK275X49AAYTMQJ2
created: 2026-08-17T12:22:48.411554Z
updated: 2026-08-24T18:28:44.134334Z
type: task
title: Table Issue
project: 01KY6W9951TW0904DT0GGJVGE7
number: 400
sprint: segj1dz
assignee: steve
priority: medium
task_status: active
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
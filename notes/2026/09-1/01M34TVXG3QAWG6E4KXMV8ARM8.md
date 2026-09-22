---
id: 01M34TVXG3QAWG6E4KXMV8ARM8
created: 2026-09-22T15:13:36.259834Z
updated: 2026-09-22T15:48:50.303076Z
type: task
title: Add a print capability
project: 01KY6W9951TW0904DT0GGJVGE7
number: 428
sprint: segj1dz
comments:
- id: 01M34WWDZY5234SQCB158R7Q9Q
  author: Steve Vine
  at: 2026-09-22T15:48:50.302592Z
  text: |-
    Built on `brief-428-print-capability` — PR #430. ADR 0062 records the design.

    What shipped: a printer button on the note pane's status bar plus Cmd/Ctrl+P
    on the active pane, printing the rendered note (title, display id · updated,
    body) from any view, hidden while a note is locked.

    Decisions made on the way:

    - **Staged into the live document, not an iframe.** A print run paginates
      whatever the WebView is showing, and on macOS it starts in Rust against the
      whole WKWebView — so there is no second document to hand the printer. The
      note goes into a hidden `#print-root` on `<body>` and one `@media print`
      block hides the app and shows the stage.
    - **The trigger splits by platform in Rust.** `window.print()` is silently
      inert in WKWebView (wry implements no `WKUIDelegate` print hook), and
      Tauri's `Webview::print()` is implemented only on macOS and is an empty
      `Ok` elsewhere — so neither alone covers the three targets, and neither
      reports doing nothing. `print_webview` returns whether it raised the dialog;
      `false` means fall back to `window.print()`.
    - **The stage is left populated after printing.** macOS runs the print sheet
      asynchronously with no completion callback, and pagination happens when the
      user confirms — clearing on return would print a blank page. It is hidden,
      replaced by the next print, and cleared on `afterprint` where that fires.

    Problems found and fixed while measuring the output through headless Chrome's
    print pipeline (built CSS, staged note, real page breaks):

    - The document is locked to the viewport and scrolls internally (NOT-382),
      which clipped the printout to one page.
    - `color-scheme: dark` made the UA paint a dark canvas behind the page box —
      the sheet came out framed in solid ink. The fix needed the
      `:root[data-theme="dark"]` selector repeated, because a media query buys no
      specificity.
    - A full-width table's right border landed on the clip edge and vanished;
      sizing tables to content with a 100% cap fixes it and reads better on paper.

    Left for a human pass: the macOS print dialog itself. Staging and the
    stylesheet are verified in Blink; the WKWebView trigger is a call into wry's
    API that can't be raised headlessly. Worth clicking Print once on a real note,
    including one with an attachment image.
assignee: steve
label:
- feature
priority: medium
task_status: review
tech: null
---
Add the ability to print a memo.

## Agreed scope

A **Print** button on the note pane's status bar (and **Cmd/Ctrl+P** on the
active pane) puts the *rendered* note on paper — title, a provenance line
(display id · last updated), then the body. Works from any view, including
while editing: what a memo is, not how it is written. Hidden while a note is
locked.

- [x] `print_webview` command — wry's `printOperationWithPrintInfo` on macOS,
      where `window.print()` is silently inert; reports back that it did
      nothing on Windows/Linux, where `window.print()` is the working path.
- [x] `print.ts` — stage the note into a hidden `#print-root` on `<body>`,
      wait for attachment images, raise the dialog.
- [x] `print.css` — one `@media print` block that hides the app and shows the
      stage, with a light, low-ink paper layout.
- [x] Printer icon, status-bar button, Cmd/Ctrl+P.
- [x] Unit tests for the staged markup and the provenance line.
- [x] ADR 0062.

## Not in scope

Printing a board, a project, or a set of search results. The staging
mechanism generalises; the stylesheet does not — each would need its own
paper layout.

---
id: 01M3MYKAK6N83TTF44EY8CA8KM
created: 2026-09-28T21:26:39.974388Z
updated: 2026-09-28T22:06:15.839813Z
type: task
title: 'Website: Download page'
project: 01KY6W9951TW0904DT0GGJVGE7
number: 488
sprint: spqrtwg
blocked_by:
- 01M3MY1APNGC5GRXYGCCWJJ9T3
comments:
- id: 01M3N0VTRZXP9BGMMSS1WRY2QF
  author: Steve Vine
  at: 2026-09-28T22:06:15.839566Z
  text: |-
    Built and pushed to staging (05aa599, f3ab709).
    - /download/ from the design. At build time the version and release date come from updates.notuvia.net/latest.json (src/lib/release.ts). The .dmg button links to that version's Apple Silicon disk image on the channel; today's 0.30.0 link is checked and returns 200. A failed or unusable manifest fails the build, so the live site keeps its last good version.
    - macOS is live: Apple Silicon, macOS 11 or later, the app's configured minimum. Windows and Linux are disabled and marked Coming soon, with the design's planned requirements. A tiny script tags the macOS card "Your system" for Mac visitors; without it, the page is the same minus the tag.
    - First launch on macOS: it warns about the "damaged and can't be opened" message and gives the one-time `xattr -dr com.apple.quarantine /Applications/Notuvia.app` fix, with Control-click → Open as a fallback. This follows the app's packaging notes, not the design's right-click line. The Connect Claude and vault notes link to /docs/mcp/ and /docs/getting-started/.
    To look at: /download/, the .dmg link, the command block at phone width, and whether the Windows and Linux requirement lines are real targets.
assignee: steve
label:
- brief
priority: medium
task_status: active
tech: null
---
The design's "Download Notuvia" page (website ADR 0003).

## Scope

- [ ] At build time, read the version and date from `https://updates.notuvia.net/latest.json`. The dmg link is `https://updates.notuvia.net/v<version>/Notuvia_<version>_aarch64.dmg`. The version is never typed into a page. A failed fetch fails the build, so the live site keeps the last good version.
- [ ] Platform cards: macOS (Apple Silicon, macOS 11 or later: check this against the app's minimum), and Windows and Linux shown as "Coming soon".
- [ ] "Your system" highlight: the design detects the OS in the browser. Keep it as a small script that only adds a highlight; with no script, the page still works.
- [ ] The three notes from the design: First launch on macOS (right-click → Open for Gatekeeper), Connect Claude, and Your vault is just a folder. Each links to the matching docs page.
- [ ] Every "Download" button on the site (header, home, pricing) points here.

**Done when:** the button downloads the current release's dmg, and the version shown matches `latest.json`.
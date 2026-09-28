---
id: 01M3MYKAK6N83TTF44EY8CA8KM
created: 2026-09-28T21:26:39.974388Z
updated: 2026-09-28T21:27:07.219672Z
type: task
title: 'Website: Download page'
project: 01KY6W9951TW0904DT0GGJVGE7
number: 488
sprint: spqrtwg
blocked_by:
- 01M3MY1APNGC5GRXYGCCWJJ9T3
assignee: steve
label:
- brief
priority: medium
task_status: backlog
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
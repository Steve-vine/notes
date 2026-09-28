---
id: 01M3MY1FMHCVMQQQ40MN451R0Y
created: 2026-09-28T21:16:55.313085Z
updated: 2026-09-28T21:16:55.313085Z
type: task
title: 'Website: home page and macOS download'
task_status: backlog
label: brief
priority: medium
assignee: steve
project: 01KY6W9951TW0904DT0GGJVGE7
number: 481
tech: null
---
The front door: what Notuvia is, and how to get it (website ADRs 0002 and 0003).

## Scope

- [ ] Home page on Starlight's `splash` template. Say what Notuvia is from the app's README and mission brief: atomic capture, fuzzy retrieval, plain markdown files you own, and optional sync. No claims the app can't back up. Include a screenshot or two.
- [ ] Download page, an Astro page using `StarlightPage`. At build time, read the version from `https://updates.notuvia.net/latest.json` and link to `v<version>/Notuvia_<version>_aarch64.dmg` on the channel. Show the version and date.
- [ ] Be honest about platform: Apple Silicon macOS only for now, with Windows and Linux later.
- [ ] First-launch note: the app is unsigned, so explain clearing Gatekeeper quarantine once (from the app's `docs/packaging-macos.md`, rewritten for users). Mention that updates install in place after that.
- [ ] A failed fetch fails the build, so the last good deploy stays live.

**Done when:** the preview shows the home page, and the download button fetches the current release's dmg.
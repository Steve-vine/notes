---
id: 01M3MYKS1CC0HGGMR0YHB200EZ
created: 2026-09-28T21:26:54.764838Z
updated: 2026-09-28T21:27:10.670044Z
type: task
title: 'Website: License and Security pages'
project: 01KY6W9951TW0904DT0GGJVGE7
number: 491
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
Two of the design's three Legal pages (Privacy is NOT-471). They share the legal layout: title, intro, "Last updated", and icon-headed sections, with a License / Privacy / Security tab strip.

## License: decision needed first (Steve)

The design says Notuvia is MIT-licensed and invites people to "read, modify and build on the source". The app's `package.json` does say MIT, but **the repo is private**, so no one can read the source. Before this page goes live, choose one:

- Make the app repo public under MIT, and link to it from this page.
- Keep the repo private, and replace the page with an end-user licence for the free download: what a user may do with the app, with no source rights.

The notice "Copyright (c) 2026 Steve Vine" appears on a public page either way.

## Scope

- [ ] License page, per the decision above.
- [ ] Security page from the design: encrypted notes (Argon2id, XChaCha20-Poly1305), the local HTTP API (off by default, 127.0.0.1, API keys stored as SHA-256), signed updates, the unsigned macOS app, and your own safeguards. Check each technical claim against the app code (the encryption and API ADRs) before publishing.
- [ ] Share the legal layout with the Privacy page.

**Done when:** both pages are live on staging, every claim is checked, and the licence decision is recorded.
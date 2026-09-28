---
id: 01M3MYKS1CC0HGGMR0YHB200EZ
created: 2026-09-28T21:26:54.764838Z
updated: 2026-09-28T22:06:38.339115Z
type: task
title: 'Website: License and Security pages'
project: 01KY6W9951TW0904DT0GGJVGE7
number: 491
sprint: spqrtwg
blocked_by:
- 01M3MY1APNGC5GRXYGCCWJJ9T3
comments:
- id: 01M3MZ5QZHKG7GX910R0N7RVDT
  author: Steve Vine
  at: 2026-09-28T21:36:43.505013Z
  text: 'Decision (Steve, 2026-09-28): an end-user licence, not MIT. The app repo stays private. The License page is an end-user licence for the free download: what a user may do, no source rights, and no warranty. Their notes are their own. Note for the app repo: its package.json still says "license": "MIT", which contradicts this. Change it in an app session; this repo can''t edit the app.'
- id: 01M3N0WGR3EN7GT244KBAGTD2K
  author: Steve Vine
  at: 2026-09-28T22:06:38.338945Z
  text: |-
    Built and pushed to staging (9e6c0af).
    - /license/ and /security/ share a legal layout (src/components/LegalPage.astro, data in src/data/legal/): the License / Privacy / Security pill strip, title, intro, "Last updated", then sections separated by fading rules.
    - License: Steve's decision, an end-user licence for the free download, not MIT. "In short" comes first, then 12 numbered terms:
      - use on any computer you own or control, personal or commercial, free;
      - pass on an unchanged official download at no charge;
      - no selling, modifying or reverse engineering, except where the law allows;
      - licensed, not sold, with no source rights (© 2026 Steve Vine);
      - your notes are yours;
      - updates;
      - open-source components keep their own licences;
      - no warranty;
      - liability limits that keep what UK law won't let us exclude;
      - ending the licence;
      - changes;
      - England and Wales law.
      **This is a draft for Steve's review, not legal advice.**
    - Security: the design's five sections, each claim checked against the app code. Corrected or added:
      - attachments are not encrypted;
      - with Git sync, history keeps versions saved before encryption;
      - a fresh nonce on every save;
      - the API's opt-in LAN mode, and keys kept outside the vault;
      - the first-launch step points to the download page's `xattr` command instead of "right-click → Open".
    - Open for Steve:
      - governing law (England and Wales, with a Scotland/NI carve-out);
      - the redistribution position (unchanged copies may be passed on free);
      - licensor: Steve personally, or a company;
      - a security contact address (the "Reporting a security problem" section is left out until one exists);
      - the app's package.json still says "license": "MIT" (app-side fix).
    To look at: /license/ and /security/ at desktop and phone widths, in both themes.
assignee: steve
label:
- brief
priority: medium
task_status: active
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
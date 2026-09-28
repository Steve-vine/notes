---
id: 01M3MY20QBFVH9Q9QXFH9ZK5QN
created: 2026-09-28T21:17:12.811114Z
updated: 2026-09-28T21:17:29.657114Z
type: task
title: Website go-live on notuvia.net
project: 01KY6W9951TW0904DT0GGJVGE7
number: 485
blocked_by:
- 01M3MY16A65JX6013JXE2Q3MZR
- 01M3MY1FMHCVMQQQ40MN451R0Y
- 01M3MY1N5B636W6ARMKM3H3W9B
- 01M3MPDHA8M4XXGSHWN8H16VJ5
- 01M3KZJD18YG8X520PPVP6X00K
assignee: steve
label: chore
priority: medium
task_status: backlog
tech: null
---
Put the site on its real domain once there is something worth showing. It stays on workers.dev and preview URLs until then.

## Scope

- [ ] Add `notuvia.net` and `www.notuvia.net` as `custom_domain` routes in `wrangler.jsonc`. The zone is already in the account because it serves `updates.` and `checkin.`. Check no existing DNS record clashes first.
- [ ] Redirect `www` to the apex, or the other way round; decide which.
- [ ] Analytics: decide whether to add Cloudflare Web Analytics (cookieless). If yes, the privacy policy has to say so before it goes live.
- [ ] Final check across desktop and phone widths, light and dark, and the 404 page.
- [ ] Submit the sitemap to search engines.

**Done when:** `https://notuvia.net` serves the site, with the home, download, docs, changelog and privacy pages all live.
---
id: 01M3MY20QBFVH9Q9QXFH9ZK5QN
created: 2026-09-28T21:17:12.811114Z
updated: 2026-09-28T21:26:20.297612Z
type: task
title: 'Website: first production deploy to notuvia.com'
project: 01KY6W9951TW0904DT0GGJVGE7
number: 485
sprint: spqrtwg
blocked_by:
- 01M3MY16A65JX6013JXE2Q3MZR
- 01M3MY1FMHCVMQQQ40MN451R0Y
- 01M3MY1N5B636W6ARMKM3H3W9B
- 01M3MPDHA8M4XXGSHWN8H16VJ5
- 01M3KZJD18YG8X520PPVP6X00K
assignee: steve
label:
- chore
priority: medium
task_status: backlog
tech: null
---
`main` is live, so going live means the first fast-forward of `main` to `staging`. Do it only when Steve says so.

## Scope

- [ ] Pre-flight on `staging`: the build is clean, there are no placeholder screenshots, and every page has been checked by Steve (desktop and phone, all three theme modes, the 404 page).
- [ ] `git switch main && git merge --ff-only staging && git push origin main`, then watch the CI run through to the deploy step.
- [ ] Check `https://notuvia.com` serves the site with a valid certificate. Decide `www.notuvia.com`: redirect to the apex, or leave it unset.
- [ ] Make `main` the default branch on GitHub.
- [ ] Analytics: decide whether to add Cloudflare Web Analytics (cookieless). If yes, the privacy policy says so before this deploy.
- [ ] Submit the sitemap to search engines.

**Done when:** notuvia.com serves the site and every page in the footer is live.
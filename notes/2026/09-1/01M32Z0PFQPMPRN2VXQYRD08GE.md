---
id: 01M32Z0PFQPMPRN2VXQYRD08GE
created: 2026-09-21T21:47:38.359121Z
updated: 2026-09-21T21:47:38.359121Z
type: task
title: Redirect www.compassitp.com to compassitp.com
label: chore
priority: medium
task_status: backlog
assignee: steve
project: 01M32Q7WT6058ZQFMMRM8KP1K6
number: 7
---
Someone typing www.compassitp.com should land on the site, at the bare address, rather than getting an error.

Done when: http and https, with and without www, all end up at https://compassitp.com/ and keep the rest of the address (so www.compassitp.com/docs/install/ goes to the install guide).

Technical: a Cloudflare redirect rule on the zone plus a proxied DNS record for www - set up in the Cloudflare dashboard or API rather than in this repo, unless we choose to manage it in wrangler.jsonc. Needs the zone in the account first. Record whichever way is chosen in CLAUDE.md.
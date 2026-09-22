---
id: 01M32Z1VCBX0VBVEEAW5ERYT01
created: 2026-09-21T21:48:16.139459Z
updated: 2026-09-22T20:51:25.876671Z
type: task
title: Design a proper "page not found" page
project: 01M32Q7WT6058ZQFMMRM8KP1K6
number: 12
assignee: steve
label: improvement
priority: low
task_status: todo
---
A wrong address anywhere on the site currently shows the docs theme's default "404" page, with the docs sidebar - even for an address that has nothing to do with the docs.

Replace it with a page in the site's own style: the normal header and footer, a plain "we can't find that page", and links to the home page, the documentation and the install guide.

Done when: a made-up address on the live site shows the new page and returns a real "not found" status.

Technical: add src/pages/404.astro using Base.astro and set `disable404Route: true` in the Starlight options. Cloudflare already serves /404.html for unknown paths (not_found_handling in wrangler.jsonc). Check with `npm run preview`, which serves the built site the way Cloudflare will.
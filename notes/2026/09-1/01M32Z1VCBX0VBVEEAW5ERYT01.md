---
id: 01M32Z1VCBX0VBVEEAW5ERYT01
created: 2026-09-21T21:48:16.139459Z
updated: 2026-09-22T21:15:15.333209Z
type: task
title: Design a proper "page not found" page
project: 01M32Q7WT6058ZQFMMRM8KP1K6
number: 12
comments:
- id: 01M35ECXZ9CH29PEVXF375R4Z1
  author: Steve Vine
  at: 2026-09-22T20:54:56.744882Z
  text: |-
    Pushed to staging. git pull only.

    What changed: any address that does not exist now shows a page in the site's own style - the normal header and footer, "There is no page at this address", and three buttons: Home page, Documentation, Install Compass. Starlight's default 404 (docs sidebar and all) is switched off, so a wrong address under /docs/ gets the same page.

    To check: npm run preview, then open http://localhost:8787/anything and http://localhost:8787/docs/anything. Both were checked here through wrangler and return a real 404 status with the new page. The plain dev server (npm run dev) also shows it, though its status code is Astro's rather than Cloudflare's.

    Technical: src/pages/404.astro on Base.astro; disable404Route: true in the Starlight options; not_found_handling: "404-page" in wrangler.jsonc was already there.
assignee: steve
label:
- improvement
priority: low
task_status: done
---
A wrong address anywhere on the site currently shows the docs theme's default "404" page, with the docs sidebar - even for an address that has nothing to do with the docs.

Replace it with a page in the site's own style: the normal header and footer, a plain "we can't find that page", and links to the home page, the documentation and the install guide.

Done when: a made-up address on the live site shows the new page and returns a real "not found" status.

Technical: add src/pages/404.astro using Base.astro and set `disable404Route: true` in the Starlight options. Cloudflare already serves /404.html for unknown paths (not_found_handling in wrangler.jsonc). Check with `npm run preview`, which serves the built site the way Cloudflare will.
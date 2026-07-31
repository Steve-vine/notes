---
id: 01KYW2Q2N03YTZX0VEAMZAKN9N
created: 2026-07-31T12:34:49.120737Z
updated: 2026-07-31T12:36:18.425858Z
type: task
title: Scaffold the Astro + Starlight site
project: 01KX671DATY39VW6GWK3M2T3DN
number: 403
sprint: sp3en5k
assignee: steve
label:
- chore
priority: high
task_status: todo
---
Initialise the ise-website repo as an Astro project with the Starlight docs theme: Node 22, npm, TypeScript, ESLint + Prettier matching the ISE app frontend conventions. Docs content lives in `src/content/docs/` as plain `.md` (MDX only when a page genuinely needs a component). Add wrangler config for Cloudflare Workers static assets — no secrets in the repo or wrangler config.

**Acceptance:** `npm run dev` serves the default Starlight site; `npm run build` produces a deployable `dist/`; lint + format pass; `npx wrangler deploy --dry-run` validates.
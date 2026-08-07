---
id: 01KYW2Q2N03YTZX0VEAMZAKN9N
created: 2026-07-31T12:34:49.120737Z
updated: 2026-08-07T09:40:26.936548Z
type: task
title: Scaffold the Astro + Starlight site
project: 01KX671DATY39VW6GWK3M2T3DN
number: 403
sprint: sp3en5k
comments:
- id: 01KYW3SZ3ND5HCFFZMN4CV1BPA
  author: Steve Vine
  at: 2026-07-31T12:53:52.373373Z
  text: |-
    Done on feature/ise-403-scaffold-astro-starlight (PR #1 → main).

    - Astro 7 + Starlight scaffold; docs in src/content/docs/ (template stub pages, real structure comes with ISE-406).
    - ESLint (flat, typescript-eslint + eslint-plugin-astro) + Prettier (semi:false, singleQuote, printWidth 100) matching the app frontend conventions; astro check wired in.
    - wrangler.jsonc for Workers static assets (dist/, 404-page handling), no credentials in repo; Node 22 via engines.

    Acceptance verified: build (4 pages + pagefind index), lint/format/check green, wrangler deploy --dry-run validates. Also made the repo's initial commit on main (CLAUDE.md, .gitignore, .claude/settings.json) since the repo was empty.
assignee: steve
label: null
priority: high
task_status: done
---
Initialise the ise-website repo as an Astro project with the Starlight docs theme: Node 22, npm, TypeScript, ESLint + Prettier matching the ISE app frontend conventions. Docs content lives in `src/content/docs/` as plain `.md` (MDX only when a page genuinely needs a component). Add wrangler config for Cloudflare Workers static assets — no secrets in the repo or wrangler config.

**Acceptance:** `npm run dev` serves the default Starlight site; `npm run build` produces a deployable `dist/`; lint + format pass; `npx wrangler deploy --dry-run` validates.
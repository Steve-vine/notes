---
id: 01M3MY0Y6T6DRHJ60MPGHKJZ5T
created: 2026-09-28T21:16:37.466221Z
updated: 2026-09-28T21:46:28.977269Z
type: task
title: 'Website: scaffold the Astro + Starlight site'
project: 01KY6W9951TW0904DT0GGJVGE7
number: 478
sprint: spqrtwg
comments:
- id: 01M3MZQJT1TGC7KJ2QBBCGKD4T
  author: Steve Vine
  at: 2026-09-28T21:46:28.032831Z
  text: |-
    Done, pushed to staging (commits 84e64af and e1414d9).

    - Branches: `staging` (the working branch, and GitHub's default for now) and `main`, both on origin. `main` sits at the setup commit (CLAUDE.md, .claude/settings.json, ADRs 0001–0003). It moves only by fast-forward, on Steve's say-so.
    - Astro 7.3 + Starlight 0.42, Node 22 (.nvmrc), TypeScript strict (held at 6.x for @astrojs/check). Product pages in src/pages/, docs in src/content/docs/docs/ under /docs/.
    - wrangler.jsonc: static assets from ./dist, 404-page handling, custom domain notuvia.com, workers_dev and preview_urls off, no credentials.
    - Checked: `npm run build` passes (check + build, Pagefind index, sitemap), `npx wrangler deploy --dry-run` validates, and the dev server serves / and /docs/.
    - Deviation: no ESLint or Prettier. compass-website runs without them, and `astro check` (run by `npm run build`) is the gate there too. Add them later if they earn their place.

    To look at: `git pull`, `npm install`, `npm run dev`. The home page is a placeholder until NOT-480 and NOT-481.
assignee: steve
label:
- chore
priority: high
task_status: review
tech: null
---
First task in `notuvia-website` (`~/code/notuvia-website`, `Steve-vine/notuvia-website`). Stack per website ADR 0002. Copy **`~/code/compass-website`**'s shape: same stack, same staging/main workflow, same Claude Design → Astro mapping.

## Scope

- [ ] Create the two permanent branches. Make the first commit on `staging` (`CLAUDE.md`, `.gitignore`, `.claude/settings.json`, `decisions/0001`–`0003`), then create `main` from it. Make `staging` the working branch. `main` becomes GitHub's default branch once it's live.
- [ ] Astro 7 + Starlight, with Node 22 (`.nvmrc`), npm and TypeScript strict. No adapter; static output.
- [ ] Two halves, as in compass-website: the product site as Astro pages in `src/pages/`, and the docs in `src/content/docs/docs/`, served under `/docs/`.
- [ ] ESLint + Prettier + `astro check`. `npm run build` runs check then build; `npm run preview` serves `./dist` through wrangler.
- [ ] `wrangler.jsonc`: static assets from `./dist`, `404-page` handling, custom domain `notuvia.com`, `workers_dev: false`, `preview_urls: false`. No credentials.
- [ ] Update `CLAUDE.md` with the layout and commands.

**Done when:** `npm run dev` serves a placeholder home page and the default docs; `npm run build` passes; `npx wrangler deploy --dry-run` validates; the work is pushed to `staging`.
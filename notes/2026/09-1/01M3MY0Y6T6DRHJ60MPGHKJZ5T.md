---
id: 01M3MY0Y6T6DRHJ60MPGHKJZ5T
created: 2026-09-28T21:16:37.466221Z
updated: 2026-09-28T21:16:37.466221Z
type: task
title: 'Website: scaffold the Astro + Starlight site'
assignee: steve
label: chore
priority: high
task_status: backlog
project: 01KY6W9951TW0904DT0GGJVGE7
number: 478
tech: null
---
First task in the `notuvia-website` repo (`~/code/notuvia-website`, `Steve-vine/notuvia-website`). Stack per website ADR 0002. Copy `~/code/ise-website`'s shape rather than inventing new patterns.

## Scope

- [ ] Initial commit on `main`: `CLAUDE.md`, `.gitignore`, `.claude/settings.json`, `decisions/0001`–`0003`. The repo has no commits yet, so the brief branch needs a base.
- [ ] Astro 7 + Starlight scaffold: Node 22 (`engines`), npm, TypeScript. Content in `src/content/docs/` as plain `.md`.
- [ ] ESLint (flat, `typescript-eslint` + `eslint-plugin-astro`) + Prettier + `astro check`, with the same settings as ise-website.
- [ ] `wrangler.jsonc` for Workers static assets (`dist/`, `404-page` handling, `preview_urls`), with no credentials or account id. Custom domains are added in the go-live task.
- [ ] PR workflow: lint, format check, `astro check` and build on every PR.
- [ ] Update `CLAUDE.md` with the repo layout and the commands.

**Done when:** `npm run dev` serves the default Starlight site; `npm run build` produces `dist/`; lint, format and check pass; `npx wrangler deploy --dry-run` validates; CI is green on the PR.
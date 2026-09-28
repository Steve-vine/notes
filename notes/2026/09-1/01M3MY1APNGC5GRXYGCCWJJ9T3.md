---
id: 01M3MY1APNGC5GRXYGCCWJJ9T3
created: 2026-09-28T21:16:50.261527Z
updated: 2026-09-28T21:16:50.261527Z
type: task
title: 'Website: Nocturne theme, logos and favicon'
assignee: steve
priority: medium
task_status: backlog
label: brief
project: 01KY6W9951TW0904DT0GGJVGE7
number: 480
tech: null
---
Make the site look like the same product as the app (website ADR 0002, app ADR 0063).

## Scope

- [ ] Map the Nocturne tokens in the app's `src/lib/theme.css` onto Starlight's CSS custom properties via `customCss`: the blue-grey ground, the single blurple accent used as a line, mark and tint, 8px radii, and rules that fade at their ends.
- [ ] Inter (`@fontsource-variable/inter`), with headings at medium weight and hierarchy by size and space, not boldness.
- [ ] Logos from the app's `assets/` (`full-logo-*`, `n-logo-*`) in the header, with the right variant per theme. Add a favicon.
- [ ] Social card image (`og:image`, `summary_large_image`).
- [ ] Both themes; follow the visitor's system preference by default.

**Done when:** Steve has checked the site at desktop and phone widths in light and dark, and it reads as Notuvia.
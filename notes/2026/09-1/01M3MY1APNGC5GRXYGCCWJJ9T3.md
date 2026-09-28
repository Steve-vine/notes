---
id: 01M3MY1APNGC5GRXYGCCWJJ9T3
created: 2026-09-28T21:16:50.261527Z
updated: 2026-09-28T21:47:51.28515Z
type: task
title: 'Website: site shell from the design — tokens, header, footer, theme switch'
project: 01KY6W9951TW0904DT0GGJVGE7
number: 480
sprint: spqrtwg
blocked_by:
- 01M3MY0Y6T6DRHJ60MPGHKJZ5T
assignee: steve
label:
- brief
priority: medium
task_status: active
tech: null
---
The frame every page sits in, built from the Claude Design project **"Notuvia website design"** (`claude.ai/design/p/698c9615-eb9c-4007-80a8-0bbe015ef871`, file `Notuvia Website.dc.html`, design system `_ds/nocturne-…/styles.css`). Follow compass-website's mapping.

## Scope

- [ ] `src/styles/tokens.css`: the design's Nocturne tokens and the page's light/dark overrides, verbatim. Use the variables and never hard-code a value they already carry.
- [ ] `src/layouts/Base.astro`: head, metadata, sticky blurred header, and footer.
- [ ] Header: logo, then About, Features, Pricing and Download, then a theme menu with System, Dark and Light options (System by default).
- [ ] Footer: tagline; Development (Roadmap, Change Log); Learn (FAQ, Documentation, Getting Started); Legal (License, Privacy, Security); © line. The navigation lives in one place (`siteLinks.ts`).
- [ ] Phosphor icons self-hosted (`@phosphor-icons/web`), not from unpkg. Inter self-hosted.
- [ ] Logos from the design's `assets/` (the same as the app's `assets/`). Add a favicon and a social card.
- [ ] Docs themed to match: Starlight variables mapped onto the tokens, and the header, footer and mobile menu overridden the way compass-website does it. Store the theme under Starlight's `starlight-theme` key so the choice carries between the site and `/docs`.
- [ ] 404 page.
- [ ] The design is one page that swaps content with JavaScript; the site uses real routes (`/`, `/features`, `/pricing`, `/download`, `/roadmap`, `/faq`, `/license`, `/privacy`, `/security`, `/changelog`, `/docs/…`).

**Done when:** Steve has checked the shell at desktop and phone widths in all three theme modes, and it matches the design.
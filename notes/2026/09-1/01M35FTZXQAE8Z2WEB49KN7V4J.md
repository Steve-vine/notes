---
id: 01M35FTZXQAE8Z2WEB49KN7V4J
created: 2026-09-22T21:20:06.07131Z
updated: 2026-09-22T21:21:11.488509Z
type: task
title: Screenshots follow the site's light/dark theme
project: 01M32Q7WT6058ZQFMMRM8KP1K6
number: 13
comments:
- id: 01M35FWZT07CT5KZ9TPGMJVQJ2
  author: Steve Vine
  at: 2026-09-22T21:21:11.488199Z
  text: |-
    Pushed to staging. git pull only.

    The mechanism is in; the dark screenshots are yours to add. For each screenshot that should change with the theme, put the dark capture next to the light one with -dark in the name:

      src/assets/screenshots/screenshot-dashboard-dark.png
      src/assets/screenshots/screenshot-soc2-framework-dark.png
      src/assets/screenshots/screenshot-timeline-dark.png
      src/assets/screenshots/screenshot-vendor-management-dark.png
      src/assets/screenshots/screenshot-access-control-dark.png
      src/assets/screenshots/screenshot-inventory-dark.png

    Same screen, same window size as the light one ideally, so the crop matches. Any you leave out keep showing the light capture in both themes. Commit and push to staging; no config change needed - the build picks them up by name.

    To check: pull, npm run dev, flip the theme with the header button. Each frame with a dark file should swap instantly; the hidden image is only downloaded when first shown. Verified here with a temporary copy of the dashboard shot as its own dark twin (not committed).

    Technical: src/components/Shot.astro renders both images with loading="lazy"; the theme rules are in src/styles/global.css (.shot--themed). Without JavaScript the OS preference decides.
assignee: steve
label:
- improvement
priority: medium
task_status: review
---
The home page shows one screenshot per frame whatever the theme. Show the light screenshot in light mode and the dark one in dark mode, following the site's own toggle (not the OS setting).

Done when: switching the theme on the home page swaps every screenshot that has a dark version, without a page reload and without downloading the hidden image; a screenshot with no dark version keeps showing in both.

Technical: Shot.astro looks for src/assets/screenshots/<name>.png and <name>-dark.png; renders both with lazy loading; CSS on :root[data-theme] picks one. Steve supplies the -dark files.
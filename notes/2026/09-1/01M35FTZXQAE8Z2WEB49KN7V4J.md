---
id: 01M35FTZXQAE8Z2WEB49KN7V4J
created: 2026-09-22T21:20:06.07131Z
updated: 2026-09-22T21:20:06.07131Z
type: task
title: Screenshots follow the site's light/dark theme
task_status: active
priority: medium
label: improvement
assignee: steve
project: 01M32Q7WT6058ZQFMMRM8KP1K6
number: 13
---
The home page shows one screenshot per frame whatever the theme. Show the light screenshot in light mode and the dark one in dark mode, following the site's own toggle (not the OS setting).

Done when: switching the theme on the home page swaps every screenshot that has a dark version, without a page reload and without downloading the hidden image; a screenshot with no dark version keeps showing in both.

Technical: Shot.astro looks for src/assets/screenshots/<name>.png and <name>-dark.png; renders both with lazy loading; CSS on :root[data-theme] picks one. Steve supplies the -dark files.
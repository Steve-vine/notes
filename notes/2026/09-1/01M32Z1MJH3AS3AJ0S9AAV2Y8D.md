---
id: 01M32Z1MJH3AS3AJ0S9AAV2Y8D
created: 2026-09-21T21:48:09.169054Z
updated: 2026-09-21T21:48:09.169054Z
type: task
title: Decide repo visibility and licence, then restore the footer's Project links
label: follow_up
priority: medium
task_status: backlog
assignee: steve
project: 01M32Q7WT6058ZQFMMRM8KP1K6
number: 11
---
The design's footer had a "Project" column with Releases and Licence. It was left out of the build because today neither can be honest: the app's GitHub repo is private (its releases page is a 404 to visitors) and the repo has no licence file. The GitHub icon was taken out of the docs header for the same reason.

Meanwhile the container images and the Helm chart ARE public, and the chart's own README sends people to the private releases page.

Steve to decide: does the app repo go public, and under what licence or terms is Compass offered? If the repo stays private, the site needs its own releases / changelog page and a licence page.

Done when: the decision is recorded, the footer column is back with links that work, and the chart's README points somewhere a visitor can reach.

Technical: footer columns are in src/components/Footer.astro; the docs' GitHub link is the `social` option in astro.config.mjs. The README fix is a task for the app repo (COM), not this one.
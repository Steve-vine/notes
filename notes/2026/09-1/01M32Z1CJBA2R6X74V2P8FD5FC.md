---
id: 01M32Z1CJBA2R6X74V2P8FD5FC
created: 2026-09-21T21:48:00.971156Z
updated: 2026-09-21T21:48:00.971156Z
type: task
title: Decide how the Access Control and Inventory screenshots are shown
label: improvement
priority: low
task_status: backlog
assignee: steve
project: 01M32Q7WT6058ZQFMMRM8KP1K6
number: 10
---
On the home page, every screenshot is cropped from the top-left into a fixed frame so the text stays readable on a phone. The Access Control and Inventory screenshots are much wider than their frames (about 3.5 times as wide as they are tall, in a frame about 1.9 times as wide), so roughly the right-hand 45% of each is cut off - the later table columns never show.

Options: leave it (the left-hand columns are the recognisable part); retake the two screenshots in a narrower browser window so more fits; or give those two frames a wider shape.

Done when: Steve has picked one and, if it needs a change, it is made.

Technical: frames are the `ratio` prop on <Shot> in src/pages/index.astro (1.9 for the three module shots). Source images are 3064x890 and 3072x846 in src/assets/screenshots/.
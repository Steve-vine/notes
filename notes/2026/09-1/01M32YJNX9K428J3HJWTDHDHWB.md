---
id: 01M32YJNX9K428J3HJWTDHDHWB
created: 2026-09-21T21:39:59.017626Z
updated: 2026-09-21T21:43:55.844181Z
type: task
title: 'Docs site layout '
project: 01M32Q7WT6058ZQFMMRM8KP1K6
number: 1
comments:
- id: 01M32YSX647VN83PW6MDM08EYP
  author: Steve Vine
  at: 2026-09-21T21:43:55.844027Z
  text: |-
    Pushed to staging (1cdb166).

    What changed: the left sidebar is about 10% narrower (300px -> 272px). The "On this page" column is now a fixed 272px instead of growing with the screen - on the monitor in the screenshot it was about 540px, so it is half the size. The reading column is centred in the space between the two.

    To check: git pull (no npm install needed), open any docs page on the wide monitor and again at laptop width. The right-hand column should stay the same width at both; below about 1150px wide Starlight moves "On this page" into a dropdown above the content, which is unchanged.

    Technical: src/styles/starlight.css - --sl-sidebar-width 17rem, new --docs-toc-width 17rem, and a 72rem media block overriding Starlight's .right-sidebar-container / .main-pane widths (its default is base width + half the spare viewport).
assignee: steve
priority: medium
task_status: review
---
Panels need resizing.
![compass documentation.png](attachments/2026/09/01M32YJNX9K428J3HJWTDHDHWB/compass-documentation.png)

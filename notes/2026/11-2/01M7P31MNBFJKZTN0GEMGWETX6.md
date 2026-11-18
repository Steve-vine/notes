---
id: 01M7P31MNBFJKZTN0GEMGWETX6
created: 2026-11-18T01:06:25.0673Z
updated: 2026-11-18T01:24:38.570688Z
type: task
title: A built-in check's card on a control's Evidence tab fits a phone again
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1924
sprint: s7nqsy0
comments:
- id: 01M7P42YH3FBXFP173M3WB8BC5
  author: Steve Vine
  at: 2026-11-18T01:24:36.514967Z
  text: |-
    Done — PR #1897, merged b21a7177.
    On a control's Evidence tab, the Automated Collection pill now says only how far the control is automated (Partly automated, Fully automated…). How its checks are doing ("A check's evidence is Non-compliant") sits beside it as plain words that wrap. On a phone, the pill and its words drop under the heading, so the page no longer scrolls sideways. Coverage's side panel shows the same pair.
    Measured in headless Chromium at 390px: the page was 406px wide before and is 390px now. At desktop width it looks as before.
    Assumption: the status words now start with a capital, since they stand on their own.
    To check on staging: the Browser smoke's phone step "the check screens fit a phone" goes green after the next deploy.
assignee: steve
label:
- bug
priority: high
task_status: review
---
Found by the Browser smoke after staging 3171ce79 (sprint 117 round 4), 2026-11-18 01:05 GMT. On a phone (390px), a built-in check's card on a control's Evidence tab makes the page scroll sideways. `phone.spec.ts` › "the check screens fit a phone" fails: "a built-in check's card on a control's Evidence tab: the page scrolls sideways". It passed on 00a2eb16, so it most likely comes from COM-1901, which added "Compass's test: …" and the new status words to that card. Run 44210924974.

**Done when**
- At 390px wide, a built-in check's card on a control's Evidence tab doesn't make the page pan sideways, and the card still shows the evidence status and what Compass's own test found.
- The Browser smoke is green on staging.

Independent (frontend only). Fix-forward for COM-1901.
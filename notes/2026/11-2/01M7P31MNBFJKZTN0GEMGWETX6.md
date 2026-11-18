---
id: 01M7P31MNBFJKZTN0GEMGWETX6
created: 2026-11-18T01:06:25.0673Z
updated: 2026-11-18T07:53:19.029452Z
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
- id: 01M7P78N1SDZCT1VQA9JP7T4VX
  author: Steve Vine
  at: 2026-11-18T02:20:09.145632Z
  text: |-
    Pre-UAT on staging dcc8a235 — Passed
    - At 390px a built-in check's card on the Evidence tab doesn't pan sideways, and still shows the status and Compass's test: as E2E Admin A, E2E Test Company, opened IDM.6 ▸ Evidence at 390×844. The page is 390px wide (nothing to scroll sideways; trying to scroll right stays at 0). The Automated Collection pill "Partly automated" with "A check's evidence is Non-compliant" sits under the heading and fits. CHB-4's card shows Built-in, Non-compliant, "Compass's test: Failing, 180 of 1,216 · last ran 18 Nov 2026, 01:40", "Set by Compass's test" and the detail line, all wrapping inside the card. At 1440px it looks as before: the pill and its words sit on the heading's right, and the card is unchanged. Passed.
    - The Browser smoke is green on staging: the staging deploy run 44220165886 (staging branch, dcc8a235) ran the Browser smoke, 34 passed, including phone.spec "the check screens fit a phone" (✓, 7.1s). Passed.
    Screenshots: ~/compass-uat/s7nqsy0/COM-1924/ (1924-idm6-evidence-390px.png, 1924-idm6-card-390px.png, 1924-idm6-desktop.png)
assignee: steve
label:
- bug
priority: high
task_status: done
---
Found by the Browser smoke after staging 3171ce79 (sprint 117 round 4), 2026-11-18 01:05 GMT. On a phone (390px), a built-in check's card on a control's Evidence tab makes the page scroll sideways. `phone.spec.ts` › "the check screens fit a phone" fails: "a built-in check's card on a control's Evidence tab: the page scrolls sideways". It passed on 00a2eb16, so it most likely comes from COM-1901, which added "Compass's test: …" and the new status words to that card. Run 44210924974.

**Done when**
- At 390px wide, a built-in check's card on a control's Evidence tab doesn't make the page pan sideways, and the card still shows the evidence status and what Compass's own test found.
- The Browser smoke is green on staging.

Independent (frontend only). Fix-forward for COM-1901.
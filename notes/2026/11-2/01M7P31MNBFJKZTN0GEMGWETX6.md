---
id: 01M7P31MNBFJKZTN0GEMGWETX6
created: 2026-11-18T01:06:25.0673Z
updated: 2026-11-18T01:06:25.0673Z
type: task
title: A built-in check's card on a control's Evidence tab fits a phone again
priority: high
task_status: active
assignee: steve
label: bug
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1924
---
Found by the Browser smoke after staging 3171ce79 (sprint 117 round 4), 2026-11-18 01:05 GMT. On a phone (390px), a built-in check's card on a control's Evidence tab makes the page scroll sideways. `phone.spec.ts` › "the check screens fit a phone" fails: "a built-in check's card on a control's Evidence tab: the page scrolls sideways". It passed on 00a2eb16, so it most likely comes from COM-1901, which added "Compass's test: …" and the new status words to that card. Run 44210924974.

**Done when**
- At 390px wide, a built-in check's card on a control's Evidence tab doesn't make the page pan sideways, and the card still shows the evidence status and what Compass's own test found.
- The Browser smoke is green on staging.

Independent (frontend only). Fix-forward for COM-1901.
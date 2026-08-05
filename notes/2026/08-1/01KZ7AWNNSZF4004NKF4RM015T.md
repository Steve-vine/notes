---
id: 01KZ7AWNNSZF4004NKF4RM015T
created: 2026-08-04T21:29:19.801412Z
updated: 2026-08-05T19:41:55.967773Z
type: task
title: Suggest a feature
project: 01KY6W9951TW0904DT0GGJVGE7
number: 391
sprint: segj1dz
comments:
- id: 01KZ9MM9BSEYRVT9JTGVZHPPM3
  author: Steve Vine
  at: 2026-08-05T18:57:59.670775Z
  text: |-
    Fleshed out with Steve (2026-08-05):

    Scope — an in-app affordance that files a feature request as a Task into the vault, rather than posting to GitHub or having Claude propose features. It rides the existing capture-prefill path (openCaptureForm), so no new storage: the capture window opens prefilled Type=Task, project + sprint set, status=backlog, and the idea lands in the tracker without leaving what you were doing.

    Entry point — a small icon in the main window, immediately to the left of the Settings gear.

    Open question being worked: how the target project/sprint is named, since prefilling "Notuvia / Backlog" can't be hardcoded in a generic app.
- id: 01KZ9NTHTKKJY0N2PM5K0APV8G
  author: Steve Vine
  at: 2026-08-05T19:18:53.523298Z
  text: |-
    PR #384 — https://github.com/Steve-vine/notuvia/pull/384 (ADR 0050)

    Resolved the open question by making the destination configuration rather than code: AppConfig gains feature_project + feature_sprint, named in Settings → Projects → "Feature requests" (project select, then a sprint select scoped to it). The app can't know which project collects ideas about itself, so it asks once instead of guessing — unconfigured, the bulb opens that Settings pane rather than filing anywhere.

    Status isn't prefilled; the pool default applies on save (DEV-824), so it works whatever a vault calls its first task status. A deleted project degrades the setting to unset.

    To finish setup after merge: point it at Notuvia / Backlog (or Enhancements).

    check / test / build / fmt / clippy / cargo test all green. Not yet clicked through in the running app.
assignee: steve
priority: medium
task_status: done
---
Add a capability to suggest a new feature. Need to discuss this to flesh it out.
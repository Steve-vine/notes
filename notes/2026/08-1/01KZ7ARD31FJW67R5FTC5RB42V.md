---
id: 01KZ7ARD31FJW67R5FTC5RB42V
created: 2026-08-04T21:26:59.937583Z
updated: 2026-08-05T19:41:57.27478Z
type: task
title: Release notes
project: 01KY6W9951TW0904DT0GGJVGE7
number: 390
sprint: segj1dz
comments:
- id: 01KZ9PJSVYXWFNMGWR106KBJJJ
  author: Steve Vine
  at: 2026-08-05T19:32:08.187936Z
  text: |-
    PR #385 — https://github.com/Steve-vine/notuvia/pull/385

    The relaunched build can't ask the channel what it just installed, so the outgoing process stashes the manifest's notes on its way out and the incoming one shows them once. The notes are the GitHub release body (--generate-notes → latest.json), rendered as sanitised markdown through the note renderer.

    Edge cases handled: a manual dmg install names the version with no notes rather than showing a previous release's; a fresh install announces nothing; a stash for a version that never arrived is cleared so a failed install can't surface its notes against a later release.

    check / test (238) / build green, with releaseNotes.test.ts covering the decision table. NOT verifiable end-to-end until a real update installs — that can only be confirmed on the next release.
assignee: steve
priority: medium
task_status: done
---
After a new release is installed, display a modal showing what new features have been added and/or bugs have been fixed.
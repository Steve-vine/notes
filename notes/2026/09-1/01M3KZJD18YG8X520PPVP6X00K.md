---
id: 01M3KZJD18YG8X520PPVP6X00K
created: 2026-09-28T12:24:23.84841Z
updated: 2026-09-28T12:24:42.721569Z
type: task
title: Privacy policy covers feature requests and the check-in link
project: 01KY6W9951TW0904DT0GGJVGE7
number: 471
sprint: svg0tvg
blocked_by:
- 01M3KZH6MVXRQFRJQ2F2S8QMRJ
assignee: steve
label:
- chore
priority: high
task_status: todo
tech:
- docs
---
ADR 0065 changes what Notuvia collects. The privacy policy has to match before a build that can send requests is released. The policy isn't in this repo, so Steve publishes it.

## Agreed work

- [ ] A new section on feature requests: what's sent (email, summary, details, version, OS/arch, install id), why (to reply and to know which build it's about), where it goes (`checkin.notuvia.net`, Cloudflare D1, EU), how long it's kept (12 months, or sooner on request) and how to ask for deletion.
- [ ] Revise the daily check-in section. The check-in payload is unchanged, but for an install that has sent a feature request, its check-in history can now be linked to that email. Stop calling it strictly "anonymous" where that's no longer true.
- [ ] Hold the release that includes NOT-469 (the dialog) until the updated policy is live.

## Notes

Claude can draft the policy text from ADR 0065 once it has merged.
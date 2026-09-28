---
id: 01M3KZJD18YG8X520PPVP6X00K
created: 2026-09-28T12:24:23.84841Z
updated: 2026-09-28T21:26:22.857592Z
type: task
title: Privacy policy covers feature requests and the check-in link
project: 01KY6W9951TW0904DT0GGJVGE7
number: 471
sprint: spqrtwg
blocked_by:
- 01M3KZH6MVXRQFRJQ2F2S8QMRJ
- 01M3MY0Y6T6DRHJ60MPGHKJZ5T
comments:
- id: 01M3M516ENF2F1MPMQYFRBYBB2
  author: Steve Vine
  at: 2026-09-28T13:59:51.505303Z
  text: 'On hold (2026-09-28): there''s no website or privacy policy yet, because Notuvia is still in test. When the policy is written, it needs to cover feature requests from the start, including the check-in link. The pane''s disclosure line (FeatureRequestPane.svelte) should also get a link to it at that point. There''s currently no link.'
- id: 01M3MY2PASG1RNW1CF5WHNB8D0
  author: Steve Vine
  at: 2026-09-28T21:17:34.937802Z
  text: The policy will be a page on the website (Steve-vine/notuvia-website, Astro + Starlight), so the text is drafted there as markdown once the scaffold (NOT-478) lands. Go-live (NOT-485) is blocked on this. If the site adds Cloudflare Web Analytics (decided in NOT-485), the policy has to cover that too.
assignee: steve
label:
- chore
priority: high
task_status: backlog
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
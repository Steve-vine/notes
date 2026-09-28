---
id: 01M3KZJD18YG8X520PPVP6X00K
created: 2026-09-28T12:24:23.84841Z
updated: 2026-09-28T22:06:55.868675Z
type: task
title: Privacy policy covers feature requests and the check-in link
project: 01KY6W9951TW0904DT0GGJVGE7
number: 471
sprint: spqrtwg
blocked_by:
- 01M3KZH6MVXRQFRJQ2F2S8QMRJ
- 01M3MY1APNGC5GRXYGCCWJJ9T3
comments:
- id: 01M3M516ENF2F1MPMQYFRBYBB2
  author: Steve Vine
  at: 2026-09-28T13:59:51.505303Z
  text: 'On hold (2026-09-28): there''s no website or privacy policy yet, because Notuvia is still in test. When the policy is written, it needs to cover feature requests from the start, including the check-in link. The pane''s disclosure line (FeatureRequestPane.svelte) should also get a link to it at that point. There''s currently no link.'
- id: 01M3MY2PASG1RNW1CF5WHNB8D0
  author: Steve Vine
  at: 2026-09-28T21:17:34.937802Z
  text: The policy will be a page on the website (Steve-vine/notuvia-website, Astro + Starlight), so the text is drafted there as markdown once the scaffold (NOT-478) lands. Go-live (NOT-485) is blocked on this. If the site adds Cloudflare Web Analytics (decided in NOT-485), the policy has to cover that too.
- id: 01M3MYMK58PWRSKK0GG8NFK8K7
  author: Steve Vine
  at: 2026-09-28T21:27:21.512275Z
  text: 'The Claude Design project "Notuvia website design" includes a drafted Privacy page (legalData.privacy). It predates ADR 0065: it says Notuvia "collects exactly one thing — an anonymous daily check-in" and lists "Your name, email" under "never collects". Both statements become false once feature requests ship. Use the design''s structure and the check-in detail, which are accurate (fields, 13-month retention, no IP stored), and add the feature-request section and the linkability caveat this task already requires. The page lives at notuvia.com/privacy and shares its layout with NOT-491 (License and Security).'
- id: 01M3N0WPM6A9MA2K166A6P2H01
  author: Steve Vine
  at: 2026-09-28T22:06:44.358474Z
  text: |-
    Built and pushed to staging (7291af9): notuvia.com/privacy/. It uses the shared legal layout, starts from the design's text, and is corrected against the check-in client, the Worker source, and ADRs 0064 and 0065.
    - The intro and "What Notuvia never collects" now say Notuvia sends two things, and that an email is only sent with a feature request.
    - Daily check-in:
      - the exact payload and what each field means;
      - it is per kind (app and MCP server);
      - a failed check-in retries hourly and is not queued;
      - there is no off switch, stated openly;
      - checkin.json is in the settings folder;
      - no IP address or request logs are kept;
      - 13 months, then rolled into totals with no IDs.
    - Feature requests (new section): the payload; the email is used only to reply, is not verified, and is remembered locally in the app's settings; stored on checkin.notuvia.net in Cloudflare D1 (Western Europe); deleted 12 months after arrival.
    - How a request affects the check-in (new): check-ins from an install that has sent a request are pseudonymous, not anonymous.
    - Asking about or deleting your data (new): for now, ask via Settings → Request a feature with the same email. Every request from that address can be deleted at once. An anonymous check-in can only be found if you give your install_id.
    - Also covered: update checks, services you connect, and "Who is responsible" (Steve Vine, UK).
    - **Feature requests already shipped in 0.30.0, so this page should go live soon.** Open for Steve:
      - a proper contact address for privacy requests;
      - confirm Steve as the data controller;
      - once live, link the feature-request pane's disclosure line to /privacy/ (app side, NOT-484).
    To look at: /privacy/ at desktop and phone widths, in both themes.
assignee: steve
label:
- chore
priority: high
task_status: review
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
---
id: 01M49KFW14MDMJTVB7PAME4QJ7
created: 2026-10-06T21:56:35.492961Z
updated: 2026-10-06T22:13:18.829211Z
type: task
title: Joiner form tidy-up — a wider window, the sign-in domain fully visible, the asterisk on the label's line, no note under Additional roles
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 851
comments:
- id: 01M49MEFAB0DP1V0XX1VQFQDEZ
  author: Steve Vine
  at: 2026-10-06T22:13:18.283855Z
  text: |-
    Done — PR #856, merged (04ffe37) and on staging.

    - The new-joiner window is wider (896px, was 620px). The mover window got the same width — it has the same two-to-a-row layout; the other request forms are unchanged. Say if you'd rather the mover stayed as it was.
    - The sign-in domain is readable in full: Display name and sign-in name no longer split the row in half, and the domain has the wider box. Checked in a real browser with moneypenny.co.uk and the longest brand domain on staging (qualityansweringservice.com) — both fit. A domain longer than any box (the Exclaimer routing one) shows in full on hover.
    - "User principal name *" is one line.
    - The note under Additional roles is removed — on the joiner form, and on the mover form and the approval editor too, since they share the fields.
assignee: steve
label:
- improvement
priority: medium
task_status: review
---
Asked for by Steve after smoke-testing sprint 63 on staging, 2026-10-06.

## What changes

- **The new-joiner window is bigger.** The sign-in domain didn't fit in its box and couldn't be read in full.
- **The asterisk after "User principal name" stays on the label's line** — it was dropping onto the next one.
- **The note under Additional roles is removed** ("Their groups and shared mailboxes are added — nothing else.").

## Done when

- On the new-joiner form the longest domain on the Sign-in domains list can be read in full, with the name box still usable.
- "User principal name *" is one line.
- Nothing is shown under Additional roles.
- Released to staging.
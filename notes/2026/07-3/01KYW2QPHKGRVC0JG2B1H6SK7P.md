---
id: 01KYW2QPHKGRVC0JG2B1H6SK7P
created: 2026-07-31T12:35:09.491532Z
updated: 2026-08-05T12:33:42.767459Z
type: task
title: Landing page — what ISE is, the core loop
project: 01KX671DATY39VW6GWK3M2T3DN
number: 405
sprint: sp3en5k
blocked_by:
- 01KYW2Q2N03YTZX0VEAMZAKN9N
comments:
- id: 01KYW4M4QGX859TKW06752MDAQ
  author: Steve Vine
  at: 2026-07-31T13:08:10.096358Z
  text: |-
    Done on feature/ise-405-landing-page (PR #4 → main, squash-merged).

    Splash hero ("Infrastructure State Engine" + governed-pane-of-glass tagline, Get started / How ISE works CTAs into the docs), core loop as a four-card grid (Monitor / Analyse / Evaluate / Configure), "Built for operators" principles (one estate, signals→incidents, governed change, pre-approved response), systems-in-scope paragraph linking all eight integration docs pages. Copy grounded in product-vision.md, released capability only. Template mascot (houston.webp) removed.
assignee: steve
label: null
priority: medium
task_status: done
---
Product landing page at `/`, written technical & direct for expert infrastructure operators — no marketing fluff. Content: what ISE is (single pane of glass over the estate), the core loop Monitor → Analyse → Evaluate → Configure, systems in scope, and a clear CTA into the docs. Screenshot placeholders are acceptable this sprint.

Ground the copy in `../ise/docs/briefs/product-vision.md`, rewritten for the site — describe only what is on `main` in the app repo, never planned capability.

Depends on ISE-403.
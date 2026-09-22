---
id: 01M32NNG4JZ4DPWEKHZ73WV4XS
created: 2026-09-21T19:04:14.226979Z
updated: 2026-09-22T16:12:14.46164Z
type: task
title: Update logo and favicon
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 733
sprint: s3nfes0
comments:
- id: 01M32QCFY8TT9NGGTG9MXZ30HS
  author: Steve Vine
  at: 2026-09-21T19:34:16.264425Z
  text: |-
    Done in PR #743 (merged to main, c360ea4).

    What changed: the new mark replaces the outline compass everywhere it was drawn — the app header, the Compass Portal header, the Vendor Portal header (when no vendor-portal logo is set) and its preview in Vendor Portal settings — and in the browser tab. Same size and position as before.

    Two things worth knowing:
    - The supplied PNG had scattered semi-transparent specks left over from the background removal (visible on a dark header). I cleaned those off; only the ring and needle remain. The original attachment is untouched.
    - The old mark followed the accent colour chosen under Admin → Appearance. The new one is an image, so it stays this blue whatever accent is set.

    To check on staging: the header in both light and dark mode, the Compass Portal, a vendor's portal link, and the browser tab (a hard refresh may be needed — browsers cache favicons hard).

    Technical: one CompassMark component (src/components/CompassMark.tsx) replaces four copies of the Tabler icon; asset is a 104 px PNG padded to the old icon's 20-in-24 proportions. /favicon.svg keeps its path (nginx, the Vendor Portal ingress and check-portal-host-boundary.sh all name it) and now embeds a 64 px PNG — no chart change needed.
assignee: steve
label: null
priority: medium
task_status: done
---
Replace the logo and favicon with the attached image. Keep the sizing the same.

![Compass-stylised-transparent.png](attachments/2026/09/01M32NNG4JZ4DPWEKHZ73WV4XS/Compass-stylised-transparent.png)

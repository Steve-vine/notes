---
id: 01M3MY1FMHCVMQQQ40MN451R0Y
created: 2026-09-28T21:16:55.313085Z
updated: 2026-09-28T22:06:49.465079Z
type: task
title: 'Website: home page (About)'
project: 01KY6W9951TW0904DT0GGJVGE7
number: 481
sprint: spqrtwg
blocked_by:
- 01M3MY1APNGC5GRXYGCCWJJ9T3
comments:
- id: 01M3N0VPVZG1651JRWDHM21W0Z
  author: Steve Vine
  at: 2026-09-28T22:06:11.838982Z
  text: |-
    Built and pushed to staging (0f72020, 0c6a1bf).
    - The home page from the design. Hero: "Write it down. Find it again.", Download for macOS, See what it does, and "Free · Works fully offline · No account". Then Core Principles with the wordmark, the Organise, Plan, Write and Connect bands, and the closing band.
    - Every claim is checked against the released app (0.30.0). Changes from the design:
      - The Plan band drops "milestones", because sprints replaced them in the app.
      - The closing line says "Your notes never leave your machine unless you send them", because the daily check-in and update checks do go out.
    - Screenshots come from src/assets/screenshots/ through a Shot component: an optional -dark variant, and a labelled placeholder until a file exists. The design's images are mock-ups (their embedded content credentials say Claude made them), so they aren't used. **Needed from Steve:** hero.png (16:10), then browse.png, planner.png, panes.png and mcp.png (4:3).
    - Copy question: keep "the one-line thought and the ten-thousand-word page"?
    To look at: / at desktop and phone widths in both themes, and where the screenshots go.
assignee: steve
label:
- brief
priority: medium
task_status: review
tech: null
---
The design's home page, "Write it down. Find it again.", from the Claude Design project "Notuvia website design".

## Scope

- [ ] Hero: headline, intro, buttons for Download and See what it does, and the line "Free · Works fully offline · No account".
- [ ] Core Principles: Capture is instant; Retrieval is the product; You own the files.
- [ ] The four feature bands (Organise, Plan, Write, Connect), each with a screenshot, then the closing "The app can die. The notes survive."
- [ ] Screenshots from the real app (the design's `screenshots/` are placeholders or earlier captures), with light and dark versions if possible, as compass-website does.
- [ ] Check every claim against the app today. The intro says "the ten-thousand-word page", which differs from the app's own framing of one-line fragments; confirm with Steve. "Free · No account" depends on the pricing decision (see the Pricing task).

**Done when:** the page matches the design at desktop and phone widths, and every claim is checked.
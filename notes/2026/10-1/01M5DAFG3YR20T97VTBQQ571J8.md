---
id: 01M5DAFG3YR20T97VTBQQ571J8
created: 2026-10-20T18:51:45.662037Z
updated: 2026-10-21T20:16:50.71451Z
type: task
title: A data subject request's page is laid out in numbered sections, like an access request
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1177
sprint: ss8348q
comments:
- id: 01M5F0WNR5H3J4PYKJPGEATV0R
  author: Steve Vine
  at: 2026-10-21T10:42:40.516732Z
  text: |-
    Done — PR #1196, merged 21 Oct 11:42 BST.

    - A request's page now shows its steps as numbered boxes: Request, Verify, Decide, Fulfil, Tell recipients, Letters. Each step's title sits inside its box beside its number, with the step's buttons on the right of the title. (Respond is added by COM-1178.)
    - Fulfil is one box. Systems holding their data, What was provided, Erasure record and Who their data was disclosed to (or Accounting of disclosures) are parts inside it, each under a small sub-heading with its own buttons.
    - Request (details and attachments) and Verify (identity, and a representative's authority) are laid out the same way.
    - A step that doesn't apply isn't shown and takes no number, so the numbers never have a gap. COM-1179 uses this to hide Tell recipients on an access request.
    - The side column stays in view as you scroll. The timeline and history stay below the steps, unnumbered.
    - Nothing a card did is lost: buttons, correction notes, and the Status card's links still land on the right part.
    - It uses the same numbered box as the Access Control request windows, now shared. Access Control looks and works exactly as before.

    My call: where a step holds only one thing (Decide, Tell recipients, Letters), there's no second heading repeating the step's title, and its buttons sit on the step's title line.
assignee: steve
label:
- improvement
priority: medium
task_status: done
---
Steve's request while smoke-testing sprint 79.

**What's wrong:** a request's page is a run of loose headings (Request, Verify, Decide, Fulfil, Tell recipients, Letters), each with one or more cards under it. Fulfil alone has up to four separate cards. The page doesn't read as a sequence of steps, and it's hard to tell where one step ends and the next begins.

**What it should do:** follow the Access Control request window (the joiner / mover / leaver forms):
- Each step is **one box with a number**. The step's title sits **inside** the box, beside its number, with any buttons for the whole step at the right of the title.
- The steps, in order: **Request**, **Verify**, **Decide**, **Fulfil**, **Tell recipients**, **Respond**, **Letters**. (Respond is added by the Fulfil reshape task.)
- **Fulfil is a single section.** What are cards today (Systems holding their data, Who their data was disclosed to / Accounting of disclosures, Erasure record) become parts inside it, each under a small sub-heading, not boxes of their own.
- The same goes for the other steps with more than one card (Request: details + files; Verify: identity + authority).
- A step that doesn't apply to the request isn't shown and takes no number, so the remaining steps number on without a gap. Tell recipients on an access request is the first case.
- The side column (Status, Deadline, Retention) stays as it is and stays in view while the steps scroll, like the access request's summary.
- The timeline and history stay below the steps, unnumbered.

**Behind it (technical):** reuse the access request window's numbered section rather than building a second one. `RequestSection` in `access/requestWindow.tsx` numbers itself with a CSS counter, so a step that isn't rendered takes no number. Move it somewhere shared if the request page needs it outside `access/`. Each DSR card becomes a part inside its area's section; the `Panel` boxes inside an area go. Screen-conventions tests apply.

**Done when:** a request's page shows its steps as numbered boxes with the title inside each; Fulfil is one box; the numbers have no gaps when a step is hidden; and nothing a card does today (buttons, correction notes, links from the Status card's "where it stands" jump links) is lost.
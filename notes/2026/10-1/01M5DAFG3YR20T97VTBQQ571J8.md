---
id: 01M5DAFG3YR20T97VTBQQ571J8
created: 2026-10-20T18:51:45.662037Z
updated: 2026-10-20T18:52:08.418012Z
type: task
title: A data subject request's page is laid out in numbered sections, like an access request
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1177
sprint: ss8348q
assignee: steve
label:
- improvement
priority: medium
task_status: todo
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
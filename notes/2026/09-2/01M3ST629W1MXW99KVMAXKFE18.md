---
id: 01M3ST629W1MXW99KVMAXKFE18
created: 2026-09-30T18:45:43.356596Z
updated: 2026-10-01T01:20:38.594798Z
type: task
title: The vendor portal and the sign-in pages in the new look — what suppliers and signed-out visitors see
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 814
sprint: s0zzctz
blocked_by:
- 01M3ST04QGV1F3BH3F9J4XDZXK
comments:
- id: 01M3TGS2DSD0NEQKNJHYNFV8XP
  author: Steve Vine
  at: 2026-10-01T01:20:34.745454Z
  text: |-
    Done: PR #822, merged to main (0a72bc0).

    What you'll see:
    - **Sign in, Forgot password and Reset password:** a centred card on the new background, with the Compass mark above the title and then the form. The wording and the steps are the same, including Microsoft sign-in where it's set up.
    - **The vendor portal:**
      - Its own simple top bar, with the logo and "contact · vendor". There's no menu and no trail, as before.
      - Its home lists the questionnaires, each with a progress bar, what's left to answer, the due date and a status. "Finalise and submit" stays in view at the bottom.
      - **A questionnaire:** each numbered question folds open and shut, with its follow-up questions inside it and a dot saying To answer, Answered or Optional. **Save and Submit stay in view** at the bottom of the window.
    - **A dead or expired link** shows the same centred card as sign-in.

    Things decided while building:
    - **Each question is what folds.** Questionnaires don't have sections, so each numbered question and its follow-ups fold together.
    - **Submit still sends everything at once,** as before. Pressing Submit on a questionnaire takes the supplier to the home page with the final check open. It stays greyed out until every questionnaire is answered.
    - **Save** saves what's being typed straight away and says "All answers saved".
    - **The sign-in pages are deliberately exempt** from the new page header. A single centred card shouldn't have a header pinned to its top-left.

    All checks passed. Not yet looked at in a browser, so the staging check is the first look, in light and dark.
assignee: steve
label:
- improvement
priority: medium
task_status: review
---
Part of sprint 65, UI Upgrade (ADR in COM-794). Steve chose both portals (2026-09-30), so suppliers see the new look too. The sign-in pages are what everyone sees first, so they come with it.

## What people see

- **Sign in, Forgot password and Reset password:**
  - a centred card on the new ground, with the Compass mark;
  - fields and buttons in the kit's style, the main button outlined in violet;
  - light or dark following the computer's setting;
  - wording and flows unchanged, including SSO where it's set up.
- **The vendor portal:**
  - keeps its own simple frame (no sidebar): the Compass mark, the vendor's name, and sign out;
  - its home lists the questionnaires waiting and done, as kit list rows with status pills;
  - **A questionnaire** is laid out for reading and answering: sections that fold, each question with its answer field, progress through the questionnaire in the header, and Save and Submit in a footer that stays in view;
  - its dead-end page in the new look.
- **No trail in the vendor portal**, as before (ADR 0084 exempts it).

## Notes (technical)

- **Pages:** `LoginPage`, `ForgotPasswordPage`, `ResetPasswordPage`; `vendorPortal/` — `VendorPortalApp`, `VendorPortalHome`, `VendorPortalAssessmentPage`, `VendorPortalDeadEnd`.
- **Theme.** These pages sit outside `AppLayout`, so check they get the same `MantineProvider` theme and colour-scheme manager.
- **Keep** the vendor portal's exemption in the back-link ratchet.
- **Ratchet.** Empty these pages' entries from the page-header ratchet (or exempt the sign-in pages if a page header is wrong for them, and say why in the allowlist).

**Done when:** on staging, signing in and resetting a password, and a vendor contact answering and submitting a questionnaire, all look like the new Compass in light and dark.
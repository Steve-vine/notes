---
id: 01M3ST629W1MXW99KVMAXKFE18
created: 2026-09-30T18:45:43.356596Z
updated: 2026-10-01T00:04:36.254892Z
type: task
title: The vendor portal and the sign-in pages in the new look — what suppliers and signed-out visitors see
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 814
sprint: s0zzctz
blocked_by:
- 01M3ST04QGV1F3BH3F9J4XDZXK
assignee: steve
label:
- improvement
priority: medium
task_status: active
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
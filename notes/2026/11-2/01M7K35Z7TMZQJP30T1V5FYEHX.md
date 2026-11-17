---
id: 01M7K35Z7TMZQJP30T1V5FYEHX
created: 2026-11-16T21:11:03.674936Z
updated: 2026-11-17T10:50:45.562222Z
type: task
title: 'Check page: every action on the check''s control card is on the check''s own page too (fields it keeps, ask Polaris, switch off)'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1879
sprint: s7nqsy0
comments:
- id: 01M7MDNQWSTHVNB6SXZQT83MRX
  author: Steve Vine
  at: 2026-11-17T09:33:40.633804Z
  text: |-
    Done — PR #1874, merged 4fd91613.
    A check's own page now has a ⋮ menu beside Edit and Delete with everything the check's ⋮ menu on its control card has, in the same words and for the same people:
    - Ask Polaris to check this
    - Ask Polaris to re-create it
    - Change the fields it keeps: the card's own editor (tick, untick and order, from the next capture), opened under Details
    - Switch off / Switch on: asks first, as on the card
    Polaris's verdict and its corrected check show at the top of the page, as they do on the card, with Approve and Dismiss.
    Both screens use one menu and one fields editor. When COM-1877 lands, the editor here shows sensitive fields too.
    Assumption: "Edit the reads (advanced)" stays on the card only. On the check's page, reads are changed through Edit ▸ Edit the reads, which sends the change to Review (COM-1867). Two ways to change the reads on one page, with different outcomes, would confuse.
    To check on staging: open CHK-7's page and try each menu item.
- id: 01M7MJ2WDTGXNWTTC44S59J89F
  author: Steve Vine
  at: 2026-11-17T10:50:45.561996Z
  text: |-
    Pre-UAT on staging 44d15b9a — Passed
    - Every card action is on the check's page, for the same people: as E2E Admin A, CHC-2's page has a ⋮ menu beside Edit and Delete with "Ask Polaris to check this", "Ask Polaris to re-create it", "Change the fields it keeps" and "Switch off". The card menu on ACC.13's Evidence tab has the same items in the same words, plus "Edit the reads (advanced)", which stays on the card only (the builder's stated assumption). As E2E Assessor: same menus on both screens. As E2E Viewer: no ⋮ menu on the check's page. Passed.
      - Change the fields it keeps: opens the card's editor under Details (tick/untick, order, plus the sensitive-fields list). Unticked "archived", saved, and History showed "Fields changed: no longer keeps archived". Ticked it again and saved, and History showed "now keeps archived". Passed.
      - Switch off / on: Switch off asks first ("Switch CHC-2 off? Compass stops collecting it…"). Confirming showed OFF, and the menu then offered only Switch on, which also asks first. Switched back on. Passed.
      - Ask Polaris to re-create it: sends the request at once (the server accepted it), the same as the card does. What Polaris comes back with needs its AI provider, so I didn't wait for it. Couldn't check (Polaris's answer).
      - Ask Polaris to check this: greyed out while Polaris's verdict was open, as on the card. It became available once the verdict was closed (see COM-1878). I didn't press it (it needs the AI provider).
    - Polaris's verdict and corrected check show on the page with Approve and Dismiss: CHC-2's page showed "Polaris: Change proposed" with Dismiss at the top, then "Polaris proposes CHC-3 … replaces CHC-2 when you approve it" with Approve and Discard. Passed.
    - Same words on both screens: yes (see above). Passed.
    - One fields editor that shows sensitive fields: the page's editor shows the "Sensitive fields" section with Clear the mark and Mark a field Sensitive. Passed.
    - Tests: the staging deploy run for 44d15b9a is green. I didn't read the test files.
    Screenshots: ~/compass-uat/s7nqsy0/COM-1879/
assignee: steve
priority: medium
task_status: review
---
Defect from Steve's testing of round 2 (staging 43d03f09).

**What happens.** On CHK-7's own page, Edit has no way to change the fields the check keeps. The fields editor is only reachable from the control's Evidence tab, through the check's ⋮ menu ▸ **Change the fields it keeps**. The check's page (COM-1867 Edit, COM-1868 Delete) is also missing the rest of that menu:
- Ask Polaris to check this
- Ask Polaris to re-create it
- Switch off / Switch on
- Polaris's verdict and its corrected check, where there is one (with Approve)

**Done when**
- The check's page has every action its control card has, for the same people. That covers changing the fields it keeps (the same editor: tick, untick and order, from the next capture), asking Polaris to check or re-create it, and switching it off or on (asked first, as on the card).
- Polaris's verdict and its corrected check show on the check's page, as they do on the card, with Approve and Dismiss.
- Wherever the actions sit (in Edit, or a ⋮ menu beside Edit and Delete), the same action uses the same words on both screens.
- When COM-1877 lands, the fields editor here shows sensitive fields too. It's one editor, used on both screens.
- Tests cover each action from the check's page.

**Where** (for the builder): checks/NoRuleCheckPage.tsx, checks/EditCheck.tsx, collection/CollectionCard.tsx (the menu, `EditFields`, `VerdictReview`, `ProposalReview`), collection/EditFields.tsx.
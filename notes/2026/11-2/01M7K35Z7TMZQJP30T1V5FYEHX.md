---
id: 01M7K35Z7TMZQJP30T1V5FYEHX
created: 2026-11-16T21:11:03.674936Z
updated: 2026-11-16T21:11:07.913264Z
type: task
title: 'Check page: every action on the check''s control card is on the check''s own page too (fields it keeps, ask Polaris, switch off)'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1879
sprint: s7nqsy0
assignee: steve
priority: medium
task_status: backlog
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
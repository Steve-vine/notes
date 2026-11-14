---
id: 01M76B4EYRD5P7GMW24D0CQMGM
created: 2026-11-11T22:19:55.224901Z
updated: 2026-11-14T17:05:13.039777Z
type: task
title: Cancelling or closing an audit shows the kept scope straight away, without a reload
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1741
comments:
- id: 01M76CVSW4THTNAHF4BEY8RWRY
  author: Steve Vine
  at: 2026-11-11T22:50:08.644238Z
  text: |-
    Done. PR #1735 merged, on staging at 077a1310.

    **What you see now:** after Cancel audit or Close audit, the Company scope card switches at once to "As it stood when the audit ended, <date>", and the "Edit on Admin ▸ Companies" link goes. No reload is needed.

    **Fix:** frontend only. Cancelling and closing now refresh the audit's scope card.

    **Checks:** a new AuditPage test fails without the fix and passes with it. eslint, `tsc -b`, prettier and the audit tests (79) all pass. PR CI was green, and main's backstop and image build were green.

    **Pre-UAT, Passed** (staging 077a1310, as E2E Admin A in E2E Test Company):
    - Made AUD-4 "E2E COM-1741 scope refresh". Its card read "The company's scope as it stands — kept with the audit when it closes", with the edit link.
    - Cancel audit with a reason. Without a reload, the header read Cancelled and the card read "As it stood when the audit ended, 11 Nov 2026", with no edit link.
    - Screenshot: ~/compass-uat/sprint0-2026-11-11/COM-1741/com-1741-cancelled-scope-card.png
    - Close audit takes the same refresh path but wasn't tried on screen: closing needs an audit that has reached the end of fieldwork.
assignee: steve
label:
- bug
priority: medium
task_status: done
---
Found in the pre-UAT pass of COM-1730 on staging, 2026-11-11.

**Steps:** in E2E Test Company, create an audit, then Cancel audit with a reason.

**Expected:** the Company scope card switches at once to the kept copy: "As it stood when the audit ended, <date>".

**Seen:** the header shows "Cancelled", but the scope card still says "The company's scope as it stands — kept with the audit when it closes" and still has the "Edit on Admin ▸ Companies" link. After a reload it is right. Reproduced on AUD-2 and AUD-3. Screenshot: ~/compass-uat/sprint0-2026-11-11/COM-1730/DEFECT-cancelled-audit-scope-card-not-refreshed.png

**Done when:**
- Cancelling an audit, and closing one, changes the scope card to the kept, dated copy without a reload.
- A frontend test covers it.
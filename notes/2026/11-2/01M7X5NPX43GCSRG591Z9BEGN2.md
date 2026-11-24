---
id: 01M7X5NPX43GCSRG591Z9BEGN2
created: 2026-11-20T19:07:00.900986Z
updated: 2026-11-24T21:39:38.544102Z
type: task
title: The Reopen window's example reason fits what is being reopened, and an asset's reopening reads "Was decommissioned on …"
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2036
comments:
- id: 01M7X6EKSC34REZ3XJK3KE39HK
  author: Steve Vine
  at: 2026-11-20T19:20:36.908524Z
  text: 'Done — PR #2031, merged e8254baf. The Reopen window''s example reason now fits each kind: a plan entry "Marked done on next year''s by mistake", an asset "Decommissioned the wrong server", a questionnaire "Withdrew the wrong questionnaire". An asset''s reopening reads "Was decommissioned on 20 Nov 2026; went back to Deprecated". Not yet on staging; it goes with compass-da''s next deploy, and I''ll check it then.'
- id: 01M7X7YZV6R58BDT1HAWJD0BP3
  author: Steve Vine
  at: 2026-11-20T19:47:02.11833Z
  text: |-
    Pre-UAT on staging e8254baf: Passed
    Tested as E2E Admin A in E2E Test Company.
    - Asset window: Passed. Decommissioned AST-65 again and opened Reopen. The reason box suggests "Decommissioned the wrong server". Reopened it ("Recheck COM-2036"): it came back Deprecated again.
    - Asset history: Passed. Both reopenings on AST-65's Lifecycle card read "Was decommissioned on 20 Nov 2026; went back to Deprecated".
    - Questionnaire window: Passed. A fresh E2E questionnaire on E2E Test Vendor was withdrawn, and Reopen… suggests "Withdrew the wrong questionnaire". I left it closed.
    - Plan entry window: unchanged, still "Marked done on next year's by mistake".
    Also seen: the questionnaire I reopened in the COM-2032 pass has since been sent again and submitted on staging, probably by the Browser smoke. So a reopened questionnaire goes back out through the normal Start flow.
    Screenshot: ~/compass-uat/sprint0/COM-2036/
assignee: steve
label:
- bug
priority: medium
task_status: done
---
Found in the pre-UAT pass of COM-2032 on staging 514c4649 (20 Nov).

- The Reopen window's reason box shows "Marked done on next year's by mistake" everywhere, including when reopening a technology or data asset or a vendor questionnaire, where it makes no sense.
- An asset's Reopened history reads "Was decommissioned since 20 Nov 2026; went back to deprecated".

**Done when**
- The example reason fits each kind: a plan entry "Marked done on next year's by mistake", an asset "Decommissioned the wrong server", a questionnaire "Withdrew the wrong questionnaire".
- An asset's reopening reads "Was decommissioned on 20 Nov 2026; went back to Deprecated".
- Independent (no migration, no API change).
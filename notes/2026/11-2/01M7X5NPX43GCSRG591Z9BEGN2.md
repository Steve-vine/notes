---
id: 01M7X5NPX43GCSRG591Z9BEGN2
created: 2026-11-20T19:07:00.900986Z
updated: 2026-11-20T19:20:37.557845Z
type: task
title: The Reopen window's example reason fits what is being reopened, and an asset's reopening reads "Was decommissioned on …"
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2036
comments:
- id: 01M7X6EKSC34REZ3XJK3KE39HK
  author: Steve Vine
  at: 2026-11-20T19:20:36.908524Z
  text: 'Done — PR #2031, merged e8254baf. The Reopen window''s example reason now fits each kind: a plan entry "Marked done on next year''s by mistake", an asset "Decommissioned the wrong server", a questionnaire "Withdrew the wrong questionnaire". An asset''s reopening reads "Was decommissioned on 20 Nov 2026; went back to Deprecated". Not yet on staging; it goes with compass-da''s next deploy, and I''ll check it then.'
assignee: steve
label:
- bug
priority: medium
task_status: review
---
Found in the pre-UAT pass of COM-2032 on staging 514c4649 (20 Nov).

- The Reopen window's reason box shows "Marked done on next year's by mistake" everywhere, including when reopening a technology or data asset or a vendor questionnaire, where it makes no sense.
- An asset's Reopened history reads "Was decommissioned since 20 Nov 2026; went back to deprecated".

**Done when**
- The example reason fits each kind: a plan entry "Marked done on next year's by mistake", an asset "Decommissioned the wrong server", a questionnaire "Withdrew the wrong questionnaire".
- An asset's reopening reads "Was decommissioned on 20 Nov 2026; went back to Deprecated".
- Independent (no migration, no API change).
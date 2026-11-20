---
id: 01M7X5NPX43GCSRG591Z9BEGN2
created: 2026-11-20T19:07:00.900986Z
updated: 2026-11-20T19:07:00.900986Z
type: task
title: The Reopen window's example reason fits what is being reopened, and an asset's reopening reads "Was decommissioned on …"
priority: medium
assignee: steve
task_status: active
label: bug
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2036
---
Found in the pre-UAT pass of COM-2032 on staging 514c4649 (20 Nov).

- The Reopen window's reason box shows "Marked done on next year's by mistake" everywhere, including when reopening a technology or data asset or a vendor questionnaire, where it makes no sense.
- An asset's Reopened history reads "Was decommissioned since 20 Nov 2026; went back to deprecated".

**Done when**
- The example reason fits each kind: a plan entry "Marked done on next year's by mistake", an asset "Decommissioned the wrong server", a questionnaire "Withdrew the wrong questionnaire".
- An asset's reopening reads "Was decommissioned on 20 Nov 2026; went back to Deprecated".
- Independent (no migration, no API change).
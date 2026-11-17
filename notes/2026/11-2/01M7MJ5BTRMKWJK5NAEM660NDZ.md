---
id: 01M7MJ5BTRMKWJK5NAEM660NDZ
created: 2026-11-17T10:52:06.872038Z
updated: 2026-11-17T10:52:06.872038Z
type: task
title: 'Built-in check screens fit a phone: no sideways panning on the check page, the open card or the Built-in Checks tab'
task_status: active
assignee: steve
priority: medium
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1892
---
From the pre-UAT pass of round 3 (staging 44d15b9a), COM-1881, COM-1883 and COM-1885.

**The problem.** At phone width (390px) three new screens pan sideways:
- a built-in check's page (CHB-4): the Failing table is about 256px wider than the screen
- a control's Evidence tab with a built-in check's card open (IDM.6 ▸ CHB-4): the items table pushes the page about 265px
- Evidence Collection ▸ Built-in Checks: the table pushes the page about 220px

The same happens, by about 40px, on a custom check's page because of its Workflows table (CHC-2).

Screenshots: ~/compass-uat/s7nqsy0/COM-1883/phone-card-table-clipped.png, ~/compass-uat/s7nqsy0/COM-1883/IDM.6-card-phone-dark.png, ~/compass-uat/s7nqsy0/COM-1881/CHB-4-phone-light.png, ~/compass-uat/s7nqsy0/COM-1885/builtin-tab-phone.png

**Done when**
- At 390px wide none of these screens pans sideways. Each fits the screen the way Gaps, Risks, Controls and All checks already do: fewer columns on a phone, with the rest a tap away.
- Nothing changes on a desktop.
- A test pins the phone layout of each table, the same way the existing list tables are pinned.
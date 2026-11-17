---
id: 01M7MJ5BTRMKWJK5NAEM660NDZ
created: 2026-11-17T10:52:06.872038Z
updated: 2026-11-17T19:50:15.46617Z
type: task
title: 'Built-in check screens fit a phone: no sideways panning on the check page, the open card or the Built-in Checks tab'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1892
sprint: s7nqsy0
comments:
- id: 01M7MKNKC7Z4B7TD5KHAZH1ZE5
  author: Steve Vine
  at: 2026-11-17T11:18:27.463778Z
  text: |-
    Done — PR #1888, merged 46cdd83f.
    At phone width none of these screens pans sideways any more. On a phone each shows fewer columns, and the rest are a tap away:
    - A built-in check's page (Failing) and its card opened on a control's Evidence tab: one column. Each item shows its detail (the email address) and its note underneath, and long addresses wrap.
    - Evidence Collection ▸ Built-in Checks: the page shows ID, Check with its state under the description, and On. Controls, thresholds and "Raises its own gap" are on the check's page. Like All checks, the filters stay put while the rows scroll.
    - A custom check's Workflows: ID, Name and Status. Each row opens the workflow, which shows its last run.
    On a desktop nothing changes: I compared every column at 1440px.
    Measured in a real browser at 390px wide: all four tables now fit. Before, they ran over by 220px, 256px, 265px and 40px.
    A new phone Browser smoke test opens all four screens and checks none scrolls sideways. If All checks lists no custom check, it skips that one.
    To check on staging: at 390px, open Built-in Checks, CHB-4's page, IDM.6 ▸ Evidence with CHB-4's Details open, and CHC-2's page. None should pan sideways.
- id: 01M7MPZJQ7YTVT6HXD2WY9ZCBP
  author: Steve Vine
  at: 2026-11-17T12:16:20.199609Z
  text: |-
    Pre-UAT on staging 00a2eb16 — Passed
    - No sideways panning at 390px: as E2E Admin A in E2E Test Company, I measured the page's width against the screen's (390px) on each screen. Every one was 390 of 390, so nothing pans. Before the fix they ran over by 220–265px.
      - Evidence Collection ▸ Built-in Checks: shows ID, Check (with its state underneath) and On. The filters stay put while the rows scroll.
      - CHB-4's page: Failing (180) shows one Item column, with the email address underneath, and long addresses wrap.
      - IDM.6 ▸ Evidence with CHB-4's Details open: the same single column, in light and in dark.
      - CHC-2's page: Workflows shows ID, Name and Status.
      I also opened the other 10 built-in check pages, and IDM.13, IDM.18 and ACC.3's Evidence tabs with every card open. All were 390 of 390. Passed.
    - Nothing changes on a desktop: at 1440px the Built-in Checks tab shows ID, Check, Controls, Thresholds, State, Raises its own gap and On. CHB-4's page and its card show Item, Detail and Note, and CHC-2's Workflows shows ID, Name, Status and Last run. Nothing pans. Passed.
    - A test pins the phone layout: the PR adds a phone layout unit test and a phone Browser smoke test. The staging deploy run for 00a2eb16 is green.
    Screenshots: ~/compass-uat/s7nqsy0/COM-1892/
assignee: steve
priority: medium
task_status: done
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
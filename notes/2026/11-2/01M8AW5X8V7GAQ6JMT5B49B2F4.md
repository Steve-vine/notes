---
id: 01M8AW5X8V7GAQ6JMT5B49B2F4
created: 2026-11-26T02:50:27.995656Z
updated: 2026-11-26T03:28:11.234434Z
type: task
title: A role's Shared mailboxes card names send on behalf, and says where each right is changed
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2176
comments:
- id: 01M8AYAZF2SKKV4QBFCVCFPV86
  author: Steve Vine
  at: 2026-11-26T03:28:11.234229Z
  text: |-
    Done — PR #2184, merged to main (f99b5b21), on staging since 03:27.

    What to look at:
    - **Access ▸ Role matrix ▸ a role ▸ Shared mailboxes, the intro:** "Access to these mailboxes is what this role grants — can open, can send as, can send on behalf, or any of them. Can open and can send as are applied through Exchange Online; send on behalf through Exchange for a cloud mailbox, or in AD — by Compass, or as a to-do — for one synchronised from AD. Access to any other mailbox changes only when a move names it."
    - **Same card ▸ Directory mailboxes:** each mailbox's line counts who can send on behalf too ("73 can open · 63 can send as · 22 can send on behalf — 24Hour@…"). Before send on behalf has been read it says "send on behalf not read".

    **Pre-UAT: Passed** — staging f99b5b21, 26 Nov 03:28, as E2E Admin A, on E2E Starter: the intro and the counted lines read as above, with real counts. Screenshot: ~/compass-uat/sprint-0/COM-2176/

    Technical: screen text only; the role editor already had the count. The COM-829 test in RolesPage.test.tsx checks both the counted and the not-read line. No migration, no API change.
assignee: steve
label: bug
priority: low
task_status: active
---
Found in the pre-UAT pass of the sprint-0 batch on staging 30d00690 (26 Nov), on COM-2174. **Independent** (screen text only).

**Access ▸ Role matrix ▸ a role ▸ Shared mailboxes** now offers *Can send on behalf* on each mailbox (COM-2174), but the card's intro still reads "Access to these mailboxes is what this role grants — can open, can send as, or both. JML applies it through Exchange Online." That's no longer the whole story: send on behalf is a third right, and for a mailbox synchronised from AD it's changed in AD or as an on-prem to-do, not through Exchange. Each mailbox's summary line also counts only *can open* and *can send as*.

## What people should see
- The intro names all three rights and says where they're changed: Can open and Can send as through Exchange Online; Can send on behalf through Exchange for a cloud mailbox, or in AD (by Compass, or as a to-do) for one synchronised from AD.
- Each mailbox's summary line also counts who can send on behalf (or says *not read* when it hasn't been read yet), like the Shared mailboxes list.

**Done when:** on staging, a role's Shared mailboxes card reads as above.
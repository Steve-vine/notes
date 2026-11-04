---
id: 01M6H94RX0M2G3AE6XXH2HF2B1
created: 2026-11-03T18:01:05.18435Z
updated: 2026-11-04T07:45:34.076896Z
type: task
title: The Security Feed badge counts unread items, but doesn't say so — "28" next to 30 matches looks wrong
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1550
sprint: s6xh9g1
comments:
- id: 01M6HDYXRCY9T0MZVM7FSHC4R9
  author: Steve Vine
  at: 2026-11-03T19:25:16.428241Z
  text: |-
    Done (PR #1561, merged 2026-11-03). Not on staging yet.

    What people see now: hovering the number on the Feed tab says "28 unread" (and a screen reader reads it that way). On Affects us, the count line reads "30 items · 28 unread" when the two differ; clicking "28 unread" turns on Unread only. The unread part is only worked out on Affects us — on Everything it would be a large extra count over the whole feed.

    Verified: server test for the unread count under filters; screen tests for the count line, the one-click Unread and the tab's label. Not yet tried in a browser.

    To check on staging: in Test Company, open one of the matched items, come back, and hover the Feed tab's number.
assignee: steve
label:
- improvement
priority: low
---
Found by Steve testing sprint 102 on staging (2026-11-03), in Test Company.

## What people see

"Affects us" lists 30 items, but the badge on the feed says **28**. It reads like a miscount.

**Why:** the badge is the reader's **unread** count (`/feed/unread`): items affecting the company, less those marked not relevant, less those this person has opened. Steve had opened 2 of the 30, so 28 is right. Nothing on screen says it's an unread count.

## Fix

- The badge has a tooltip and accessible name: "28 unread".
- The feed's count line says both where they differ: "30 items · 28 unread", with the Unread filter one click away.

**Done when:** hovering the badge says "28 unread", and the Affects us count line shows both numbers when they differ.
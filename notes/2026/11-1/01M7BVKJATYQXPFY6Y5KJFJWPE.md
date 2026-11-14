---
id: 01M7BVKJATYQXPFY6Y5KJFJWPE
created: 2026-11-14T01:43:59.57866Z
updated: 2026-11-14T10:26:49.819393Z
type: task
title: 'Round-7 pre-UAT fixes: waiting proposals start with their fields ticked, Polaris can be opened from a Review card, and the edit box''s leftovers go'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1811
sprint: spsp226
comments:
- id: 01M7BX3Y34K57HS2DXAZDS7S6B
  author: Steve Vine
  at: 2026-11-14T02:10:24.484115Z
  text: |-
    Done — PR #1806 (auto-merge on). Migration 0848 backfills waiting proposals; a short ADR 0142 amendment is appended.
    - Proposals already waiting (CHK-1, CHK-3, and Moneypenny's) open with every field their sample returned ticked, except anything left out, and Approve is available. Only waiting proposals with no choice of fields are changed. What Polaris says a proposal keeps now matches the card.
    - The card also treats "no choice recorded" as all ticked, so a proposal can never be stuck with Approve off, including one reset to an original that had no choice. "Polaris's choice" appears only when Polaris actually chose.
    - The Review card has its own "Ask Polaris" button beside Previous/Next. Polaris opens over the card, the card stays open, and the status bar names the check (CHK-n).
    - Polaris's search, in Compass and over MCP, finds CHK-n. It was dropping kinds of result it had no name for. That also hid SAP entries, vulnerabilities, initiatives and secrets, which it now finds too. A test fails if the app's search ever returns a kind Polaris doesn't name.
    - Edit query: a refusal clears once a later Try it or Save works. The live check's reads editor had the same fault and is fixed too. The edit list after a reset reads "back to Polaris's original" once.
    Still open: Polaris's "try" result still lists "may be sensitive" fields. Hand edits of a live check's reads still save straight away (Steve's question).
    Unit suite, integration (including a migration upgrade test), the whole vitest suite, lint, tsc and drift checks pass.
- id: 01M7BZAGA87E4YDNSCJ963BZVB
  author: Steve Vine
  at: 2026-11-14T02:48:56.90398Z
  text: |-
    Pre-UAT: Passed. Staging build f90e6b29, as E2E Admin A, in E2E Test Company. Screenshots are in ~/compass-uat/spsp226/COM-1811/.

    1. Proposals that were already waiting: Passed. On Checks ▸ Review, CHK-3 (Changes) opens with "177 of 177 ticked" and CHK-1 (New checks) with "31 of 31 ticked". Approve is available on both. I didn't press it. Neither card has a "Polaris's choice" button. (01–03, 07)
    2. Ask Polaris from the card: Passed. The card has an "Ask Polaris" button beside Previous and Next. It opens Polaris along the bottom of the screen and the card stays open. Polaris's status bar reads "E2E Test Company · Posture ▸ Checks · CHK-3", and changes to CHK-1 when CHK-1 is open. I asked "How many fields does this one keep?" Polaris answered "CHK-3 keeps 177 fields" and "CHK-1 keeps 31 fields". Both match the cards. (04, 05, 08)
    3. Polaris's search: Passed. I asked Polaris in the app to search for "CHK-1". It found CHK-1, "Privileged role use log…", waiting for review, with a link to its card. Searching "CHK-1" over MCP for E2E Test Company also returns that one check. (06)
    4. Edit query on CHK-1: Passed.
       - I added a made-up "account" to the read and pressed Save. It was refused, with a red line under the box: "That read can't be used: A read can't say account".
       - I put the query back and pressed Try it. A fresh sample came back (92 items) and the red line was gone.
       - I pressed Reset to Polaris's original. The edit list gained one line, "14 Nov 2026, 02:48 · E2E Admin A · back to Polaris's original", read once. The earlier reset lines also read once. (09–11)
       - CHK-1 is left on Polaris's original: 31 of 31 ticked, still waiting, not approved.

    Two things for Steve to look at (neither stops the pass):
    - CHK-3 now keeps all 177 fields. That includes the email addresses, phone numbers, office locations, licences and on-premises IDs that its own "Shows" text says to leave out. Polaris points this out unprompted and offers to cut it to about 11 fields. Ticking everything is what this task asked for, because CHK-3 never recorded a choice of fields. But approving it as it stands would keep that personal data. Moneypenny's waiting proposals may look the same.
    - Resetting when nothing had been saved still adds a "back to Polaris's original" line to the edit list. That's harmless, just noise.

    Test data changed: on CHK-1, one refused Save (nothing kept) and one Reset to Polaris's original (an extra line in the edit list). Two Polaris conversations in the app. Nothing approved, discarded or connected.
assignee: steve
label:
- bug
priority: high
task_status: done
---
Found in the pre-UAT pass of sprint 116 round 7 on staging (694d62c1), 2026-11-14, in E2E Test Company.

## What people see

- **Proposals that were already waiting (from COM-1804):** they open with their fields ticked, every field except anything that was left out, the same way the live checks were started. Polaris's account of the check matches the card. Today CHK-1 shows 0 of 31 ticked and CHK-3 shows 0 of 177, so Approve is off until someone ticks fields by hand. Meanwhile Polaris says CHK-1 "keeps 31 fields, every field the read finds". Moneypenny's waiting proposals will look the same.
- **Polaris from a Review card (from COM-1805):** Polaris can be opened while a check's card is open on Checks ▸ Review, and it knows which check is on screen. Today the card covers the top bar, so Polaris has to be opened first.
- **Polaris's search (from COM-1805):** searching "CHK-1" through Polaris (and over MCP) finds the check, as the app's search does. Today it finds nothing.
- **Edit query (from COM-1806):** after a refused Save, the red refusal goes once a later Try it or Save works. Today it stays beside the new sample.
- **Edit list after a reset (from COM-1806):** it reads "Back to Polaris's original" once. Today it says "back to Polaris's original: Back to Polaris's original".

## Done when

- Waiting proposals (on staging and Moneypenny) open with their fields ticked, and Approve is available. A migration backfills them generically, with a test that seeds an older revision with a waiting proposal and upgrades.
- Polaris opens from an open Review card, and its status bar names the check.
- Polaris's search finds CHK-n.
- The refusal clears after a later success, and the reset line reads once.
- There are tests for each.

**On the chain** (migration 0848).
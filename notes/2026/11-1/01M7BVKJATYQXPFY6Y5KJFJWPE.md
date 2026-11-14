---
id: 01M7BVKJATYQXPFY6Y5KJFJWPE
created: 2026-11-14T01:43:59.57866Z
updated: 2026-11-14T01:44:04.371151Z
type: task
title: 'Round-7 pre-UAT fixes: waiting proposals start with their fields ticked, Polaris can be opened from a Review card, and the edit box''s leftovers go'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1811
sprint: spsp226
assignee: steve
label:
- bug
priority: high
task_status: active
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
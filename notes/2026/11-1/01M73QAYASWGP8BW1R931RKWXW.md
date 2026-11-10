---
id: 01M73QAYASWGP8BW1R931RKWXW
created: 2026-11-10T21:55:27.19356Z
updated: 2026-11-10T21:58:18.830187Z
type: task
title: 'Chat tools for feeds: an assistant lists feeds and their runs, previews one, sets one up or fixes its mapping, and runs it now — approving a feed and deciding a held run stay on screen'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1703
sprint: sep79bz
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Part of ADR 0145 (COM-1695). It follows the split that ADR 0142's COM-1659 amendment set for services: an assistant can build and fix settings, and the decisions that change registers stay a person's own act on screen.

**Chain:** on the chain — API (new tools; pinned tool counts change)

## What the person can ask

- "What feeds does GitHub have, and what did the last run do?" lists feeds, their state, last run and counts, and any held run's would-do summary.
- "Preview the Dependabot feed against the Moneypenny account" shows what it would create, update and close, saving nothing.
- "Set up a feed from GitHub's Dependabot alerts into Vulnerabilities" creates the feed in **Waiting for approval**, as that person via Polaris (ADR 0109), and says it's waiting for someone with manage vulnerabilities to approve it on screen.
- "The feed's severity mapping is wrong, high should be High not Medium" changes the mapping. A changed feed goes back to Waiting for approval (my call: a mapping change changes what lands in a register).
- "Run the Dependabot feed now" (the area's right).

## Not by chat (my calls, for Steve to overturn)

- **Approving a feed, and Apply or Discard on a held run.** They decide what goes into a register, so they're done on screen.
- **Deleting a feed.**

## Done when

- The tools exist under the Posture area (or the area of the feed: Vulnerabilities, Inventory or Secrets) with the rights above, the right `always_ask` markings for changes, and Activity entries as the person via Polaris.
- Tested end to end against real Postgres. The pinned tool-count and tool-name tests are updated. `/api/mcp/<area>` lists the tools where ADR 0144 says they belong.
- No tool returns a key, a username or a key's hint.
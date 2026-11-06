---
id: 01M6R9KEZH2SNFZ247GG6SZ8E5
created: 2026-11-06T11:23:47.569595Z
updated: 2026-11-06T11:24:01.324144Z
type: task
title: When a check's reads change, the capture from an account it no longer reads still counts towards its rule and shows on its card
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1619
sprint: s1jcke1
assignee: steve
label:
- bug
priority: medium
task_status: active
---
Found in Claude's pre-UAT pass on staging, 6 Nov 2026. Sprint "Evidence Collection - Integrations", affects COM-1604 and COM-1606.

## What happens

- On ACC.13 the check's reads were changed with Advanced ▸ Reads, from Microsoft 365 role assignments to a GitHub read.
- Afterwards the rule judged "All 218 role assignments": that's 210 from the old Microsoft 365 capture plus 8 from GitHub.
- The card still listed the Microsoft 365 capture as one of the check's latest.
- The old capture should stay in the Evidence register, but it's no longer what the check collects.

## Fix

- The newest capture per account counts only for the sources in the check's current reads: in judging, on the card, on the Checks page and in the audit pack's "latest" facts.
- Older captures stay in the register as they are.

**Done when:** tests cover a check whose reads drop an account: its rule judges only the remaining accounts' captures, and the card lists only those.

**Chain:** independent (no migration or API change).
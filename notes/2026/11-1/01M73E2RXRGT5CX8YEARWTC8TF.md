---
id: 01M73E2RXRGT5CX8YEARWTC8TF
created: 2026-11-10T19:13:42.3284Z
updated: 2026-11-10T22:38:08.313522Z
type: task
title: Aikido read times out — no issues ever reach Vulnerabilities
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1693
sprint: sep79bz
comments:
- id: 01M73SCCK14KZ1YV7P9G6J6VDV
  author: Steve Vine
  at: 2026-11-10T22:31:11.712881Z
  text: 'Moved into sprint sep79bz ("Collection feeds - Vulnerabilities, Inventory, Secrets") by Steve, 2026-11-10. Fix the coded Aikido reader now, so COM-1715 (Aikido rebuilt as configuration, sprint sj4f1kj) has a working reader to compare against. Chain: independent (backend only, no migration or API change).'
assignee: steve
label:
- bug
priority: medium
task_status: active
---
Raised by Steve while testing (2026-11-10): "The Aikido integration seems to be failing."

**What's happening (staging, 2026-11-10)**
- The Aikido tile is healthy: sign-in works and Test answers (workspace Moneypenny-Development).
- Its list is fine too: 130 repositories, 20 containers and 20 clouds, all assigned to a company.
- But every read fails. Every one of the 170 shows "Compass couldn't reach Aikido: The read operation timed out", none has ever been read, and no Aikido read appears under Vulnerabilities for any company.
- Worker log, 18:10 UTC run: the list calls answer in ~0.1 s each, then the issue export (`GET /api/public/v1/issues/export?filter_status=all`) is cut off at exactly 20 s, Compass's timeout for every Aikido call.

**Cause:** the issues come from one call that exports *every* issue in the workspace, open, ignored, snoozed and solved, so Compass can spot closures. For a workspace this size Aikido takes longer than the 20 s Compass allows.

**Done when**
- On staging, Read now on the Aikido tile completes, and each company's Vulnerabilities shows an Aikido read with what it found (new / already in the register / closed / Unmatched).
- The scheduled six-hourly read completes as well.
- A slow Aikido still ends in a clear message on the tile's repositories, not a silent zero.

**Notes for the build**
- `core/aikido.py` `list_issues` and the shared `_TIMEOUT = 20.0`. Give the export its own, much longer read timeout (minutes, not seconds), keeping 20 s for sign-in and the health check. Also check whether Aikido's export can be narrowed or paged (e.g. by status or updated-since), so a growing workspace doesn't creep back over the limit.
- A timeout is an `httpx.HTTPError`, so it isn't retried. Decide whether one retry is worth it.
- `read_aikido` logs "succeeded … : 0" on this failure. Consider recording it as a failed read that people can see.
- Worth checking while in there: containers and clouds both came back at exactly 20. That's also Test's "first page" size, so make sure `per_page=200` is honoured on those two lists (repositories returned 130, so it works there).
- Independent: backend only, no migration or API change.
---
id: 01M6H57HDJNEMDQXWCEX6QHFAG
created: 2026-11-03T16:52:41.522241Z
updated: 2026-11-03T16:53:03.65818Z
type: task
title: The feed's search box only matches whole words, so the count jumps about while you type
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1541
sprint: s6xh9g1
assignee: steve
label:
- bug
priority: medium
task_status: todo
---
Found by Steve testing sprint 102 on staging (2026-11-03).

## What people see

On Security Feed ▸ Feed, the count changes erratically as you type into the search box, looking for CVE-2026-109618:

| Typed | Items shown |
|---|---|
| (empty) | 103,855 |
| `C` | 1,113 |
| `CVE` | 103,000 |
| `CVE-2` | none |
| `CVE-2026` | 82,981 |
| `CVE-2026-1` | none |

Expected: the list narrows steadily as you type, and part of an id (`CVE-2026-10`) finds the ids that start with it.

**Cause (technical):** `_text_clauses` in `api/v1/security_feed_feed.py` uses Postgres full-text search (`websearch_to_tsquery('english', q)`). That matches whole words only, with no prefixes. `C` matches the word "C" (the language) on 1,113 items. `CVE` matches the word on almost every item. `CVE-2` and `CVE-2026-1` are split into tokens that no item has. The only id match is an exact `FeedItem.key == cve_key(q)`.

## To decide when fixing

- Prefix-match the last word typed (e.g. `to_tsquery` with `:*`), and/or match an id that starts with what's typed (`key ILIKE 'CVE-2026-10%'`, and source refs too). This needs an index that can do prefix matching on 100k+ items.
- Don't search on one character (wait for 2 or 3).

**Done when:** typing a CVE id character by character narrows the list steadily and never drops to "no matching results" part-way, and typing a word still finds items with that word.

Related: the task about the search jumping to the wrong item.
---
id: 01M6H57HDJNEMDQXWCEX6QHFAG
created: 2026-11-03T16:52:41.522241Z
updated: 2026-11-04T07:46:09.229082Z
type: task
title: The feed's search box only matches whole words, so the count jumps about while you type
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1541
sprint: s6xh9g1
comments:
- id: 01M6HAPJ5A4HCG88CPXPDAZVKE
  author: Steve Vine
  at: 2026-11-03T18:28:16.682588Z
  text: |-
    Done (PR #1555, merged 2026-11-03 18:26 GMT; migration 0765). Not on staging yet — goes with the rest of the sprint's fixes.

    What people see now: on Security Feed ▸ Feed the count only ever narrows as you type. One character searches nothing yet. The last word is matched as the start of a word ("vulnerab" finds "vulnerability"), and an id typed in part finds every item whose id starts with it — "CVE-2026-10" finds CVE-2026-10…, "FG-IR-26" finds Fortinet's 2026 advisories (the source's own reference counts too). Typing a word still finds items with that word.

    Verified: an integration test types CVE-2026-6001 one character at a time and checks the totals only go down and never reach zero; part ids, a source reference, word starts and stems ("issue" is stored as "issu") all checked. Two new indexes keep it quick over 100k items.

    To check on staging: type CVE-2026-109618 slowly — the count should fall at each step and never show "no matching results".
assignee: steve
label:
- bug
priority: medium
task_status: done
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

Related: COM-1542 (the search jumps to the wrong item, and the trail leads back to it).
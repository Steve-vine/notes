---
id: 01M73QC5JFEQX7MZGKRC9RF4N6
created: 2026-11-10T21:56:07.3754Z
updated: 2026-11-11T11:49:43.371761Z
type: task
title: 'Follow-on reads: read a list, then each item at an address built from its fields, nested up to three deep, with repeated lookups read once, a cap per run, and a declared answer to "no permission" on one item'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1706
sprint: sj4f1kj
blocked_by:
- 01M73QBT1QP9E6549CQ1C4XX5Y
- 01M73Q8M80365XPSJR7G8BG302
comments:
- id: 01M745VR1JN46PG3N05MXWTFBR
  author: Steve Vine
  at: 2026-11-11T02:09:17.874438Z
  text: |-
    Merged to main in #1705 (squash 93c6e03c).

    What it does: a feed's read can read a list, then read each item at an address built from that item's fields (e.g. /repos/{full_name:raw}/keys), up to three levels deep. Each child carries its parent, so the mapping can use parent fields. An address is read once per run. There's a cap per run (2,000 by default, up to 20,000). When an item answers "no permission", the read either stops or skips that item, as the read declares. A skipped item leaves its records as they were: that run closes nothing by "missing".

    On screen: the feed editor has "Then for each item, read" and "If an item says 'no permission'" on each read.

    Tests: test_collection_follow.py, test_feed_follow.py (integration), FeedsTab test.
assignee: steve
label:
- feature
priority: high
task_status: done
---
ADR 0146 §1 (COM-1705). Many APIs only list some things one level down, such as per repository or per host. Without this, a service like that can't be described.

**Chain:** on the chain — API (the read definition's schema grows; checks and feeds both use it)

## What the person sees

- In a read (in a check or a feed), **Then for each item, read…** with an address that uses the item's fields, e.g. `/repos/{full_name}/keys` or `/scans/{scan_id}/hosts/{host_id}`. Each value is URL-encoded, and a field that's missing is an error naming the field. It can nest up to three levels deep.
- Each follow-on read has its own paging, items path and limits. The results are joined to their parent: each child item carries the parent's fields under a declared name, so a feed can map `parent.full_name` as the target.
- **Repeated lookups are read once a run.** If ten hosts all point at plugin 19506, its details are read once.
- **A cap per run** on follow-on reads: 2,000 by default, up to 20,000 (my calls). Going past it is Broken, with "narrow the read", and nothing is saved, as for any incomplete read.
- **"No permission" on one item:** the read declares either *skip it and leave its records as they were* (nothing under it closes or goes) or *break the read*. Breaking is the default (my call).
- Preview and Test show the first item's follow-on result, so a person can see the join worked.

## Done when

- Tested against a fake service: one level, three levels, de-duplication, the cap, a 403 on one item under each setting, a missing field, URL-encoding, paging inside a follow-on read, and complete-or-nothing across the whole tree.
- The public-address rule and pinning (ADR 0142 §8) hold for every follow-on address, and a follow-on address can't change host.
- Checks (evidence captures) can use it too. A capture of a follow-on read shows parent and child together.
- No service name in code (COM-1696).

## Notes

- `core/collection/client.py` `read` and `_paged`. Build the tree breadth-first and carry the parent context. Throttling retries (Retry-After) apply to each request.
- Mind g5's uplink (memory: six concurrent runs saturate it). Keep follow-on reads sequential per account, or two at a time.
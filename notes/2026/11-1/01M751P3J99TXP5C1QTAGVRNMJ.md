---
id: 01M751P3J99TXP5C1QTAGVRNMJ
created: 2026-11-11T10:15:33.193347Z
updated: 2026-11-11T12:29:28.777301Z
type: task
title: A locked or refusing Nessus shows as failing, a broken feed reaches its owner, and a running feed says so
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1723
sprint: sj4f1kj
assignee: steve
label:
- bug
priority: high
task_status: active
---
Found on staging 2026-11-11 while testing Nessus as configuration (COM-1714). After a restart, Nessus waited for its encryption password and refused to list scans ("412: API is not available") from about 2 November. Nobody noticed for nine days:
- The coded Nessus tile stayed green. Its 15-minute check only asks for Nessus's version (/server/properties), which answers while it's locked. When the check passes, it keeps the last Test's message, so it still said "The key can see 69 scans".
- The tile last saw its scans on 2 November and last imported findings on 28 October.

Also found the same day (COM-1713): a feed approved while its last run had failed kept showing **Broken** for the minute or so its new run took, so it looked broken again when it was working.

**Chain:** independent (whether a feed is running may need to be shown by the API: if so, this joins the chain)

## What the person sees
- **The Nessus tile's check also lists scans.** If Nessus refuses, the tile turns to needing attention and says so: "Nessus is answering but refusing to list scans (412: API is not available). After a restart it may be waiting for its encryption password: unlock it in Nessus." It recovers by itself at the next check after unlocking.
- **The tile's message is always the latest check's**, never a stale one from an earlier Test.
- **A broken Collection feed reaches someone:** a feed whose run failed (e.g. the configured Nessus service refusing) puts an action on its integration owner's Actions, like a failing account's "Fix sign-in". It clears when a run succeeds.
- **A running feed says so.** While a run is under way (after approval, Run now or on its schedule), the feed shows **Running…** with when it started, not its last result. The page picks up the result when the run finishes, without a reload. A run stuck past its limits shows as failed, not running forever.
- Optional, for Steve: add "unlock Nessus after a restart" to the scanner server's restart runbook.

## Done when
- Tested with a fake Nessus that answers /server/properties but refuses /scans with 412: the tile shows the problem in those words, then goes green when /scans answers.
- A Collection feed that fails its run raises one action for the integration's owner, cleared by the next good run. Tested.
- A feed with a run under way shows Running… on its tile and Feeds tab, then its result. Tested, including a run that never finishes.
- No Nessus-specific logic in the Collection code (COM-1696). The encryption-password hint belongs to the coded tile only.
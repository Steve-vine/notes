---
id: 01M751P3J99TXP5C1QTAGVRNMJ
created: 2026-11-11T10:15:33.193347Z
updated: 2026-11-11T10:15:35.086714Z
type: task
title: 'A locked or refusing Nessus shows as failing: the tile''s check lists scans, says why it can''t, and a broken feed reaches its owner'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1723
sprint: sj4f1kj
assignee: steve
label:
- bug
priority: high
task_status: todo
---
Found on staging 2026-11-11 while testing Nessus as configuration (COM-1714). After a restart, Nessus waited for its encryption password and refused to list scans ("412: API is not available") from about 2 November. Nobody noticed for nine days:
- The coded Nessus tile stayed green. Its 15-minute check only asks for Nessus's version (/server/properties), which answers while it's locked. When the check passes, it keeps the last Test's message, so it still said "The key can see 69 scans".
- The tile last saw its scans on 2 November and last imported findings on 28 October.

**Chain:** independent

## What the person sees
- **The Nessus tile's check also lists scans.** If Nessus refuses, the tile turns to needing attention and says so: "Nessus is answering but refusing to list scans (412: API is not available). After a restart it may be waiting for its encryption password: unlock it in Nessus." It recovers by itself at the next check after unlocking.
- **The tile's message is always the latest check's**, never a stale one from an earlier Test.
- **A broken Collection feed reaches someone:** a feed whose run failed (e.g. the configured Nessus service refusing) puts an action on its integration owner's Actions, like a failing account's "Fix sign-in". It clears when a run succeeds.
- Optional, for Steve: add "unlock Nessus after a restart" to the scanner server's restart runbook.

## Done when
- Tested with a fake Nessus that answers /server/properties but refuses /scans with 412: the tile shows the problem in those words, then goes green when /scans answers.
- A Collection feed that fails its run raises one action for the integration's owner, cleared by the next good run. Tested.
- No Nessus-specific logic in the Collection code (COM-1696). The encryption-password hint belongs to the coded tile only.
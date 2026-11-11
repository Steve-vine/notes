---
id: 01M751P3J99TXP5C1QTAGVRNMJ
created: 2026-11-11T10:15:33.193347Z
updated: 2026-11-11T13:31:33.727697Z
type: task
title: A locked or refusing Nessus shows as failing, a broken feed reaches its owner, and a running feed says so
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1723
sprint: sj4f1kj
comments:
- id: 01M75CWY1G0CXS30HM7GWKYZKM
  author: Steve Vine
  at: 2026-11-11T13:31:31.247992Z
  text: |-
    Built and merged to main (PR #1724, 2026-11-11). On the chain: a feed can now say it's running, and Run now says when a run is already under way. No migration. Goes to staging with the sprint.

    What changed:
    - **The Nessus tile's check now also lists scans.** It still runs every 15 minutes.
      - If Nessus refuses, the tile needs attention and says: "Nessus is answering but refusing to list scans (412: API is not available). After a restart it may be waiting for its encryption password: unlock it in Nessus."
      - Test says the same. The tile recovers by itself at the next check after Nessus is unlocked.
      - The tile always shows what the latest check found ("Last check found"), never an older Test's message.
    - **A broken feed reaches someone.** A feed whose last run failed, or never finished, puts one action on Actions: "Collection feed · Repair", titled "<service> · <feed> failed: <why>".
      - It goes to the integration's owner, or to whoever manages integrations if the owner has left.
      - Only a good run clears it. A switched-off feed, or one waiting for approval, raises nothing.
    - **A running feed says so.**
      - A run is recorded the moment it's asked for (approval, Run now, applying a held run, or its schedule). The feed shows a blue "Running…" badge with when it started, and Run now is disabled meanwhile.
      - The Feeds tab picks up the result without a reload.
      - A run stops after an hour. One still "running" after 1 hour 10 minutes shows as failed, never running forever.
      - Pressing Run now twice starts one run, and a scheduled run doesn't start on top of one already running.
    - **Small wording change for Steve:** the healthy feed state is now "Live" rather than "Running", so it can't be confused with "Running…". Easy to change back if you'd rather.
    - No Nessus-specific logic in the Collection code: the encryption-password hint is in the coded Nessus tile only.

    Tests: a fake Nessus answering its version but refusing scans with 412, then unlocked; the tile showing the latest check's words; Running… after approval and after Run now; a run that never finishes; one Repair action until a good run; Feeds tab screen tests (Running… then the result, Run now waiting).

    Not done: the optional runbook note ("unlock Nessus after a restart") is Steve's, if wanted.
assignee: steve
label:
- bug
priority: high
task_status: review
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
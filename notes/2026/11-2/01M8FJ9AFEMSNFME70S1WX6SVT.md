---
id: 01M8FJ9AFEMSNFME70S1WX6SVT
created: 2026-11-27T22:33:46.222329Z
updated: 2026-11-28T08:40:18.169938Z
type: task
title: 'Patch level is judged by missing security fixes: a server is Behind when it''s missing a fix released more than the company''s days ago; the update-age check uses it, with last-update age as the fallback'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2217
sprint: s51yxk5
blocked_by:
- 01M8FJ8W5Y57VY8Y254C4R2F4J
- 01M8FAVGBYEAE17CNZBWV1KZEE
comments:
- id: 01M8GMZWNB7BRMS4WHCD8891Q2
  author: Steve Vine
  at: 2026-11-28T08:40:17.32375Z
  text: |-
    Built: PR #2229, merged to main (not on staging yet; it goes with the sprints' deploy).

    What's there:
    - A server's patch level is judged by the security fixes it lacks. It's Behind when it's missing a fix released more than the company's number of days ago: 14 by default, or 7 for a known-exploited fix. The card says "Missing 3 security fixes; the oldest was released 41 days ago (KB5044284). This company installs them within 14 days (7 if exploited)."
    - A server missing nothing is Up to date, however long ago its last update was.
    - Where its fixes can't be told exactly (build not known, or a release the distribution data doesn't cover), it's judged by the age of its last update as before, and says so: "Judged by last update: build not known."
    - The server agent card's settings are now in one row: "Install security fixes within [14] days of release", "Known-exploited fixes within [7] days", and "Otherwise, expect an update every [35] days" (the old setting, now the fallback). Existing companies keep their 35.
    - The Behind column and the "Behind on updates only" switch use the new judgement.
    - The built-in check keeps its number and is renamed "Security fixes are installed within the company's days". It's judged the same way on Windows and Linux, and its result says what it was judged by.
    - Polaris reports the company's fix days.

    One small difference: the task asked for the rename to be recorded in the check's activity. Built-in check names come from code rather than being stored, so the new name simply shows everywhere at once. A company that gave the check its own wording keeps it.

    For you to look at: on staging, the Ubuntu test server should read Behind once its held-back package's fixes are past 14 days.
assignee: steve
label:
- improvement
priority: medium
task_status: review
---
**On the chain** (settings, checks, API). ADR 0188 (revises ADR 0187 §7). After COM-2216.

## What people see
- A server's **Patch level** reads **Behind** when it's **missing a security fix released more than the company's number of days ago** ("Missing 3 security fixes; the oldest was released 41 days ago (KB5044284)"), and **Up to date** otherwise, even if its last update was a while ago but nothing has been released since.
- The company setting becomes **Install security fixes within [14] days of release** (default 14; the old "expect an update every 35 days" moves to the fallback below). A separate, shorter number for **known-exploited** fixes (default 7).
- **Fallback:** a server whose fixes can't be told exactly (build not known, a release the distribution data doesn't cover) is still judged by the age of its last update, as in ADR 0187 §7, and says so ("judged by last update: build not known").
- The built-in check **"An update has been installed within the company's days"** (COM-2207 #12) becomes **"Security fixes are installed within the company's days"**, judged as above per server, Windows and Linux; its evidence wording follows.
- The **Behind** filter in Inventory uses the new judgement.

## Notes (technical)
- Uses the per-server missing-fix results from COM-2213 (Windows) and COM-2215 (Linux) with each fix's release date (Microsoft release date; OSV `published`/advisory date for the distribution fix).
- Rename the check without changing its CHB number; record the change in the check's activity. Tests pinning the check's name/wording need updating.
- Settings migrate: existing "update age" value becomes the fallback value.

**Done when:** on staging, the test-rig server with the older package reads Behind with the oldest missing fix's age once the company's days are set below it, Up to date after the upgrade; the check's result follows; a server with no exact data falls back to update age and says so.
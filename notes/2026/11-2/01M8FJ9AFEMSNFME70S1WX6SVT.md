---
id: 01M8FJ9AFEMSNFME70S1WX6SVT
created: 2026-11-27T22:33:46.222329Z
updated: 2026-11-27T22:34:56.823837Z
type: task
title: 'Patch level is judged by missing security fixes: a server is Behind when it''s missing a fix released more than the company''s days ago; the update-age check uses it, with last-update age as the fallback'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2217
sprint: s51yxk5
assignee: steve
label:
- improvement
priority: medium
task_status: todo
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
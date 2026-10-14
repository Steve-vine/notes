---
id: 01M4XZK9T9G34WGBFA78Q5ZE2Z
created: 2026-10-14T19:52:59.465445Z
updated: 2026-10-14T19:53:03.525421Z
type: task
title: The language runtimes that functions and web apps run on are found — Python 3.9 on Lambda, .NET 6 on App Service — and appear in Discovered ▸ Software
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 965
sprint: sbkelqe
blocked_by:
- 01M4XZGT1G67Z1HYZRG8MQ07BS
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Part of sprint 67, Inventory discovery - Software (ADR in COM-959). Runtimes go out of support like anything else. When the cloud retires one, functions on it stop receiving fixes, and eventually can't be updated.

## What people see

- **Discovered ▸ Software lists the runtimes in use** on functions and web apps under technology assets: "Python 3.9 · on 5 technology assets", "Node.js 18 · on 2". Opening a row shows which function or app, and where.
- A runtime is one row whichever cloud it runs in. The support dates are the language's own (COM-962). Where a cloud retires a runtime earlier than the language does, the cloud's date is shown when the row is opened. Lambda publishes its own dates; App Service and Google do not, in a form Compass can read.
- **Container images are not runtimes** and are not listed. What runs inside an image can't be seen without looking inside it, which is out of scope.

## Notes (technical)

- Already read: Lambda `runtime` (`aws/lambda_.py`, e.g. `python3.9`, `nodejs18.x`), App Service `runtime` (`azure/web.py`), Cloud Run functions `buildConfig.runtime` (`gcp/run.py`), and App Engine `runtime` (`gcp/appengine.py`). Normalise to `runtime:<language>:<version>`.
- **Known gap from the first real Azure read:** runtime is Unknown on every Windows web app (46 of 46). Windows apps carry the stack in `siteConfig.netFrameworkVersion` / `javaVersion` / `phpVersion` / `metadata` `CURRENT_STACK`, not in `linuxFxVersion`. Fix this here, test it against Steve's subscription, and say how many remain Unknown.
- Lambda's own deprecation dates: endoflife.date's `aws-lambda` product carries them per runtime, so use it in COM-962's mapping.

**Done when:** on staging, Lambda functions and Azure web apps under technology assets show their runtimes in Discovered ▸ Software, and Windows web apps no longer read Unknown (or the task says why some still do).
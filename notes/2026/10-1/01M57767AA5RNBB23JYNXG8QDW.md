---
id: 01M57767AA5RNBB23JYNXG8QDW
created: 2026-10-18T09:58:49.418248Z
updated: 2026-10-19T14:13:05.583411Z
type: task
title: Python that comes with a server's Linux distribution takes the distribution's support dates, not python.org's
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1085
sprint: sbkelqe
blocked_by:
- 01M57740W4X2DT7DAPJ961N4TT
assignee: steve
label:
- bug
priority: medium
task_status: active
---
Part of sprint 67, Inventory discovery - Software (ADR 0114, follow-up to COM-962/966). Raised after the first real read on staging, 2026-10-18.

## Why

On the Staging AWS account, the 9 Amazon Linux 2023 servers report Python 3.9. That is the operating system's own copy. Compass gives it python.org's dates, so standard support ended 17 May 2022 and extended support on 31 October 2025, and it looks out of support on 9 servers. It isn't: Amazon patches that Python for as long as Amazon Linux 2023 is supported (to 30 June 2029). Ubuntu 24.04's Python 3.12 has the same problem, less visibly: python.org ends it in October 2028, but Canonical supports it until May 2029.

## What people see

- **Python that a server's Linux distribution supplies shows as its own row, named for where it came from:** "Python 3.9 (Amazon Linux 2023)", "Python 3.12 (Ubuntu 24.04)". Its support dates are the distribution's, the same dates its operating-system row shows.
- **Python someone installed separately** (from python.org, a vendor, a container image) keeps python.org's dates under plain "Python 3.9". The two never share a row, so one set of dates never stands in for the other.
- **When it's added to the Software register,** the entry is filled with the distribution's dates and follows them, as other discovered dates do. The register entry names the distribution as the source.
- **Nothing else changes:** Lambda, Azure web app and other cloud-run runtimes keep the dates they have today, because the cloud supplies those runtimes, not a Linux distribution.

## Notes (technical)

- Uses the same "is this a distribution package?" test as COM-1084 (publisher or release suffix names the server's distribution). Hence blocked by it.
- In `core/discovery/installed.py`, a distribution-supplied Python gets a key tied to the OS, e.g. the runtime key with the server's OS key as its `part` (or a distinct key shape). Pick whichever keeps grouping by "same Python from the same distribution release" and passes the key pattern. Say which in the PR.
- `core/lifecycle.py`: dates for such a row come from the OS product/cycle (`amazon-linux` 2023, `ubuntu` 24.04, `rhel` 9, …), via the same `catalogue_dates` path, with `support_source` naming the distribution.
- Worth checking at the same time whether other runtimes are bundled the same way: Node.js and Java (OpenJDK) on Ubuntu/RHEL, and Perl. Apply the same rule if any are keyed as runtimes today. RHEL Application Streams have their own lifecycles that differ from the OS's, so for RHEL, use the OS dates only for the default stream, or leave RHEL out and say so.
- Tests: an Amazon Linux 2023 and an Ubuntu 24.04 package list where the bundled Python takes the OS dates, a separately installed Python on the same server keeps python.org's, and a Lambda Python 3.9 is unchanged.

**Done when:** on staging, the Amazon Linux 2023 servers' Python 3.9 shows support to 30 June 2029 under its own row, and nothing on the Staging account shows a bundled Python as out of support.
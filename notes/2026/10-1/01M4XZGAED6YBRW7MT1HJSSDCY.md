---
id: 01M4XZGAED6YBRW7MT1HJSSDCY
created: 2026-10-14T19:51:21.805929Z
updated: 2026-10-17T08:10:08.41685Z
type: task
title: 'ADR: discovery finds the software running on technology assets — a person adds it to the Software register or discards it, and support dates are filled for them'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 959
sprint: sbkelqe
assignee: steve
label:
- brief
priority: high
task_status: active
---
Sprint 67, Inventory discovery - Software. Scoped with Steve on 2026-10-14. This record is the first task, and the rest wait for it.

Today only managed database engines are found (ADR 0099 §11, COM-889/921/929). They show as a blue "Found by discovery" banner on the Software tab. This sprint makes software discovery general: it finds what runs on every technology asset that discovery can see into, lists it once with a count, lets a person add it or discard it, and fills in the support dates.

## What Steve decided (2026-10-14)

- **What is discovered:** database engine versions (already found), Kubernetes versions, the operating systems of cloud servers, app runtimes, and the full list of installed software on servers wherever the cloud's own management agent reports one. Operating systems of on-prem servers, and what those servers are known to run, come from sprint 66, Inventory discovery - On-prem (COM-936, COM-937).
- **Only technology assets are looked at:** software is found on resources that sit beneath a technology asset, as it is today.
- **Where it lives:** the existing **Discovered** tab gets two views, **Resources** (today's list) and **Software**. The banner on the Software tab goes.
- **What gets listed:** everything a server reports **except updates, patches and hotfixes**. A discard is remembered for that software, on every asset.
- **One row per piece of software, with a count.** This applies on both the Discovered ▸ Software view and the Software tab. Opening a row shows which technology assets it is on.
- **Support dates are filled in** when software is added to the register. This **reverses** COM-889's call that discovered dates are shown beside the typed ones and never written into them.

## What the record has to settle

- **One row = product + major version** (Windows Server 2019, PostgreSQL 15, Kubernetes 1.29, Python 3.9, 7-Zip 23). That is the grain support dates are published at. Opening the row shows the exact version on each asset.
- **Where the support dates come from:** a public lifecycle catalogue (endoflife.date), plus the providers' own dates where they publish them (AWS publishes them for RDS and EKS). Claude's call: the worker refreshes the catalogue daily, and each release ships a snapshot for when the catalogue can't be reached. Software the catalogue does not know gets blank dates for a person to fill in.
- **Dates after adding:** a date nobody has edited follows the catalogue. A date someone typed stands, and the catalogue's date shows beside it.
- **What the ADR 0099 ruled-out list means here:** nothing is scanned, installed or logged into. Full installed-software lists come only from the agents the clouds already run (AWS Systems Manager, Azure Monitor / Change Tracking, Google VM Manager), read through the connection Compass already has. A server without one shows its operating system only.
- **Linux reports every package:** typically 500–1,500 per server. Grouping, search, a "known support dates only" filter and discarding many at once are how the view stays usable.
- **Later, not in these tasks:** a finding that a technology asset *runs software out of support* (COM-936 adds one for on-prem Windows only); licence counting from discovered installs.

## Notes (technical)

- Today's model is derived from facts with nothing stored per install (`core/discovery/software.py`, `discovery_key` on `software_assets`, `software_discovery_dismissals`). That works for one engine per resource, but not for hundreds of packages per server. Expect a table of software found per discovered resource, replaced on each read. The record should say whether the derived-from-facts path for engines moves onto it.
- Keys become provider-neutral where support is too (`os:windows-server:2019`, `k8s:eks:1.29`, `runtime:python:3.9`, `app:<publisher>:<name>:<major>`). Engine keys keep the provider (`aws.rds:postgres:15`), because each provider supports an engine for a different length of time.
- COM-936 builds a small Windows Server support table in code. This sprint's catalogue takes it over.
- Next free ADR number at the time of writing (0106 is the latest; COM-932, the on-prem ADR, may take 0107 first).

**Done when:** the record is accepted and the tasks below match it.
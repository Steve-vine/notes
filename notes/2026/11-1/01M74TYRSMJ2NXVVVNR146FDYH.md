---
id: 01M74TYRSMJ2NXVVVNR146FDYH
created: 2026-11-11T08:17:57.044792Z
updated: 2026-11-11T08:18:01.350609Z
type: task
title: 'An approved internal address the website can''t reach: save, Test and Preview of a Collection service go through the background worker, which can'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1720
sprint: sj4f1kj
assignee: steve
label:
- bug
priority: high
task_status: todo
---
Found while setting up Nessus as configuration (COM-1714) on staging, 2026-11-11.

Nessus (nessus.moneypenny.local:8834) is reachable only through the Twingate connector, which runs beside the background worker. The worker resolves it (to 100.97.65.140), and the coded Nessus tile reads it from there. The website's own API pod has no connector: it can't even resolve the name. Saving a Collection service, an account's Test and a feed's Preview all run in the API pod. So for Nessus:
- saving the service fails ("Compass couldn't find nessus.moneypenny.local"), even once its address is approved;
- Test and Preview would fail the same way;
- only scheduled feed runs, on the worker, could reach it.

**Chain:** independent (no migration). The API's answers stay the same; they may just take a moment longer.

## What the person sees (recommended)
- Saving a service at an approved internal address doesn't need the website to reach it. The address rules (approved, never metadata, loopback or Compass's own networks) are still checked on every read.
- **Test** and **Preview** run on the background worker's quick lane, as the coded Nessus tile's test already does. The screen waits a moment and shows the same result.

## The alternative (not recommended)
Give the website's pod its own Twingate connector. It's simpler, but it puts the internal network within reach of the public-facing pod. Keeping that reach in the worker alone is the smaller door.

## Done when
- With an approved internal address reachable only from the worker, the service saves, its account's Test answers and a feed's Preview works (tested with DNS that answers only in the worker).
- The Nessus feed from COM-1714 can then be added (spec below).

## The Nessus feed to add once this lands (COM-1714)
- Service "Nessus": base https://nessus.moneypenny.local:8834, sign-in "API key in a header" with header X-ApiKeys, no paging, test read /server/status. CA certificate: the one on the coded Nessus tile (a public certificate, copyable).
- Feed "Findings" into Vulnerabilities, closing "missing" with scope target ← hostname:
  - read /scans, items "scans";
  - then /scans/{id}, items "history", as "scan", choosing status in [completed] and the newest by last_modification_date;
  - then /scans/{scan.id}?history_id={history_id}, items "hosts", as "run";
  - then /scans/{run.scan.id}/hosts/{host_id}?history_id={run.history_id}, items "vulnerabilities", as "host".
- Mapping: target ← host.hostname, target_kind host, issue ← plugin_id, title ← plugin_name, severity ← severity (4 critical, 3 high, 2 medium, 1 low, 0 informational).
- Parts: kind "scan", id ← host.run.scan.id, name ← host.run.scan.name.
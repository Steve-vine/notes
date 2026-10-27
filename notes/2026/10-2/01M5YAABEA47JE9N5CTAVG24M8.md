---
id: 01M5YAABEA47JE9N5CTAVG24M8
created: 2026-10-27T09:16:02.378569Z
updated: 2026-10-27T09:19:46.558703Z
type: task
title: Nessus feeds the register — each scan is given to a company on the Nessus tile, finished scans are pulled as they complete, and a .nessus export can always be uploaded instead
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1376
sprint: ssp4evc
blocked_by:
- 01M5YA9T7YGZN49RZ4X73Y344A
- 01M5Y9FKJYXKVFE847JCK8FEEX
assignee: steve
label:
- feature
priority: high
task_status: todo
---
Sprint 92, Vulnerabilities - Scanner sources (ADR in COM-1374). Builds on COM-1375 and COM-1359.

## What people see

- **Integrations ▸ Nessus ▸ Configure ▸ Scans:**
  - every scan the key can see, with its targets summary and last finished run;
  - each scan gets a **company** (or "Don't read");
  - newly appearing scans start as "Not assigned" and turn the tile to Needs attention.
- **Features ▸ Vulnerabilities**, now switchable:
  - Compass checks hourly for newly finished runs of assigned scans and reads each one once;
  - **Read now** per scan.
- **Vulnerabilities ▸ Register ▸ Import ▸ Nessus file:**
  - upload a `.nessus` export and choose the company;
  - this works whether or not the pull does: from a laptop scan, or if the API won't allow it.
  - It shows the hosts and findings it read, how many became new vulnerabilities, matched existing ones or went to Unmatched, before and after confirming.
- **What each finding brings in:**
  - the plugin's name as the title;
  - severity, CVSS score and vector;
  - CVEs;
  - synopsis and description;
  - solution as the recommendation;
  - plugin output, trimmed to 4,000 characters;
  - host, port and protocol as where it is;
  - first seen (the scan date, or Nessus's first-found date where it gives one).
- **Closing:**
  - a newer finished run of the same scan that covers a host and doesn't report a finding closes that sighting;
  - a host missing from the run closes nothing (ADR amendment);
  - an uploaded file closes the same way, for the hosts it contains.

## Who can do what

- Assigning scans needs manage integrations (the tile).
- Importing a file needs manage vulnerabilities.

## Notes (technical)

- The `.nessus` parser is a streaming XML parse (defusedxml; files can be 100 MB+), shared by pull and upload.
- Import as a Celery task, idempotent on (scan, run): the same run read twice changes nothing.
- If COM-1359 found the API refuses scan export on Expert, ship upload only. Record that in the ADR, and the tile's feature says "Upload exports from Nessus".
- Test fixtures: a hand-made `.nessus` file with fake hosts (gitleaks-safe).

**Chain:** on the chain (migration + API).

**Done when:**
- a real Nessus Expert scan on staging is read, by pull or upload;
- its findings land as vulnerabilities or Unmatched;
- a rescan with a fix closes exactly the fixed ones.
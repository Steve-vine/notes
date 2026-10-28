---
id: 01M5YAABEA47JE9N5CTAVG24M8
created: 2026-10-27T09:16:02.378569Z
updated: 2026-10-28T18:16:56.068442Z
type: task
title: Nessus feeds the register — each scan is given to a company on the Nessus tile, finished scans are pulled as they complete, and a .nessus export can always be uploaded instead
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1376
sprint: ssp4evc
blocked_by:
- 01M5YA9T7YGZN49RZ4X73Y344A
- 01M5Y9FKJYXKVFE847JCK8FEEX
comments:
- id: 01M5ZZA1SND51TR84X7GHKGP0Z
  author: Steve Vine
  at: 2026-10-28T00:42:07.029494Z
  text: |-
    Built — PR #1392, merged to main (migration 0719_scanner_parts_imports).

    What's there:
    - Integrations ▸ Nessus ▸ Configure ▸ Scans:
      - every scan the key can see ("Check for scans"), with its targets and when it was last read;
      - each is given a company, or Don't read;
      - a new scan is Not assigned, isn't read, and turns the tile to Needs attention ("1 scan not assigned to a company.");
      - a failed read names the scan, in Nessus's own words;
      - Read now on each.
    - Features ▸ Vulnerabilities is now switchable. Each hour Compass reads newly finished runs of assigned scans, once each. The first read takes only the latest finished run, not the scan's whole history.
    - Vulnerabilities ▸ Register ▸ Import ▸ Nessus file:
      - upload a .nessus export;
      - Compass reads it and shows the scan, hosts, findings by severity, and what importing would do (new, already in the register, closed, fixed, reopened, waiting on Unmatched);
      - then Import or Don't import.
    - Each finding brings the fields the task lists. A plugin seen on several ports of one host is one finding with every port.
    - Closing:
      - a newer run, or a newer file, that covers a host and doesn't report a finding closes it;
      - a host missing from the run closes nothing;
      - a file older than what Compass already has adds, but closes and reopens nothing.

    Who can do what: assigning scans needs manage integrations; importing a file needs manage vulnerabilities.

    Worth knowing:
    - Files up to 100 MB. I raised the web server's upload cap from 30 MB to 110 MB for this. Every other upload keeps its 25 MB limit.
    - Not yet tried against your Nessus Expert, because the COM-1359 check still waits on your keys. Compass pulls through Nessus's documented export. If Expert refuses it, the scan says so in Nessus's words, with "Upload a .nessus export instead", and upload works regardless.

    To try on staging: give a scan a company and press Read now, or upload a .nessus export from Register ▸ Import. Its hosts land on systems or on Unmatched, and a rescan after a fix closes exactly what was fixed.
assignee: steve
label:
- feature
priority: high
task_status: done
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
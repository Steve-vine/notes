---
id: 01M73QCWRE14AT6SKFVHMRFSHK
created: 2026-11-10T21:56:31.11898Z
updated: 2026-11-10T21:58:23.917656Z
type: task
title: 'One account, several companies: a feed names what a "part" is (a repository, container, cloud or scan), parts are assigned to a company on the integration, and each record goes to its part''s company'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1708
sprint: sj4f1kj
assignee: steve
label:
- feature
priority: high
task_status: todo
---
ADR 0146 §3 (COM-1705). This is ADR 0129 §3a's Aikido and Nessus parts, made general. One security tool often covers several companies, but today a Collection account belongs to one.

**Chain:** on the chain — migration + API

## What the person sees

- An account can be **for one company** (as today) or **for several companies**.
- A feed on a several-companies account declares its **part**:
  - where the list of parts comes from: a read of its own (e.g. the workspace's repositories), or the distinct values of a field in the feed's items;
  - which field names a part, and which field shows its name.
- The integration's page gets a **Parts** list: each part with its kind, name, when it was first and last seen, and a company picker or **Don't read**.
  - A new part starts **Not assigned**. Nothing from it is brought in, and the tile shows **Needs attention** until someone chooses.
  - A part no longer listed is marked gone. Its records are left as they were.
  - Assigning or changing a part needs *Manage integrations*, as for Aikido and Nessus today.
- Each record goes to its part's company. One with no part, or an unassigned part, waits and is counted on the run ("12 findings in parts not yet assigned").
- Moving a part to another company affects only future runs. Records already brought in stay with the company they went to (my call, the same as discovery's account rule).

## Done when

- Tested with a fake service across two companies: routing, Not assigned holding records back, Don't read, gone parts, and reassignment affecting only new records.
- `vulnerabilities_latest_reads` and the feed history count records by company. Polaris and the tools show parts and their assignment (and can't assign them, which stays on screen, my call).
- No service name in code (COM-1696).

## Notes

- `models/vulnerability_source.py` `VulnerabilityScannerPart` (source, kind, native_id, company, dont_read, gone) already has this shape for the coded scanners. Generalise it, or add `collection_parts` keyed by account and feed. Don't widen `source` with per-service strings.
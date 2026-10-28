---
id: 01M5YAC96SZXQYW703JPJJKZ97
created: 2026-10-27T09:17:05.625068Z
updated: 2026-10-28T01:21:55.886469Z
type: task
title: Polaris can see what the sources brought in — the latest Nessus and Aikido reads, pen-test imports and what's waiting on Unmatched — and place targets or save matching rules
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1381
sprint: ssp4evc
blocked_by:
- 01M5YA9T7YGZN49RZ4X73Y344A
- 01M5YAB5KEFNGXS492V5JBMBH2
- 01M5YA8TDK3HRXX9J7KGKWWZK4
assignee: steve
label:
- feature
priority: low
task_status: active
---
Sprint 92, Vulnerabilities - Scanner sources (ADR in COM-1374). Extends the sprint 91 Polaris tools (COM-1373).

## What people can ask of it

- **Read:**
  - "what did last night's Nessus scan find?" (the latest read per source: new, matched, closed, unmatched);
  - the pen-test imports and their status;
  - the Unmatched list;
  - the matching rules, with a preview of a rule before it's saved.
- **Change:**
  - place an unmatched target on a system;
  - save a matching rule;
  - ignore a target, with a reason.
  - Ignoring hides findings, so Polaris says how many before doing it.
- **Not allowed:**
  - uploading files: Nessus exports and pen-test reports are uploaded on screen, as evidence is;
  - confirming a pen-test import: a person does that on the import page.
  - Polaris can still be the reader inside the import, as in COM-1379.

## Notes (technical)

Tools in `assistant/tools/vulnerabilities.py`; the read-results summary comes from the import records.

**Chain:** on the chain (no migration; adds tools).

**Done when:** Polaris answers the read questions from real staging data and can place and rule targets as the person.
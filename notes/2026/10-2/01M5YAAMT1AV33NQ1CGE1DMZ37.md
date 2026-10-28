---
id: 01M5YAAMT1AV33NQ1CGE1DMZ37
created: 2026-10-27T09:16:11.96933Z
updated: 2026-10-28T00:08:30.767256Z
type: task
title: Aikido feeds the register — each repository, container and cloud is given to a company on the Aikido tile, and its open issues (dependencies, code, secrets, containers, infrastructure) are read every six hours
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1377
sprint: ssp4evc
blocked_by:
- 01M5YA9T7YGZN49RZ4X73Y344A
- 01M5Y9FKJYXKVFE847JCK8FEEX
assignee: steve
label:
- feature
priority: high
task_status: active
---
Sprint 92, Vulnerabilities - Scanner sources (ADR in COM-1374). Builds on COM-1375 and COM-1359.

## What people see

- **Integrations ▸ Aikido ▸ Configure ▸ What Compass reads:**
  - every repository, container and cloud Aikido covers, each given a **company** (or "Don't read");
  - new ones start as "Not assigned" and turn the tile to Needs attention.
- **Features ▸ Vulnerabilities**, switchable:
  - read every 6 hours;
  - plus **Read now**.
  - Per issue type, a switch: dependencies (open-source CVEs), code (SAST), exposed secrets, containers, infrastructure as code, cloud.
  - Cloud is **off by default**, because sprint 93 reads the clouds' own tools and doubling up would be noise.
- **What each issue brings in:**
  - title;
  - kind:
    - dependency and container → Software flaw;
    - SAST → Code weakness;
    - secrets → Exposed secret;
    - IaC and cloud → Misconfiguration;
  - severity and score;
  - CVEs;
  - the affected package and version, file and line, or image;
  - Aikido's fix advice;
  - a link to the issue in Aikido;
  - first seen.
- **Systems:** a repository or image is placed on a system by a matching rule or by hand on Unmatched. One rule ("repository `acme/billing` → Billing") covers every issue from it.
- **Closing and ignoring:**
  - an issue Aikido marks solved closes its sighting;
  - an issue **ignored in Aikido** comes in as **Accepted**, with "Ignored in Aikido" and Aikido's reason, and no review date;
  - un-ignoring in Aikido reopens it.
  - So Aikido stays the place developers triage code issues, and Compass doesn't ask them twice.

## Who can do what

Assigning and switches need manage integrations (the tile).

## Notes (technical)

- Paging and rate limits as recorded in COM-1359.
- Idempotent on Aikido's issue ID.
- The "accepted in source" state is an acceptance by the source, not a person. The second-person rule doesn't apply, and History says who ignored it in Aikido if the API gives a name.

**Chain:** on the chain (migration + API).

**Done when:**
- Steve's real Aikido workspace is read on staging;
- issues land on the right systems after one rule per repository;
- solved and ignored issues behave as described.
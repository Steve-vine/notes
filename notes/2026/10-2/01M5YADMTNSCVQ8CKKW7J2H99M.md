---
id: 01M5YADMTNSCVQ8CKKW7J2H99M
created: 2026-10-27T09:17:50.293326Z
updated: 2026-10-27T09:17:50.293326Z
type: task
title: Google Cloud feeds the register — Security Command Center's active findings are read for each project or organisation, landing on the systems discovery attached them to
assignee: steve
priority: medium
label: feature
task_status: todo
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1385
---
Sprint 93, Vulnerabilities - Cloud sources (ADR amendment in COM-1382). The same shape as the AWS task.

## What people see

- **Integrations ▸ Google Cloud ▸ Features ▸ Vulnerabilities**, switchable.
  - Each project or organisation with discovery on is also read after its discovery read.
  - Status shows whether Security Command Center is activated and at which tier.
  - With SCC off: "Security Command Center isn't activated for this project".
- **What comes in:** active findings, with:
  - category (e.g. PUBLIC_BUCKET_ACL, OS_VULNERABILITY);
  - severity;
  - description and next steps;
  - CVE and CVSS for vulnerability findings;
  - the resource.
  - Kind: Misconfiguration for posture categories, Software flaw for vulnerability categories, Exposed secret for leaked credentials.
- **Systems:** through the discovered resource, otherwise Unmatched.
- **Closing:** a finding whose state becomes inactive closes its sighting. A **muted** finding is shown as Accepted "muted in Security Command Center".
- **The read role** in `docs/gcp` gains `securitycenter.findings.list` (the Findings Viewer role) at the level discovery reads.

## Who can do what

Inventory admin, as for Google Cloud projects.

## Notes (technical)

- `organizations|projects/*/sources/-/findings` with `state="ACTIVE"`.
- Works keyless through the AWS identity as discovery does (ADR 0104).
- Idempotent on the finding name.
- Nothing has met a real Google project yet (sprint 69). If Steve has no SCC-activated project, ship it tested against fakes and say so in the Done comment.

**Chain:** on the chain (API).

**Done when:**
- findings from an SCC-activated project land on attached systems;
- or the Done comment says no real project was available.
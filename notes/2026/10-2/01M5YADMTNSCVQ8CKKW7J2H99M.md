---
id: 01M5YADMTNSCVQ8CKKW7J2H99M
created: 2026-10-27T09:17:50.293326Z
updated: 2026-10-28T10:07:20.602624Z
type: task
title: Google Cloud feeds the register — Security Command Center's active findings are read for each project or organisation, landing on the systems discovery attached them to
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1385
sprint: svnkdj7
blocked_by:
- 01M5YACKJW9S2N0K25SEG4NJ51
- 01M5YA9T7YGZN49RZ4X73Y344A
- 01M5Y9DTC93BDXKB81918WV0H1
comments:
- id: 01M60ZMXY2WJ99M655A64NG16N
  author: Steve Vine
  at: 2026-10-28T10:07:17.954322Z
  text: |-
    Done — PR #1402 merged to main (272a198a). Not yet on staging (sprint deploy at the end).

    **No real Google project was available — this is tested against Google's documented shapes in the fake only** (as with sprint 69, nothing has met a real Google project).

    What you'll see
    - Integrations ▸ Google Cloud ▸ Features ▸ Vulnerabilities (Inventory admin). Starts OFF.
    - When on, each project's discovery read is followed by a read of Security Command Center's active findings (as the same service account, keyless where discovery is). Category, severity, description and next steps, CVE and CVSS, package and fixed-in version.
    - Kind: Software flaw with a CVE, Exposed secret for leaked credentials, Other for threats, Misconfiguration otherwise.
    - On the system discovery attached the resource to; otherwise Unmatched with "Attach in Inventory".
    - Inactive → closed on the next read. Muted → "Accepted by Google Cloud: Muted in Security Command Center: muted by <who>".
    - Not activated → "Security Command Center isn't activated for this project" on the tile, and nothing closes. Permission missing → named on the tile.
    - Both GCP role files gain securitycenter.findings.list; the organisation set-up switches the Security Command Center API on where the service account lives.

    Not done: the SCC tier isn't shown — Google has no project-level read of it. The tile shows whether it's activated and how many active findings it has.
assignee: steve
label:
- feature
priority: medium
task_status: review
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
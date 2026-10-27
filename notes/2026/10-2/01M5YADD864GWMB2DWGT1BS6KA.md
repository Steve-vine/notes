---
id: 01M5YADD864GWMB2DWGT1BS6KA
created: 2026-10-27T09:17:42.534917Z
updated: 2026-10-27T09:19:16.146813Z
type: task
title: Azure feeds the register — Defender for Cloud's unhealthy recommendations and vulnerability assessments are read for each subscription, landing on the systems discovery attached them to
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1384
sprint: svnkdj7
assignee: steve
label:
- feature
priority: high
task_status: todo
---
Sprint 93, Vulnerabilities - Cloud sources (ADR amendment in COM-1382). The same shape as the AWS task.

## What people see

- **Integrations ▸ Azure ▸ Features ▸ Vulnerabilities**, switchable.
  - Each subscription with discovery on is also read for findings after its discovery read.
  - Status shows, per subscription, which Defender plans are on (Servers, Containers, SQL…). With only the free tier, recommendations still come in, but machine CVEs don't, and the tile says so.
- **What comes in:**
  - **Recommendations** in an *Unhealthy* state, with:
    - title;
    - severity;
    - the recommendation's description and remediation steps;
    - the policy it maps to;
    - the resource.
    - Kind: Misconfiguration.
  - **Vulnerability assessment** results under a recommendation (machines, container images, SQL), each CVE as its own finding, with CVSS, package and fixed-in version. Kind: Software flaw.
- **Systems:** through the discovered resource, as for AWS. Otherwise Unmatched.
- **Closing:** a recommendation that becomes Healthy, or a finding that disappears, closes its sighting. An exemption in Defender is shown as Accepted "exempt in Defender for Cloud" with the exemption's reason.
- **The read role** in `docs/azure` gains `Microsoft.Security/*/read`. Test names what's missing.

## Who can do what

Inventory admin, as for Azure subscriptions.

## Notes (technical)

- Azure Resource Graph over `securityresources`:
  - `microsoft.security/assessments` where status is Unhealthy;
  - `microsoft.security/assessments/subassessments`.
- Resource Graph needs `Microsoft.ResourceGraph/resources/read`.
- Use the existing `core/azure` Reach helper and `MockTransport` fakes.
- Idempotent on the assessment/sub-assessment ID.

**Chain:** on the chain (API; a migration if a new source kind needs one).

**Done when:**
- Steve's real subscription brings in unhealthy recommendations onto attached systems;
- a recommendation made healthy closes on the next read.
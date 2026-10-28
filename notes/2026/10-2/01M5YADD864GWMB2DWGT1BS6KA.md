---
id: 01M5YADD864GWMB2DWGT1BS6KA
created: 2026-10-27T09:17:42.534917Z
updated: 2026-10-28T18:16:47.824438Z
type: task
title: Azure feeds the register — Defender for Cloud's unhealthy recommendations and vulnerability assessments are read for each subscription, landing on the systems discovery attached them to
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1384
sprint: svnkdj7
blocked_by:
- 01M5YACKJW9S2N0K25SEG4NJ51
- 01M5YA9T7YGZN49RZ4X73Y344A
- 01M5Y9DKC0399G5ZEX46MZACW8
comments:
- id: 01M60ZE2FW0WYS6FWPJFSQ7WP8
  author: Steve Vine
  at: 2026-10-28T10:03:33.243909Z
  text: |-
    Done — PR #1401 merged to main (ceb86ce6). Not yet on staging (sprint deploy at the end).

    What you'll see
    - Integrations ▸ Azure ▸ Features ▸ Vulnerabilities (Inventory admin). Starts OFF, as AWS's does.
    - When on, each subscription's discovery read is followed by a read of Defender for Cloud: unhealthy recommendations (Misconfiguration — title, severity, description, remediation, the policy) and the vulnerability results under them (Software flaw — one per CVE, with CVSS, package and fixed-in version). Container-image results land on the image (an image matching rule places them).
    - Findings land on the system discovery attached the resource to; otherwise Unmatched with "Attach in Inventory".
    - Made healthy in Azure → closes on the next read. Exempt in Defender → "Accepted by Azure: Exempt in Defender for Cloud: <reason>".
    - Tile ▸ Status per subscription: which Defender plans are on; "free tier only — recommendations come in, machine CVEs don't"; or "no Servers plan".
    - A listing the role can't read closes nothing and names the permission.
    - docs/azure role gains Microsoft.Security/assessments/read, …/subAssessments/read and pricings/read; README says existing roles must be updated.

    Also in this PR: AWS says a missing permission once for every region, not once per region (found running COM-1383 against the real staging account).

    Deviation: read through Resource Manager's own listings with the connection discovery uses, not Resource Graph — so no extra Resource Graph permission. ADR note corrected.

    Not tried against a real subscription: tested against the Azure fake only. To try: update the role from the file, switch the feature on, Read now.
assignee: steve
label:
- feature
priority: high
task_status: done
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
---
id: 01M4RP2EGKHAGV8XRAJNJMZZ0P
created: 2026-10-12T18:30:17.875444Z
updated: 2026-10-12T21:57:16.544493Z
type: task
title: What Compass reads in Azure is checked, and database engines found there appear in the Software register
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 921
sprint: svsqcj9
blocked_by:
- 01M4RP24NHA2A9DH1H4HJK0Z3C
comments:
- id: 01M4RTZJVF680ZTYWS1NPKYWZS
  author: Me
  at: 2026-10-12T19:56:06.895458Z
  text: |-
    Merged to main (PR #923, 2026-10-12). Not on staging until you say.

    What to look at:
    - A technology asset with Azure resources beneath it shows findings in the same Findings card as AWS ones, and its owner gets the same one action. The sentences are in the task above, and each is closed by the read that finds it fixed.
    - Inventory ▸ Software: PostgreSQL and MySQL servers found in Azure are suggested once they sit beneath a technology asset. The blue box is now headed "Found by discovery, not in this register" and each line says where: "MySQL 8.0 in AWS, on 2 technology assets". It used to say "Found in AWS" for everything.

    My calls, yours to overturn:
    - "Backups are kept for less than a week" is new and has no AWS twin. Azure does not let a server's backups be switched off, so the AWS "backups are switched off" check can never fire there. Seven days is Azure's own default; less is somebody's choice.
    - A SQL database is "open to every address" only when a firewall rule lets every address in. A public endpoint with rules for named addresses raises nothing. "Open to all Azure services" raises nothing either, though it lets other Azure customers' resources reach the server. Say if you want that as a finding.
    - A Cosmos DB account "accepts connections from any network" is Azure's default for a new account, so expect it on most of them. A key is still needed. An owner can accept it with a reason.
    - A storage account open to any network is shown as a fact but is not a finding. It is the default, most accounts are that way, and anonymous access is the thing that matters.
    - PostgreSQL 16 in Azure and PostgreSQL 16 in AWS are two Software entries, not one. Each provider supports a version for a different length of time.
    - No support dates for Azure engines. AWS publishes them where Compass can read them; Azure does not. They can be typed.

    Technical: no migration. Finding keys say what is wrong, not where, so four are shared with AWS.
label:
- feature
priority: high
task_status: done
---
Part of sprint 67, Inventory expansion (ADR in COM-917). The findings and the Software register already exist for AWS (COM-888, COM-889); this gives Azure resources the same treatment.

## What people see

- **A technology asset with Azure resources beneath it shows findings**, raised to its owner as one action, accepted with a reason or turned into a risk, and closed by the read that finds the fact has changed — all as for AWS. The checks:
  - A storage account lets anyone read blobs without signing in.
  - A storage account accepts connections that are not encrypted.
  - A SQL database is not encrypted at rest.
  - A SQL database, PostgreSQL server or MySQL server is open to every address on the internet.
  - A Cosmos DB account accepts connections from any network.
  - Backups are kept for less than a week on a PostgreSQL or MySQL server. (Azure does not let them be switched off.)
  - A Kubernetes cluster's control endpoint is public and not limited to named address ranges.
  - A web app or function app does not insist on HTTPS.
- **A fact Compass could not read raises nothing and closes nothing**, as now.
- **PostgreSQL and MySQL found in Azure appear in the Software register** as an install on the technology asset the server sits beneath, and are suggested where no entry claims them. Azure publishes no support dates through this route, so none are shown; a person can enter them.
- **Azure SQL is not suggested as software:** it is a service with no version to track.

## Notes (technical)

- New entries in `core/discovery/checks.py`, by kind. Keys reused where the meaning is the same (`not_encrypted`, `internet_reachable`, `control_endpoint_public`), new where it is not.
- `core/discovery/software.py`: the discovery key gains an Azure family (`azure.postgres:<engine>:<major>`), beside `aws.rds:…`. The "Found in AWS" wording on the suggestion says where it was found.
- No migration.

**Done when:** on staging an Azure storage account that allows anonymous blob access, attached to a technology asset, shows the finding on the asset and in its owner's actions.
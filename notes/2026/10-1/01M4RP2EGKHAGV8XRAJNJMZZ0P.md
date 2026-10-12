---
id: 01M4RP2EGKHAGV8XRAJNJMZZ0P
created: 2026-10-12T18:30:17.875444Z
updated: 2026-10-12T18:30:51.658484Z
type: task
title: What Compass reads in Azure is checked, and database engines found there appear in the Software register
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 921
sprint: svsqcj9
blocked_by:
- 01M4RP24NHA2A9DH1H4HJK0Z3C
label:
- feature
priority: high
task_status: todo
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
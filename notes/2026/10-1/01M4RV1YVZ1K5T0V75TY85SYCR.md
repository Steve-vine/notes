---
id: 01M4RV1YVZ1K5T0V75TY85SYCR
created: 2026-10-12T19:57:24.73531Z
updated: 2026-10-12T19:57:26.448576Z
type: task
title: What Compass reads in Google Cloud is checked, and database engines found there appear in the Software register
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 929
sprint: s70gjk2
assignee: steve
label:
- feature
priority: high
task_status: todo
---
Part of sprint 69, Inventory discovery - GCP (ADR in COM-924). The findings and the Software register already exist for AWS and Azure (COM-888, COM-889, COM-921); this gives Google Cloud resources the same treatment.

## What people see

- **A technology asset with Google Cloud resources beneath it shows findings**, raised to its owner as one action, accepted with a reason or turned into a risk, and closed by the read that finds the fact has changed — all as for AWS and Azure. The checks:
  - A Cloud Storage bucket can be read by anyone without signing in.
  - A BigQuery dataset is shared with anyone on the internet.
  - A Cloud SQL instance is open to every address on the internet.
  - A Cloud SQL instance accepts connections that are not encrypted.
  - Automated backups are switched off on a Cloud SQL instance.
  - A Firestore database cannot be wound back to a point in time.
  - A GKE cluster's control endpoint is public and not limited to named address ranges.
- **There is no "not encrypted at rest" check.** Google encrypts everything read here and does not allow that to be switched off.
- **A Cloud Run service or function that anyone can call is shown as a fact and raises nothing.** A public website is meant to be public.
- **A fact Compass could not read raises nothing and closes nothing**, as now.
- **PostgreSQL, MySQL and SQL Server found in Cloud SQL appear in the Software register** as an install on the technology asset the instance sits beneath, and are suggested where no entry claims them. No support dates are shown unless Google turns out to publish them through this route; a person can enter them.
- **Spanner, Firestore and BigQuery are not suggested as software:** each is a service with no version to track.

## Notes (technical)

- New entries in `core/discovery/checks.py`, by kind. Keys reused where the meaning is the same (`public_access_not_blocked`, `internet_reachable`, `unencrypted_connections_allowed`, `no_backups`, `no_point_in_time_recovery`, `control_endpoint_public`); a new key only where none fits. The module's docstring gains Google's line beside Azure's.
- The bucket check fires on "anyone can read it", not on public access prevention being merely unset: unset is Google's default and would raise a finding on almost every bucket.
- `core/discovery/software.py`: the discovery key gains a Google family (`gcp.cloudsql:<engine>:<major>`), beside `aws.rds:…` and `azure.postgres:…`. Cloud SQL's version strings (`POSTGRES_16`, `MYSQL_8_0`, `SQLSERVER_2022_STANDARD`) are split into engine, major version and, for SQL Server, edition. The suggestion says "Found in Google Cloud".
- Support dates: confirm whether the Cloud SQL Admin API publishes end-of-support dates per version. If it does, show them beside the typed ones as for AWS (COM-889); if not, none.
- No migration.

**Done when:** on staging a Cloud Storage bucket that anyone can read, attached to a technology asset, shows the finding on the asset and in its owner's actions.
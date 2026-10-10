---
id: 01M4GQAX5R29AP2NY27WDBQZTY
created: 2026-10-09T16:18:28.152931Z
updated: 2026-10-10T13:36:29.345835Z
type: task
title: Compass reads what holds data in a connected AWS account — buckets, databases, tables and file systems — every six hours and on demand
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 883
sprint: svsqcj9
blocked_by:
- 01M4GQACVAJQFDZPY0MK40W58J
assignee: steve
label:
- feature
priority: high
task_status: todo
---
Part of sprint 67, Inventory expansion (ADR in COM-881). This is the reading. What it finds is first shown by the Discovered tab task, so the two go to staging together.

## What people see

- **Each connected AWS account shows** when it was last read, how many resources were found, and a count per kind.
- **If one kind could not be read** (usually a missing permission on the role), the account says which and why. Everything else is still read.
- **"Read now"** starts a read without waiting for the next scheduled one.
- **What is read in this task:** storage buckets (S3), databases (RDS instances and Aurora clusters, including DocumentDB and Neptune where they appear in the same listing), tables (DynamoDB) and file systems (EFS).
- **What Compass keeps about each:** its name, region, when it was created, its tags, and a few facts.
  - Buckets: default encryption, whether public access is fully blocked, versioning.
  - Databases: engine and version, encrypted or not, publicly reachable or not, multi-zone, backup retention, storage size, deletion protection.
  - Tables: encryption, point-in-time recovery, deletion protection, approximate size.
  - File systems: encrypted or not, backups on or off, size.
- **Nothing inside a resource is ever read.**

## Notes (technical)

- **`discovered_resources`**, company-scoped and provider-neutral so Azure and on-prem reuse it.
  - `provider` (`aws`), `connection_id`, `native_id` (the ARN; unique per provider), `kind` (a string key such as `aws.rds.cluster`), `category` (`datastore` | `compute` | `entry_point`), `name`, `region`, `facts` (JSONB), `tags` (JSONB).
  - `first_seen_at`, `last_seen_at`, `gone_at`.
  - Review state `new` | `attached` | `discarded`, with the discard reason, who and when (the Discovered tab task uses these).
  - `kind` and `category` are plain strings, not Postgres enums: a new kind must not need a migration.
- **Reader registry** under `core/discovery/aws/`, one module per service. Each reader declares its kind, category, display label, the IAM actions it needs, and `read(client_factory, region)`.
  - Adding a kind later is one registry entry.
  - A test asserts the shipped policy in `docs/aws/` covers every action the registry declares.
  - Each reader also provides a short `summarise(facts)` for display, so the frontend never learns AWS's shapes.
- **Sync task** `tasks/aws_discovery.py`: `sync_aws_account(connection_id)` is idempotent and takes an ID.
  - A beat fan-out every six hours at an offset minute, clear of the existing sweeps.
  - One read per connection at a time; a manual read while one is running is a no-op that says so. Follow how `tasks/directory_sync.py` guards overlap.
- **Upsert by ARN.** A reappearing resource clears `gone_at`.
- **The sweep.** After a kind has been read successfully in a region, anything of that kind and region not seen in this run gets `gone_at`. **A kind or region that failed is not swept.**
- **Regions.** The account's enabled regions, narrowed by the connection's choice. S3 is listed once and each bucket's region looked up.
- **Aurora.** A cluster is one resource; its instances and replicas are facts on it, not rows of their own.
- **Failures.** `AccessDenied` and throttling are recorded per kind on a sync status row (the shape of the directory read statuses) and do not fail the run.
- **Pagination** on every listing; batched upserts.
- **Tags** are untrusted display text: length-capped, never used as a log format string.
- **Logging.** Structured, no reserved keys in `extra`; a caplog test at INFO around the new lines.
- **API.** Status on the connection, and `POST …/sync` returning 202. Regenerate `schema.d.ts` and run the drift script.
- **Tests.** Each reader against fake responses in AWS's real shape; the sweep rules (a failed kind is not swept, reappearance) on real Postgres.

**Done when:** on staging, "Read now" on the connected account completes and the per-kind counts match what is in the account. Goes out with the Discovered tab task.
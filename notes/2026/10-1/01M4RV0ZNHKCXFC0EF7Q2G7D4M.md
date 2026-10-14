---
id: 01M4RV0ZNHKCXFC0EF7Q2G7D4M
created: 2026-10-12T19:56:52.785875Z
updated: 2026-10-14T20:41:39.583479Z
type: task
title: Compass reads what holds data in a connected Google Cloud project — Cloud Storage buckets, Cloud SQL instances, Firestore databases, BigQuery datasets and Spanner instances — every six hours and on demand
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 927
sprint: s70gjk2
blocked_by:
- 01M4RW1BDDBTCVDS55TACHHGAG
comments:
- id: 01M4S8YAEXZ8SGTH46AVWYKWCS
  author: Steve Vine
  at: 2026-10-13T00:00:05.597434Z
  text: |-
    Merged to main (PR #931, 2026-10-12). Not on staging until the whole sprint is in review.

    What to look at, once a project is connected:
    - Inventory ▸ Settings ▸ Google Cloud projects: each row now has Read now, and under the name says what the last read found ("13 resources found: 3 Cloud Storage buckets, 4 Cloud SQL instances…"). A kind that could not be read is named in orange or red with what to do.
    - Inventory ▸ Discovered: Google Cloud resources are in the same list as AWS and Azure ones. Same three decisions, same bulk actions, same rules. "Found in" lists projects with accounts and subscriptions.
    - Making a technology asset from one pre-fills "Google Cloud · europe-west2 · PostgreSQL 16 Cloud SQL instance".

    What is read: Cloud Storage buckets, Cloud SQL instances, Firestore databases, BigQuery datasets, Spanner instances.

    Things worth knowing:
    - A Cloud SQL instance is listed, not the databases in it. A read replica is listed and says what it copies.
    - A BigQuery dataset is listed, not its tables.
    - Google encrypts all of these at rest and does not allow that to be switched off, so there is no "encrypted" fact. Whether the customer's own key is used is shown.
    - "Open to every address" on a Cloud SQL instance means a network of 0.0.0.0/0 is allowed in. A public address with no network allowed in is reachable only through Google's own proxy: it is shown, and not treated as open.
    - A bucket shows whether anyone can read it. Where a bucket does not have one access policy for the whole bucket, single objects can be shared one by one; Compass cannot see that without listing objects, which it does not do. The row says whether that could be so.
    - Compass asks who a bucket or a dataset is shared with only far enough to learn whether that is everyone. It does not ask for the part of a dataset's answer that holds people's email addresses.
    - A Google service the project has never switched on reads as none found, not as a failure.

    Not tested against a real project. The field names come from Google's published API, not a live answer, so the first real read may show a fact as Unknown that should not be. Tell me what you see and I will fix it forward.

    Technical: no migration. Readers in core/discovery/gcp/. The role file grows from 1 permission to 7; a project connected before this needs its role updated (gcloud iam roles update with the file downloaded again), and until then says which kinds it may not read.
assignee: steve
label:
- feature
priority: high
task_status: done
---
Part of sprint 69, Inventory discovery - GCP (ADR in COM-924). This is the reading. What it finds appears on the Discovered tab that AWS and Azure already use, and is decided the same three ways.

## What people see

- **Each connected Google Cloud project shows** when it was last read, how many resources were found, and a count per kind. **Read now** reads it at once.
- **The Discovered tab lists Google Cloud resources beside the others:** the same columns, the same three decisions (make a technology asset, add to one, discard with a reason), the same bulk actions. The "Found in" filter lists projects with AWS accounts and Azure subscriptions.
- **What is read, and what Compass says about each:**
  - Cloud Storage bucket: whether anyone can read it without signing in, whether public access is ruled out altogether, where it is kept and across how many regions, whether old versions of objects are kept.
  - Cloud SQL instance: engine and version, whether it has a public address and whether that is open to every address, whether it insists on encrypted connections, whether automated backups are on and how many are kept, whether it survives the loss of a zone, its size and storage.
  - Firestore database: which mode it runs in, where it is kept, whether it can be wound back to a point in time, whether it is protected from deletion.
  - BigQuery dataset: where it is kept, whether it is shared with anyone on the internet, whether its tables expire by default.
  - Spanner instance: where it runs and across how many regions, its size.
- **A kind that could not be read says so on the project** and names the missing permission. Everything else is still read, and nothing of that kind is marked gone.
- **A Google service the project has never switched on reads as "none found"**, not as a failure.
- **Rules file Google Cloud resources as they arrive.** A rule can name a project as it can an account or a subscription.
- **A technology asset made from a Google Cloud resource** is pre-filled "Google Cloud · region · what it is".
- **Names keep their capitals in the middle of a sentence:** "3 Cloud Storage buckets, 2 Cloud SQL instances, 1 BigQuery dataset".
- **Removing a project** keeps what is attached to a technology asset, marked no longer read.
- **Never read:** the objects in a bucket, the rows in a database or a table, a database's users and passwords.

## Notes (technical)

- **Readers** in `core/discovery/gcp/`: `storage`, `cloudsql`, `firestore`, `bigquery`, `spanner`, registered in `READERS` and joined in `core/discovery/sources.py`. Each declares its kind (`gcp.storage.bucket` …), category, the permissions it needs, `read` and `summarise`. The shipped role is rebuilt from them and the test holds the file to it.
- **Every list is project-wide** and follows `nextPageToken`. A resource carries its own location.
- **Every request carries a `fields` mask** naming what the reader keeps. A test holds each reader to its mask.
- **Google encrypts all of these at rest and does not allow that to be switched off**, so there is no "encrypted" fact. Whether a customer-managed key is used can be a fact; it is not a finding.
- **A bucket's "anyone can read it"** is its IAM policy naming `allUsers` or `allAuthenticatedUsers` (`storage.buckets.getIamPolicy`, one call per bucket). "Ruled out altogether" is public access prevention `enforced`, from the listing. If the policy cannot be read the fact is unknown, never false.
- **A Cloud SQL instance, not its databases, is the resource** (the RDS instance's counterpart). A read replica is an instance and says what it copies. "Open to every address" is an authorised network of `0.0.0.0/0`. A public address with no authorised networks is a fact and is not treated as open.
- **A BigQuery dataset, not its tables.** Listing gives names only; `datasets.get` per dataset gives location, access and default expiry. "Shared with anyone" is an access entry for `allUsers` or `allAuthenticatedUsers`.
- **Firestore:** `projects/{id}/databases`, which includes Datastore-mode databases and `(default)`.
- `native_id` is the full resource name with the project as its ID (see the ADR).
- **`core/discovery/gcp_sync.py`** drives the read with the upsert, sweep and "a refused fact keeps its last known value" that `sync.py` already has. A failed read never marks anything gone. A 403 `SERVICE_DISABLED` naming this project is an empty answer; one naming another project is a set-up fault reported on the connection.
- **Celery.** `tasks/gcp_discovery.py`: per-connection read and a six-hourly fan-out, in the `azure_discovery` shape.
- **API.** `POST /inventory/gcp-connections/{id}/sync`; per-kind counts and verdicts on the connection.
- **Capitals.** The names that begin with a product's name ("Cloud Storage", "Cloud SQL", "Firestore", "BigQuery", "Spanner") join the `in_sentence` rule from COM-923.
- **Tests.** `tests/gcp_fakes.py` answers Google's APIs through the one seam, in Google's own response shapes.

**Done when:** on staging a connected project is read, its buckets and databases appear on the Discovered tab, and one can be made into a technology asset.
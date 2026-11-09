---
id: 01M70WJ3BFVAW83FVS3TS3NQ7Q
created: 2026-11-09T19:29:01.2952Z
updated: 2026-11-09T19:54:59.716629Z
type: task
title: Directory sync fails every run when one Entra certificate is on several app registrations — a key is told apart by the app it's on, not by its ID alone
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1655
sprint: sjrd5gz
comments:
- id: 01M70X5JKDPD4X0G01MJJHKZZ7
  author: Steve Vine
  at: 2026-11-09T19:39:39.501225Z
  text: |-
    PR #1664 is open with auto-merge set. It's on the chain: migration 0798.

    - Entra keys are now matched by app and key ID together. A key read twice in one pass is updated, not inserted twice.
    - The shared unique index becomes (kind, owner_ref, key_ref).
    - Change from the plan: company-scoped sources (AWS, GitHub, Google) still match on key ID alone. A GitHub token's owner_ref includes its name, so matching on the owner too would turn a renamed token into a new key and break the company index.
    - Tests:
      - One certificate on two apps gives two keys, a second pass changes nothing, and removing it from one app leaves the other. This fails on main with the staging error.
      - A migration round-trip test.
assignee: steve
label:
- bug
priority: high
task_status: review
---
Found 2026-11-09 from Steve's report: Admin ▸ Jobs shows **Syncing the directory** failed. It has failed every 15 minutes on staging since the Secrets sprint landed (4 Nov), so the directory mirror hasn't refreshed since. Also in v0.17.0.

## What people see

- Today: the job fails every run; Access Control's directory stops updating.
- After: the job succeeds. A certificate uploaded to three app registrations shows as three keys on Secrets ▸ Discovered ▸ Keys, one per app, each with its own app name.

## Notes (technical)

- Staging: the Veeam certificate (`CN=Veeam Software`, keyId 9bb76178-06da-493f-a5c1-decf4879bc85) is on three applications. Entra's keyId is unique per object, not per tenant.
- `core/secrets/sources.py upsert` keyed existing rows by `key_ref` alone, and the shared partial unique index `uq_secret_source_keys_shared` is `(kind, key_ref) WHERE company_id IS NULL` (migration 0780). Two reads with one key_ref → two inserts → UniqueViolation in `refresh_entra`, which aborts the whole `sync_directory` pass.
- Fix: key on `(owner_ref, key_ref)` in `upsert`; new migration replacing the shared index with `(kind, owner_ref, key_ref)`. Company-scoped kinds (AWS, GitHub, GCP) have globally unique ids — leave their index, but key the upsert the same way.

**Chain:** on the chain (migration).

**Done when:** the regression test (one certificate on two apps) passes; on staging the next Syncing the directory run succeeds and the Veeam certificate shows once per app.
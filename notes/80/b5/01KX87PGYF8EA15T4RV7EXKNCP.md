---
id: 01KX87PGYF8EA15T4RV7EXKNCP
created: 2026-07-10T20:36:57.373668446Z
updated: 2026-07-11T11:51:37.688238Z
type: task
title: Credential storage with envelope encryption (conflict copy)
assignee: steve
priority: high
task_status: review
project: 01KX671DATY39VW6GWK3M2T3DN
number: 14
blocked_by:
- 01KX6VXSDBE12B66M73JW8YX5Y
- 01KX6VXVPJGWSDV0M5XYA3EX00
trashed: 2026-07-11T11:51:37.672636Z
comments:
- id: 01KX87K95KJZCBX5EHMWQC465W
  author: Steve Vine
  at: 2026-07-11T09:19:37.139061284Z
  text: 'Development complete on feature/ise-014-credential-storage. PR #18: https://github.com/Steve-vine/ise/pull/18. AES-256-GCM envelope encryption (fresh DEK per secret, KEK from ISE_CREDENTIAL_MASTER_KEY deployment secret only, never in DB; key_version per row for rotation). Credential model + migration 0005. Service: store/reveal(internal, audited w/ purpose)/delete, all same-transaction audited; audit carries field NAMES only. /api/v1/credentials admin-only, strictly write-only (no plaintext field exists), 503 until key set. 75/75 tests incl. raw-DB no-plaintext check. Staging KEK added to ise-env-overrides; migration 0005 applied on staging (verified). Two CI notes: (1) gitleaks flagged a dummy fixture value — fixed with obviously-fake constants, and since it scans full branch history I squashed the branch to one clean commit; (2) could not do a live authenticated staging credential test because the break-glass password file was (correctly) removed and Entra isn''t configured yet — the admin-gate blocking me is itself correct; full encryption round-trip was verified in local compose (plaintext absent from DB bytes, audit present). Awaiting smoke test + merge clearance.'
conflict_of: 01KX6VYSWX5YQ7GB57JH8AT6XK
sprint: sqtx330
---
Encrypted-at-rest storage for target-system credentials with envelope encryption (ADR 0018). Writes/reads audited; secrets never logged (redaction list extended as shapes are added).
---
id: 01M2NA9AVT1C9YW454F1AZNWB5
created: 2026-09-16T14:35:13.65803Z
updated: 2026-09-16T14:35:16.356771Z
type: task
title: Where attachments are stored is set in the app — an Admin section with Filesystem volume / S3 bucket, a test-connection check, and each file remembering where it lives
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 718
sprint: stek6vx
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Scoped with Steve 2026-09-16 after the first AWS staging install, where the bucket name had to be passed at install time and a mis-set value only surfaced as "Upload failed" (COM-717). The bucket is a runtime fact an administrator should be able to set and change in the app, the way email transports are (ADR 0044): a stored setting wins, the chart values are the fallback for a fresh install.

**What the admin sees** — Admin → Attachments (or a section on the existing settings page):

- A dropdown **Where attachments are stored** with two choices, more later:
  - **Filesystem volume** — no path field. The path is wherever the chart mounted the volume (`STORAGE_LOCAL_PATH`); it is shown read-only ("mounted at /data/storage"), because an app cannot mount a volume at runtime and a typed path that is not a mount writes to the pod's throwaway filesystem — the silent loss COM-711 just removed. (A subfolder inside the mount is a possible later nicety; not now.)
  - **S3-compatible bucket** — bucket, region, optional endpoint (MinIO, Ceph, R2…), path-style toggle, optional access key + secret. Keys blank = the pod's workload identity (IRSA etc.). The secret is stored encrypted like the M365/SSO credentials (secretbox, SESSION_SECRET_KEY).
- A **Test connection** button before Save: write and delete a tiny object (or, for the volume, create and delete a file). A wrong bucket, region or role becomes a message on the page, not a 500 on the next upload.
- Who: admins only. Changing it is permanent and takes effect immediately for new uploads.

**Existing files keep working.** Each attachment records where it was stored (backend + the location it was written to) at upload time; reads use that, not the current setting. So a change applies to new uploads and everything old still opens from where it is. Moving files between stores is out of scope (a later migration job if anyone needs it).

**Where it sits in the chart / install**: the volume itself and the pod identity stay install-time facts (cluster things). `config.storageBackend`, `config.s3.*` and the S3 keys become the fallback used until an admin has saved a setting — same shape as email. The install guide (COM-716) says so.

**Technical notes** (for the PR): a settings row like `email_transports`; `get_storage()` resolves per request from the row with a short cache, and the worker (PDF render) and import Job resolve the same way — the current `lru_cache` on it must go; a migration adds the per-attachment location; `/readyz` unchanged. Probably worth an ADR amendment to 0013 (attachments) recording "the store is admin-managed; files remember their store".

**Acceptance**: an admin switches a fresh install from the fallback to a bucket in the UI with Test connection green, uploads a file, switches to a second bucket, uploads another — both download; an install with no setting saved behaves exactly as today from the chart values; a wrong bucket fails at Test connection with the reason.
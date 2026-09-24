---
id: 01M2NA9AVT1C9YW454F1AZNWB5
created: 2026-09-16T14:35:13.65803Z
updated: 2026-09-24T20:29:38.169767Z
type: task
title: Where attachments are stored is set in the app — an Admin section with Filesystem volume / S3 bucket, a test-connection check, and each file remembering where it lives
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 718
sprint: stek6vx
comments:
- id: 01M2NGA4TTSRATAH0XZ0AJMQAQ
  author: Steve Vine
  at: 2026-09-16T16:20:31.706194Z
  text: |-
    Merged to main 2026-09-16 as d6328e8 (PR #728), with ADR 0074. Admin ▸ Attachments: the "Where attachments are stored" dropdown (Filesystem volume — shown not typed, only when mounted; S3-compatible bucket), credentials as the pod's identity (the role it carries is shown) or an encrypted write-only key pair, Test connection with the provider's own error, Save, Forget saved store. Every file records `store_ref` on upload and every read follows it (attachments, content files, templates, report runs, rendered PDFs, the admin files check, the company purge, the retention sweep). Nothing configured = 409 naming the screen, nothing mounted, notes say so. The environment stays as a labelled fallback (the M365/Entra/SSO shape — the ADR says why not email's seed). Chart: `config.storageBackend` defaults to unset; `storage.persistentVolume` off by default and is what offers the Filesystem option; `local` without a volume still refused at render.

    Verified: new unit + integration test modules, vitest for the section, Helm 4 renders in seven shapes, kubeconform strict, the immutable-fields check. CI's first run lost two runners (backend-unit and deps-scan cut off mid-install) and caught one real thing (the screen-conventions toggle rule); rerun green. On main, not released — per Steve's instruction. The AWS staging install with 0.2.1 still uses the `config.s3.*` pre-seed until the next release carries this.
assignee: steve
label:
- feature
priority: medium
task_status: done
tech: null
---
Scoped with Steve 2026-09-16 after the first AWS staging install, where the bucket name had to be passed at install time and a mis-set value only surfaced as "Upload failed" (COM-717). The bucket is a runtime fact an administrator should be able to set and change in the app, the way email transports are (ADR 0044): a stored setting wins, the chart values are the fallback for a fresh install.

**What the admin sees** — Admin → Attachments (or a section on the existing settings page):

- A dropdown **Where attachments are stored** with two choices, more later:
  - **Filesystem volume** — no path field. The path is wherever the chart mounted the volume (`STORAGE_LOCAL_PATH`); it is shown read-only ("mounted at /data/storage"), because an app cannot mount a volume at runtime and a typed path that is not a mount writes to the pod's throwaway filesystem — the silent loss COM-711 just removed. Offered only when a volume is actually mounted. (A subfolder inside the mount is a possible later nicety; not now.)
  - **S3-compatible bucket** — bucket, region, optional endpoint (MinIO, Ceph, R2…), path-style toggle, and a credentials choice: **the pod's identity** (IRSA / Azure Workload Identity / GKE Workload Identity — the default; the role the pod carries is shown for information if there is one) or **access key + secret** entered here. The secret is stored encrypted like the M365/SSO credentials (secretbox, SESSION_SECRET_KEY). The identity itself cannot be set in the app: the cluster grants it to the pod at start from the ServiceAccount annotation (the chart's `api.serviceAccount.annotations` / `worker.serviceAccount.annotations`), and no running pod can acquire one afterwards — so that annotation stays a values-file fact, like the volume mount.
- A **Test connection** button before Save: write and delete a tiny object (or, for the volume, create and delete a file). A wrong bucket, region or role becomes a message on the page, not a 500 on the next upload.
- Who: admins only. Changing it is permanent and takes effect immediately for new uploads.

**Existing files keep working.** Each attachment records where it was stored (backend + the location it was written to) at upload time; reads use that, not the current setting. So a change applies to new uploads and everything old still opens from where it is. Moving files between stores is out of scope (a later migration job if anyone needs it).

**A fresh install has no store, and says so** (added 2026-09-16). With nothing configured the chart mounts no volume and the app refuses uploads with "Attachments store not configured — an administrator sets it under Admin → Attachments". This replaces "default to a ReadWriteOnce volume", which on a multi-node cluster is a claim nobody wanted. The chart's `storage.persistentVolume` stays for operators who *do* want a volume (it is then what the "Filesystem volume" option uses), and `config.storageBackend` / `config.s3.*` remain as an optional pre-seed for GitOps installs, used only until an admin has saved a setting. The COM-711 render-time refusal of "local with no volume" therefore becomes: `storageBackend: local` requires a volume; `storageBackend` unset means "not configured yet". After this the values file for an EKS install is the Secret name, `appBaseUrl`, the ServiceAccount annotations if using pod identity, and a StorageClass for Valkey if the cluster has no default — nothing else.

**Where it sits in the chart / install**: the volume itself and the pod identity stay install-time facts (cluster things). The bucket, region, endpoint and keys are admin-managed with the chart values as the fallback — same shape as email. The install guide (COM-716) says so.

**Technical notes** (for the PR): a settings row like `email_transports`; `get_storage()` resolves per request from the row with a short cache, and the worker (PDF render) and import Job resolve the same way — the current `lru_cache` on it must go; a migration adds the per-attachment location; a "not configured" storage that raises a typed error the upload endpoints turn into a clear 409/422; `/readyz` unchanged. Probably worth an ADR amendment to 0013 (attachments) recording "the store is admin-managed; files remember their store; unconfigured refuses rather than defaulting".

**Acceptance**: a fresh install with no storage values refuses an upload with the "not configured" message and mounts no volume; an admin sets a bucket in the UI with Test connection green, uploads a file, switches to a second bucket, uploads another — both download; an install with `config.s3.*` pre-seeded behaves as today until an admin saves a setting; a wrong bucket fails at Test connection with the reason; the pod-identity option works on env-staging-uk with no keys entered.
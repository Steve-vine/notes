---
id: 01M2GDNT92VXH3B1WZZ888YSNZ
created: 2026-09-14T16:58:16.22611Z
updated: 2026-09-14T16:58:45.059851Z
type: task
title: 'Attachments: the default values stop losing them, and a shared filesystem becomes a supported option'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 711
sprint: stek6vx
assignee: steve
label:
- bug
priority: high
task_status: todo
---
ADR 0073 §7. Two things: fix a broken default, and make the filesystem path a real option rather than a dev-only fallback.

**The default is broken.** `storageBackend: local` with `persistentVolume.enabled: false` and `api.replicas: 2` means uploads land on each pod's ephemeral filesystem, vanish on restart, and are invisible to the other replica. A default install silently loses evidence attachments. The chart must either default to a working combination or refuse to render an inconsistent one.

**The constraint that is currently only a code comment.** Three pods mount that volume — the API, the worker (the PDF render task writes there) and the import Job. So ReadWriteOnce works only where all three land on the same node: true on single-node k3s, false everywhere else, and silent when it breaks. Multi-node installs need ReadWriteMany or object storage.

**Steps**

1. Refuse to render, with a clear message, when `storageBackend: local` and no volume is enabled — or default the volume on. Decide which at implementation time; the failure must not be silent either way.
2. Document the supported object stores: AWS S3, MinIO, Ceph, Cloudflare R2, Wasabi, GCS in interop mode. `endpointUrl` and `usePathStyle` already cover them.
3. Document the shared-filesystem path as first-class, **EFS and Azure Files included** — the natural answer for anyone who would rather not run MinIO. Azure Files needs `uid`/`gid` mount options on the StorageClass, because the pods run as uid 10001.
4. Say plainly in `values.yaml` which access mode is needed: RWO single-node only, RWX otherwise.
5. Keep workload identity as the credential path where the platform has it — the existing ServiceAccount annotations already serve IRSA, Azure Workload Identity and GKE Workload Identity, and no template change is needed.

**Acceptance**: a two-replica install with `local` storage and no RWX volume fails loudly at install rather than losing files; an install against MinIO and an install against an RWX PVC both round-trip an attachment upload and download.
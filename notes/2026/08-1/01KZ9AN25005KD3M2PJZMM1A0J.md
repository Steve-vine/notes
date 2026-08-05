---
id: 01KZ9AN25005KD3M2PJZMM1A0J
created: 2026-08-05T16:03:39.296248Z
updated: 2026-08-05T16:04:21.097369Z
type: task
title: Migrate Deepgram EFS Volume
order: 5.0
assignee: steve
label: tech_debt
priority: medium
task_status: todo
tech:
- aws-efs
- kubernetes
- deepgram
---
## Why

ISE incidents **IN-1208** (deepgram-engine 0/1 ready) and **IN-1207** (deepgram-api, merged child) on env-staging-uk: the Deepgram engine mounts the **root** of EFS filesystem `fs-00ae8ec18a0577eed` at `/models` and recursively scans it for models. A code-server PVC (`openanswer/code-server-cory`, EFS dynamic provisioning with basePath `/code-server` on the same filesystem) landed at the filesystem root, so the engine scanned tens of thousands of PHP files from a `Web.OpenAnswer` clone (`err=NoManifestFound` per file), blew its startup probe window (511 probe failures, 8+ restarts) and never became ready. Full diagnosis is on IN-1208.

Any tenant directory created at the filesystem root becomes "models" to the engine — code-server today, anything else tomorrow. The same root-mount design is live in **staging-us, sandbox and production**.

## Change

In `Moneypenny-Development/devops.application.deepgram`, per env values file (staging-uk first: `envs/staging-uk-deepgram-flux-chart.yaml`):

```yaml
modelManager:
  volumes:
    aws:
      efs:
        enabled: true
        fileSystemId: "fs-00ae8ec18a0577eed:/deepgram"   # was: fs-00ae8ec18a0577eed
        namePrefix: dg-models-v2                          # bump — see PV immutability below
```

The chart (`deepgram-self-hosted` 0.31.0) drops `fileSystemId` verbatim into the static PV's `csi.volumeHandle`; the EFS CSI driver understands `fs-id:/subpath` and mounts only `/deepgram` at `/models`. Engine search path stays `/models`; the projection is now scoped. Stays in `aws.efs` mode so the chart's model-download job keeps working and re-seeds `flux-general-en` into the new subdirectory automatically.

## Gotchas

1. **The `/deepgram` directory must pre-exist** — the CSI driver won't create a subpath for a static mount; the volume mount fails otherwise. One-off Job/pod mounting the filesystem root to `mkdir /deepgram` before the values change syncs.
2. **`volumeHandle` is immutable on a live PV** — Argo cannot edit `dg-models-aws-efs-pv` in place. Bump `namePrefix` (e.g. `dg-models` → `dg-models-v2`) so the chart creates fresh SC/PV/PVC and Argo prunes the old objects. Old PV is `Retain` — delete manually afterwards.

## Sequence (per env, staging-uk first)

1. mkdir Job creates `/deepgram` on the filesystem
2. Merge values change (subpath + namePrefix bump) → Argo syncs
3. Model-download job re-seeds models into `/deepgram`
4. Engine starts clean inside its probe window → verify IN-1208/IN-1207 clear
5. Delete retained old PV; repeat for staging-us, sandbox, production (their own fileSystemIds)

## Alternative considered

`customVolumeClaim` mode + `modelsDirectory` narrows the engine's search path (`/models/<dir>`) without touching mounts, but loses the chart's managed model-download job (gated on `aws.efs.enabled`) — manual model seeding forever. Subpath mount preferred. `engine.customToml` cannot override `[model_manager]` (duplicate TOML table).

## Notes

- code-server needs no changes; Cory's workspace was never at fault.
- Interim state: IN-1208 diagnosis committed in ISE; engine still crash-looping on staging-uk until this lands (or `/models/code-server` is removed by hand, which needs coordination with Cory).
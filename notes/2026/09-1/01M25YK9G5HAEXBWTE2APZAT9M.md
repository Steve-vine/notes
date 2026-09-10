---
id: 01M25YK9G5HAEXBWTE2APZAT9M
created: 2026-09-10T15:22:20.549455Z
updated: 2026-09-10T15:34:27.703045Z
type: task
title: The first release failed copying to GHCR — HTTP/2 stream resets on large blob uploads
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 663
sprint: stek6vx
comments:
- id: 01M25Z9FKQQDB9Z5YBXFVT0FH7
  author: Steve Vine
  at: 2026-09-10T15:34:27.702905Z
  text: 'PR #667 open: https://github.com/Steve-vine/compass/pull/667 — `GODEBUG: http2client=0` on the release job. Steve decided: the unpublished `v0.1.0` tag is deleted (done, 15:34; no GitHub Release existed) and will be re-cut on the fixed commit once it is on staging.'
assignee: steve
label:
- bug
priority: urgent
task_status: active
---
Release run 34494488279 (tag `v0.1.0` on f1c0a7c, 2026-09-10 15:16): every guard passed, the crane fallback download worked, then **Copy the images to GHCR** failed three times on the backend image:

```
Error: Patch "https://ghcr.io/v2/steve-vine/compass/backend/blobs/upload/…": stream error: stream ID 19; INTERNAL_ERROR; received from peer
```

Twelve blobs and the attestation manifest uploaded fine; the same large layer failed on every attempt within seconds (retries skip the already-present blobs, so they hit it immediately). GHCR is known to reset long HTTP/2 blob uploads from Go registry clients (crane, oras/helm) with exactly this error; the standard fix is to force HTTP/1.1 with `GODEBUG=http2client=0`. The g5 uplink's MTU quirk does not apply — crane runs in the runner container on the pod network, not nested in dind.

**Nothing was published**: the `0.1.0` tag was never written on GHCR (crane tags last), so the "version is unpublished" guard still passes and `0.1.0` remains the first release. Stray blobs and a `sha256-…` referrer tag exist on the (private, auto-created) `compass/backend` package — harmless; GHCR garbage-collects unreferenced blobs.

**Fix**: `GODEBUG: http2client=0` on the release job's env (covers crane and helm push alike), with a comment; keep the retry loop. The workflow file that runs is the one **at the tagged commit**, so the fix has to be on the commit that gets tagged — i.e. on main, promoted to staging, and then the tag re-cut (Steve decides: delete the unpublished `v0.1.0` and re-tag, or move to `0.1.1`).

**Acceptance**: a release run completes the copy for both images and the chart push; `crane digest ghcr.io/steve-vine/compass/backend:<version>` equals the zot `:<sha>` digest.
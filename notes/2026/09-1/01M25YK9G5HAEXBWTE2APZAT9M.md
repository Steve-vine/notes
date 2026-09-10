---
id: 01M25YK9G5HAEXBWTE2APZAT9M
created: 2026-09-10T15:22:20.549455Z
updated: 2026-09-10T17:07:46.09447Z
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
- id: 01M2610WMVYASC0GADMXFRNARG
  author: Steve Vine
  at: 2026-09-10T16:04:43.29175Z
  text: 'Second attempt (run 34497969119, HTTP/1.1 via GODEBUG) failed differently: `retrying Patch …/blobs/upload/…: unexpected EOF` at ~65 s into every PATCH, three attempts. Diagnosis: the backend image has a **204 MB layer**; this uplink pushes at ~2.2 MB/s (measured), so a monolithic upload needs ~95 s, and **ghcr.io cuts the request at about a minute**. Not the uplink: a single 200 MB upload from the same network to a Cloudflare endpoint ran 89 s to completion. crane cannot chunk uploads. Fix v2: **regctl** with `--blob-max 32MiB --blob-chunk 8MiB` (verified locally: a 60 MB blob went to zot in 8 chunks); regctl replaces crane in release.yml and the runner image. The unpublished `v0.1.0` tag will be deleted and re-cut again, per Steve''s earlier decision — still nothing under 0.1.0 on GHCR.'
- id: 01M262523JZPCP48XRDTC6XHVB
  author: Steve Vine
  at: 2026-09-10T16:24:28.530121Z
  text: 'PR #668 (regctl, chunked uploads) merged → main fab671a. Its PR run failed once on `test_frameworks.py::test_importer_fills_the_implementation_group_wherever_it_is_unset` (from COM-603, untouched by this PR) and passed on rerun — a flaky test worth its own look. Now: trunk build → promote → staging → re-tag v0.1.0 → release, chained.'
- id: 01M262DVVWX0PY31ZRQ90HDDV9
  author: Steve Vine
  at: 2026-09-10T16:29:17.052798Z
  text: 'Third attempt (run 34502212199) failed at the login step: `regctl registry set` pings ghcr.io before login and gets 401 (zot, where it was tested, allows anonymous pings). Fix: login first + `--skip-check`. Tag deleted again (still nothing on GHCR under 0.1.0). Pattern noted: three blind cycles at ~20 min each because the GHCR path can only be exercised by a real tag — consider a `workflow_dispatch` dry-run mode for release.yml that runs login + a small test blob push without tagging (follow-up).'
- id: 01M263CNY6PEX2HB9DJ75XRKMF
  author: Steve Vine
  at: 2026-09-10T16:46:06.789848Z
  text: 'Fourth attempt (run 34503772830): login fixed, guards passed, chunked copy failed on the 204 MB layer with **HTTP 416 Requested Range Not Satisfiable** — ghcr.io does not accept chunked blob uploads at all. Combined with the ~60 s cut on a single request and this uplink''s ~2.2 MB/s, no blob over ~120 MB can be pushed to GHCR from g5, by any client. Fix v3 (structural): split the release into two jobs — job 1 on `compass-runners` runs the guards and `regctl image export`s both images to an OCI tarball uploaded as a workflow artifact (GitHub''s artifact upload is chunked/resumable, no 60 s limit); job 2 on `ubuntu-latest` downloads it, `regctl image import`s to GHCR from GitHub''s network, pushes the chart, creates the Release, and verifies the GHCR digests equal the zot digests. Tag deleted again; nothing under 0.1.0 on GHCR.'
- id: 01M263JW76R1AZGFNFDNJZ22EX
  author: Steve Vine
  at: 2026-09-10T16:49:29.830537Z
  text: 'PR #670 open: https://github.com/Steve-vine/compass/pull/670 — release.yml becomes two jobs: `prepare` (compass-runners: guards + `regctl image export` → workflow artifact, digests as outputs) and `publish` (ubuntu-latest: `regctl image import` into GHCR, digest check against prepare''s outputs, chart push, GitHub Release). Export/import round trip verified locally against zot''s test path (index digest identical, both manifests carried). GODEBUG workaround removed.'
- id: 01M264MASEJ3B72F8EJ6C21C25
  author: Steve Vine
  at: 2026-09-10T17:07:46.094039Z
  text: 'Resolved: run 34505795786 on tag v0.1.0 (f1a8822, staging-20260910-1701) succeeded end to end — export on compass-runners, artifact hand-off, import from ubuntu-latest with digests verified against zot (backend sha256:0ffda759…, frontend sha256:655d5b31…), chart 0.1.0 pushed, GitHub Release https://github.com/Steve-vine/compass/releases/tag/v0.1.0. Five tag pushes in total; the first four published nothing.'
assignee: steve
label:
- bug
priority: urgent
task_status: done
---
Release run 34494488279 (tag `v0.1.0` on f1c0a7c, 2026-09-10 15:16): every guard passed, the crane fallback download worked, then **Copy the images to GHCR** failed three times on the backend image:

```
Error: Patch "https://ghcr.io/v2/steve-vine/compass/backend/blobs/upload/…": stream error: stream ID 19; INTERNAL_ERROR; received from peer
```

Twelve blobs and the attestation manifest uploaded fine; the same large layer failed on every attempt within seconds (retries skip the already-present blobs, so they hit it immediately). GHCR is known to reset long HTTP/2 blob uploads from Go registry clients (crane, oras/helm) with exactly this error; the standard fix is to force HTTP/1.1 with `GODEBUG=http2client=0`. The g5 uplink's MTU quirk does not apply — crane runs in the runner container on the pod network, not nested in dind.

**Nothing was published**: the `0.1.0` tag was never written on GHCR (crane tags last), so the "version is unpublished" guard still passes and `0.1.0` remains the first release. Stray blobs and a `sha256-…` referrer tag exist on the (private, auto-created) `compass/backend` package — harmless; GHCR garbage-collects unreferenced blobs.

**Fix**: `GODEBUG: http2client=0` on the release job's env (covers crane and helm push alike), with a comment; keep the retry loop. The workflow file that runs is the one **at the tagged commit**, so the fix has to be on the commit that gets tagged — i.e. on main, promoted to staging, and then the tag re-cut (Steve decides: delete the unpublished `v0.1.0` and re-tag, or move to `0.1.1`).

**Acceptance**: a release run completes the copy for both images and the chart push; `crane digest ghcr.io/steve-vine/compass/backend:<version>` equals the zot `:<sha>` digest.
---
id: 01M2WG0BZ7ZAN7P8E5HEZXEH4G
created: 2026-09-19T09:29:52.359185Z
updated: 2026-09-19T10:27:27.849078Z
type: task
title: Uploads over 1 MB are refused — the frontend's default body-size cap is smaller than the app's own limit
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 719
sprint: stek6vx
comments:
- id: 01M2WJVPB10B5KW3BK46HFRK2A
  author: Steve Vine
  at: 2026-09-19T10:19:44.865307Z
  text: |-
    Merged to main 2026-09-19 as a45a6d7 (PR #730). Chart: `frontend.nginx.clientMaxBodySize` defaults to 30m, with the rule in values.yaml that it sits above `MAX_UPLOAD_BYTES` and moves with it. API: one `too_large_error()` for the four upload surfaces, stating the configured limit ("That file is too large — the limit is 25 MB"). Frontend: `api/uploads.ts` reads a failed upload in one place for the four upload hooks and the two imports — the server's sentence wins, a proxy's 413 names no number (the old text claimed "max 25 MB" for a refusal at 1 MB), and unmapped failures no longer collapse to "Upload failed." — which also lets ADR 0074's "Attachments store not configured …" reach the person.

    Its first CI run failed `deps-scan` on two newly published anyio CVEs unrelated to the change — fixed as COM-726 (PR #731), then rebased and green.

    **Production**: not released. The interim fix is one line, `frontend.nginx.clientMaxBodySize: 30m`, staged (not committed) in `~/code/devops.application.compass` `envs/prod-uk-compass-app.yaml`; rendered against chart 0.3.0 the diff is that nginx line plus the checksum that rolls the frontend pods. It takes effect when Steve commits and pushes. The line can come out once a release carrying the new default is deployed.
- id: 01M2WK9TF9ZAAW0FXR0SR800DZ
  author: Steve Vine
  at: 2026-09-19T10:27:27.848896Z
  text: 'Live in production 2026-09-19: devops.application.compass 0040992 pushed, Argo CD synced `compass-prod-app`, and Steve confirmed the frontend nginx ConfigMap on env-production-uk-pri reads `client_max_body_size 30m`. The override line in `envs/prod-uk-compass-app.yaml` can be removed once a Compass release carrying the new chart default (compass a45a6d7 or later) is deployed.'
assignee: steve
label:
- bug
priority: high
task_status: done
---
Found 2026-09-16 on the env-staging-uk install and not raised at the time. **Affects production now.**

The frontend's nginx proxies `/api/*` with `client_max_body_size` from `frontend.nginx.clientMaxBodySize`, which defaults to **1m**. The API's own per-file ceiling is 25 MiB (`max_upload_bytes`). So any evidence file, uploaded document or template over 1 MB gets a 413 from nginx, the screen says "Upload failed", and the API log shows nothing because the request never reached it. Evidence is mostly PDFs; 1 MB is routinely exceeded.

**Fix**
1. Chart: default `frontend.nginx.clientMaxBodySize` to match the API ceiling with headroom for multipart overhead (e.g. `30m`), and say in `values.yaml` that the two move together.
2. Frontend: a 413 should read "That file is too large (limit N MB)", not the generic "Upload failed" — it is the one upload failure a user can fix themselves.
3. Until released: production can set `frontend.nginx.clientMaxBodySize: 30m` in `envs/prod-uk-compass-app.yaml` in the devops repo today — a values change, no release needed.

**Acceptance**: a 10 MB PDF uploads through the frontend on a default install; a 40 MB one is refused with a message naming the limit; the chart value and the API limit are documented as a pair.
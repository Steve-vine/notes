---
id: 01M2WG0BZ7ZAN7P8E5HEZXEH4G
created: 2026-09-19T09:29:52.359185Z
updated: 2026-09-19T09:34:42.644454Z
type: task
title: Uploads over 1 MB are refused — the frontend's default body-size cap is smaller than the app's own limit
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 719
sprint: stek6vx
assignee: steve
label:
- bug
priority: high
task_status: backlog
---
Found 2026-09-16 on the env-staging-uk install and not raised at the time. **Affects production now.**

The frontend's nginx proxies `/api/*` with `client_max_body_size` from `frontend.nginx.clientMaxBodySize`, which defaults to **1m**. The API's own per-file ceiling is 25 MiB (`max_upload_bytes`). So any evidence file, uploaded document or template over 1 MB gets a 413 from nginx, the screen says "Upload failed", and the API log shows nothing because the request never reached it. Evidence is mostly PDFs; 1 MB is routinely exceeded.

**Fix**
1. Chart: default `frontend.nginx.clientMaxBodySize` to match the API ceiling with headroom for multipart overhead (e.g. `30m`), and say in `values.yaml` that the two move together.
2. Frontend: a 413 should read "That file is too large (limit N MB)", not the generic "Upload failed" — it is the one upload failure a user can fix themselves.
3. Until released: production can set `frontend.nginx.clientMaxBodySize: 30m` in `envs/prod-uk-compass-app.yaml` in the devops repo today — a values change, no release needed.

**Acceptance**: a 10 MB PDF uploads through the frontend on a default install; a 40 MB one is refused with a message naming the limit; the chart value and the API limit are documented as a pair.
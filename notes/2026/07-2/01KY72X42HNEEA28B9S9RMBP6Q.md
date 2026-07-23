---
id: 01KY72X42HNEEA28B9S9RMBP6Q
created: 2026-07-23T08:54:04.113273Z
updated: 2026-07-23T09:08:58.838688Z
type: task
title: 'R2 update channel: bucket, public URL, manifest layout'
label: feature
number: 320
task_status: done
assignee: steve
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
---
The public distribution channel (DEV-658, ADR 0042): a Cloudflare R2 bucket serving update artifacts and the updater manifest anonymously over HTTPS, with the source repo staying private.

Scope:

* Create the R2 bucket and enable public access — either the [r2.dev](<http://r2.dev>) public URL or a custom domain (e.g. a subdomain of [stevevine.uk](<http://stevevine.uk>)); custom domain preferred so the endpoint in the app config never has to change.
* Decide and document the object layout, e.g. `latest.json` at the root plus versioned paths like `v0.7.0/Notuvia_0.7.0_aarch64.app.tar.gz`, the dmg, and the headless MCP tarballs.
* Define the `latest.json` shape the Tauri updater expects (version, pub_date, notes, per-platform url + signature) and check a documented example into the repo.
* Set up the upload credential (scoped R2 API token) for CI use, and a small script that uploads a release's artifacts + manifest (used by CI, and usable manually as a fallback).

Acceptance: an artifact and manifest uploaded via the script are fetchable anonymously at a stable public URL. Needs Steve for the Cloudflare account/bucket/domain steps.

---

Linear DEV-973 · Application Deployment & Update · created 2026-07-13 · done 2026-07-13
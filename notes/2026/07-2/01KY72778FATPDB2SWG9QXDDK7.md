---
id: 01KY72778FATPDB2SWG9QXDDK7
created: 2026-07-23T08:42:06.479936Z
updated: 2026-07-23T12:24:56.719325Z
type: task
title: Prebuilt Linux release artifact for notuvia-mcp
label: null
assignee: steve
task_status: done
priority: low
project: 01KY6W9951TW0904DT0GGJVGE7
number: 265
sprint: sv8tvg2
---
## Why

Headless servers currently need a Rust toolchain to build `notuvia-mcp` from source (DEV-916 / the headless setup doc). A prebuilt Linux binary (x86_64, maybe aarch64) would make server setup a download instead of a compile.

## What

* CI job (GitHub Actions) that builds `notuvia-mcp` for Linux targets on release/tag and attaches the binaries as release artifacts.
* Reuse/extend `scripts/prepare-mcp-sidecar.mjs` target-triple logic where it helps.
* Decide versioning/naming convention for the artifacts.

Follow-up / nice-to-have — building on the server works fine in the meantime.

---

Linear DEV-918 · Headless Mode · created 2026-07-09 · done 2026-07-09
---
id: 01KY72XXWC6P86XA4DVMGDCY7S
created: 2026-07-23T08:54:30.540663Z
updated: 2026-07-23T08:54:30.540663Z
type: task
title: 'Headless upgrade: notuvia-mcp self-update to a given version'
imported_from: linear
label: feature
assignee: steve
task_status: done
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 323
---
Headless installations (DEV-658, ADR 0042): servers running the MCP sidecar (ADR 0030/0036) get a one-command upgrade from the same public channel — no login, no manual tarball juggling.

Scope:

* A `notuvia-mcp self-update [--version X.Y.Z]` subcommand: defaults to the latest version from the R2 manifest, or fetches the named version's tarball for the host's platform (x86_64-musl / aarch64-gnu).
* Download from R2, verify (checksum or signature published alongside the tarball — decide in DEV-973's layout), then atomically replace the running binary (download beside it, rename over; on failure the old binary stays).
* Version match with the vault index matters (SCHEMA_VERSION hazard) — print the old → new versions and remind that live MCP sessions keep the old process until the client restarts.

Acceptance: on a Linux box with an older sidecar, `notuvia-mcp self-update` (and `--version` pinning) lands the requested build and `notuvia-mcp --version` confirms it.

---

Linear DEV-976 · Application Deployment & Update · created 2026-07-13 · done 2026-07-14
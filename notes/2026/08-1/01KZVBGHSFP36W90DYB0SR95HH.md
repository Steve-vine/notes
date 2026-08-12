---
id: 01KZVBGHSFP36W90DYB0SR95HH
created: 2026-08-12T16:04:59.82348Z
updated: 2026-08-12T16:06:01.719831Z
type: task
title: 'chore: tracked local-dev setup — build-images.sh + new-laptop bootstrap notes'
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 123
sprint: sw9wx5e
assignee: steve
imported_from: linear
label:
- chore
priority: medium
task_status: backlog
---
## Context

Surfaced during the Brief 028/029 minikube smoke test. Two local-dev setup gaps cost real time:

1. **No tracked image-build script.** The "build all local images" command list lives only in Steve's personal runbook. When Brief 028 added the `cloudflare` scanner image, there was no canonical list to update — so the new image silently never got built/loaded, and the first smoke-test trigger failed on `ErrImagePull`.
2. **New-laptop bootstrap is undocumented.** Moving to the second Mac surfaced a series of papercuts: `op` CLI not configured (`op account add` / `eval $(op signin)`), `minikube tunnel` not running (so `redvektor.local` 404s despite correct `/etc/hosts`), kubeconfig regeneration. None hard, but all undocumented and rediscovered live.

## Scope

* Add `scripts/local/build-images.sh` that **globs** `app/scanners/*/Dockerfile` plus the fixed backend/frontend images, so the scanner image list can't drift again. `--no-cache` flag passthrough; optional `minikube image load` step.
* Add a short `docs/local-dev.md` (or section in the repo README) covering new-machine bootstrap: clone path, `op` CLI setup, `minikube tunnel`, `/etc/hosts` entry, kubeconfig, the build script, and the KEK note (dev value rendered from `values-minikube.yaml`).
* Optional: a `make bootstrap` / `make images` target wrapping the above.

## Acceptance criteria

* `scripts/local/build-images.sh` builds every scanner under `app/scanners/*/` with zero hardcoded scanner names.
* A fresh-laptop developer can get to a working `redvektor.local` smoke test from `docs/local-dev.md` alone.

## References

* Brief 028 (Cloudflare Selector) — the image that drifted
* Brief 029 smoke test session — where all of this surfaced

---

Imported from Linear [DEV-231](https://linear.app/stevevine/issue/DEV-231/chore-tracked-local-dev-setup-build-imagessh-new-laptop-bootstrap)
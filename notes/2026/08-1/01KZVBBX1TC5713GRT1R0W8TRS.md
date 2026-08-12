---
id: 01KZVBBX1TC5713GRT1R0W8TRS
created: 2026-08-12T16:02:27.514499Z
updated: 2026-08-12T16:03:20.321545Z
type: task
title: Replace bitnamilegacy/kubectl with a self-managed kubectl image
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 116
sprint: sw9wx5e
assignee: steve
imported_from: linear
priority: medium
task_status: backlog
---
## Background

PR #173 swapped `bitnami/kubectl` → `bitnamilegacy/kubectl` in `chart/values.yaml` because Bitnami deprecated their free Docker Hub `bitnami/*` namespace in 2025. That fix worked, but `bitnamilegacy/*` is itself a temporary archive — Bitnami has signalled it could be retired or paywalled at any time.

We also don't control:

* The kubectl version inside the image (Bitnami picks the patch level)
* The base image, CVE patching cadence, or supply chain
* Whether the registry stays free and unauthenticated

## What needs to change

Replace `bitnamilegacy/kubectl:1.30` with `redvektor/kubectl:local` (a small image we build and version-control alongside the scanners).

### Image

* New `Dockerfile` under `app/seeds/kubectl/Dockerfile` (suggested location — sibling to `app/scanners/`).
* Base on `alpine:3.20` or `cgr.dev/chainguard/static` for size; install or copy `kubectl` only.
* Pin kubectl to a specific version (e.g. `1.30.7`) via a `KUBECTL_VERSION` ARG.
* Image should be < 60 MB.

### Build wiring

* Add `kubectl` to `VALID_IMAGES` in `scripts/bootstrap/redvektor.sh`.
* `build_image` case: build with repo root context (matches scanner pattern), or `app/seeds/kubectl/` (matches `inputs-fetcher` pattern) — pick whichever fits the Dockerfile shape.
* For minikube: `minikube image load`. For k3s: nerdctl writes direct.

### Chart

* `chart/values.yaml` engine-seeds Job: `repository: redvektor/kubectl`, `tag: local`, `pullPolicy: IfNotPresent`. Same shape as the scanner images already use, and overridable for clusters that need to pull from a registry.

### Docs

* Update `chart/README.md` to include the new image in the build list.

## Acceptance criteria

* `grep -r bitnami chart/ app/` returns no hits.
* `redvektor.sh -e <engine> -f` from a clean cluster results in `rv-redvektor-engine-seeds` Job completing without ImagePullBackOff or any external registry pull for the seed image.
* `chart/values.yaml`'s `engineController.seeds.image.repository` is `redvektor/kubectl` with `pullPolicy: IfNotPresent`.
* kubectl version is pinned and explicit (no `:latest`).

## Out of scope

* Pushing the custom image to a registry for production use (separate concern — registry strategy is decided later).
* Migrating other Bitnami images: none currently exist in the repo (verified: only `chart/values.yaml` references Bitnami).

## Related

* Surfaced from PR #173 during the DEV-289 EC2 cutover.
* Build pattern to mirror: existing scanner images in `app/scanners/{subfinder,httpx,cloudflare,nuclei}/Dockerfile`.

---

Imported from Linear [DEV-291](https://linear.app/stevevine/issue/DEV-291/replace-bitnamilegacykubectl-with-a-self-managed-kubectl-image)
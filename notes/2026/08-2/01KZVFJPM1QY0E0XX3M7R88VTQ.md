---
id: 01KZVFJPM1QY0E0XX3M7R88VTQ
created: 2026-08-12T17:16:04.609939Z
updated: 2026-08-12T17:16:04.609939Z
type: task
title: 'EC2 cutover 064: bootstrap script + cluster addons + secret manifest examples'
assignee: steve
imported_from: linear
task_status: done
priority: medium
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 328
---
First brief in the EC2 cutover sequence (Phase 5 follow-on). Establishes the new k3s instance as a reproducible target before any RedVektor code lands on it.

**Scope**

* `scripts/bootstrap/setup.sh` — idempotent install on Ubuntu 26.04 arm64:
  * OS tooling: nerdctl + BuildKit, gh, helm, uv, playwright system deps
  * Cluster addons: cert-manager, Valkey
  * Traefik already present (k3s built-in)
* `scripts/bootstrap/secrets/*.yaml.example` — …

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-282](https://linear.app/stevevine/issue/DEV-282/ec2-cutover-064-bootstrap-script-cluster-addons-secret-manifest)
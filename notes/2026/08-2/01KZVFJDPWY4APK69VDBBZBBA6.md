---
id: 01KZVFJDPWY4APK69VDBBZBBA6
created: 2026-08-12T17:15:55.484949Z
updated: 2026-08-12T17:15:55.484949Z
type: task
title: 'EC2 cutover 066: chart values-k3s + dev.redvektor.net + cert-manager DNS-01 + URL refactor'
assignee: steve
priority: medium
task_status: done
imported_from: linear
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 326
---
Third brief in the EC2 cutover. Makes the Helm chart deploy cleanly on k3s and exposes RedVektor at `dev.redvektor.net` with real TLS.

**Scope**

* **New** `chart/values-k3s.yaml` — k3s-specific overrides:
  * Ingress class `traefik`, host `dev.redvektor.net`
  * Storage class `local-path` (k3s default)
  * Service types ClusterIP (no LoadBalancer / `minikube tunnel` dependency)
  * References the externally-applied secrets from Brief 064 (`red…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-284](https://linear.app/stevevine/issue/DEV-284/ec2-cutover-066-chart-values-k3s-devredvektornet-cert-manager-dns-01)
---
id: 01KZVFJJB2S21SYDD81WV5XFZH
created: 2026-08-12T17:16:00.226261Z
updated: 2026-08-12T17:16:00.226261Z
type: task
title: 'EC2 cutover 065: image build for k3s (nerdctl/BuildKit) + ADR 033'
task_status: done
assignee: steve
imported_from: linear
priority: medium
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 327
---
Second brief in the EC2 cutover. Replaces minikube-specific image-load mechanic with k3s-native build/import so the rest of the cutover (deploy, smoke, Code on EC2) has a working build path.

**Scope**

* `scripts/redvektor.sh` and any other build scripts adapted from `docker build → minikube image load` to `nerdctl build → ctr -n k8s.io images import` (or BuildKit equivalent — decision documented in ADR 033)
* Both minikube and k3s paths suppor…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-283](https://linear.app/stevevine/issue/DEV-283/ec2-cutover-065-image-build-for-k3s-nerdctlbuildkit-adr-033)
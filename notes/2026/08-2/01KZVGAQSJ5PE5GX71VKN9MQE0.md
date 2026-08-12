---
id: 01KZVGAQSJ5PE5GX71VKN9MQE0
created: 2026-08-12T17:29:12.242033Z
updated: 2026-08-12T17:29:12.242033Z
type: task
title: Brief 007 — Helm chart templates + minikube deploy
imported_from: linear
label: brief
assignee: steve
task_status: done
priority: medium
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 401
---
Frontend nginx Dockerfile, backend Dockerfile rewritten for `app/` build context, full Helm chart (API/Worker/Beat/Frontend Deployments + Services + Ingress + ConfigMap + Secret toggle for ESO + CNPG `Cluster` CR + Valkey StatefulSet + cert-manager TLS toggle + `pre-install` migration hook), multi-namespace RBAC for the worker. **Seven post-submission live-verification fixes**. Verified end-to-end via Helm-deployed platform.

**Brief spec:** [do…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-12](https://linear.app/stevevine/issue/DEV-12/brief-007-helm-chart-templates-minikube-deploy)
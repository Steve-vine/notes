---
id: 01KZVFFQSSWDTNG4XK1Y874DBY
created: 2026-08-12T17:14:27.513008Z
updated: 2026-08-12T17:18:23.835268Z
type: task
title: 'EC2 setup.sh: fix default `KUBECONFIG` so ubuntu''s `kubectl` doesn''t need a workaround export'
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 319
sprint: ssxh43d
assignee: steve
imported_from: linear
label: null
priority: low
task_status: done
---
## Surfaced by DEV-285 (Brief 067 smoke run)

On the EC2 dev cluster host (`172.20.11.163`), the `ubuntu` user's default `kubectl` cannot reach the cluster:

```
$ kubectl get pods -n redvektor
time="..." level=warning msg="Unable to read /etc/rancher/k3s/k3s.yaml, please start server with …

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-295](https://linear.app/stevevine/issue/DEV-295/ec2-setupsh-fix-default-kubeconfig-so-ubuntus-kubectl-doesnt-need-a)
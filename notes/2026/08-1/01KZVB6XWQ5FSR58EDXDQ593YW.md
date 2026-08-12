---
id: 01KZVB6XWQ5FSR58EDXDQ593YW
created: 2026-08-12T15:59:44.53564Z
updated: 2026-08-12T16:00:58.044213Z
type: task
title: Set up GitHub OIDC federation to AWS IAM for ECR pushes
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 108
sprint: sw9wx5e
assignee: steve
imported_from: linear
label:
- chore
priority: medium
task_status: backlog
---
Blocks real image builds in CI. Placeholder `id-token: write` declared in `build.yml`, but no IAM role or OIDC trust set up. Was a Brief 007 prerequisite assumption that turned out not to block (chart works fine with `minikube image load`); now resurfaces as a blocker for the eventual ECR-push brief. One-off click-through in AWS console + GitHub repo settings.

Source: Obsidian Issues Tracker #7 (P3 Medium, Open).

---

Imported from Linear [DEV-20](https://linear.app/stevevine/issue/DEV-20/set-up-github-oidc-federation-to-aws-iam-for-ecr-pushes)
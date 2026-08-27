---
id: 01M11ZFRMZBK6QRZP3P884M27K
created: 2026-08-27T16:05:14.015727Z
updated: 2026-08-27T16:05:19.887289Z
type: task
title: A new Kubernetes release stops the staging deploy dead
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 466
sprint: s5gwx0s
assignee: steve
company:
- moneypenny
label:
- bug
priority: high
task_status: active
---
The staging deploy failed twice in a row on `DownloadKubectlFailed`, before touching the cluster. Nothing was half-applied — the run dies at the setup step — but nothing can be released until it is fixed.

## What happened

`azure/setup-kubectl` in the deploy job names no version, so it takes **latest**. Kubernetes published **v1.37.0** today, `latest` moved to it, and that binary is serving badly from the CDN: connection reset after two seconds, zero bytes, repeatedly. The previous version downloads perfectly — 59.5 MB at 4.9 MB/s in twelve seconds — so this is not the LAN and not throughput.

The deploy that ran an hour earlier succeeded on the same runners. The only thing that changed is upstream.

## What changes

**The deploy stops depending on what Kubernetes released this morning.** `kubectl` is pinned to the version the cluster actually runs, so a fresh upstream release cannot take staging out again.

## Scope

`azure/setup-kubectl` in the `deploy-staging` job: pin `version` to the cluster's server version (k3s currently reports `v1.36.2+k3s1`, so `v1.36.2`). This is also the correct answer on version-skew grounds — kubectl is supported within one minor of the server, and unpinned it will eventually drift further than that.

`azure/setup-helm` alongside it has the identical hazard for the identical reason, and should be pinned in the same pass rather than waiting for the next Helm release to prove the point.

The version now needs bumping when the cluster is upgraded. That is the trade, and it is the right way round: an explicit bump beats an unannounced one that only shows up as a failed release.

## Worth noting

This is the same rule the repo already applies to images — no `latest` tags, immutable `<branch>-yyyymmdd-hhmm` (ADR 0008) — not carried through to the tools that do the deploying.

`auto-rerun.yml` does not cover this: it only watches PR and `main` runs, and staging is neither. A retry would not have helped anyway; the failure is reproducible.
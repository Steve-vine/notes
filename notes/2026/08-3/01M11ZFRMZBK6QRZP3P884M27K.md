---
id: 01M11ZFRMZBK6QRZP3P884M27K
created: 2026-08-27T16:05:14.015727Z
updated: 2026-08-27T16:38:56.81213Z
type: task
title: A new Kubernetes release stops the staging deploy dead
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 466
sprint: s5gwx0s
comments:
- id: 01M121DG1CBJXPM74XRTF91AQ1
  author: Steve Vine
  at: 2026-08-27T16:38:56.811952Z
  text: |-
    Correction: the diagnosis in this task and in PR #446 is wrong, and the pin does not fix the deploy.

    I claimed v1.37.0 was serving badly and the previous version was fine. That was two samples read as a pattern. Repeated three times each, v1.37.0 downloads perfectly — 200, the full 61.9 MB. Both versions are simply slow, 22-28s for ~60 MB, and both intermittently fail.

    What exposed it: with kubectl pinned, the very next deploy failed on **helm** instead, at v4.2.4 — the exact version that had downloaded successfully forty minutes earlier, from a different host (get.helm.sh). Same version, same host, different outcome. That is intermittent, not a bad release.

    Verified separately that general cluster egress is healthy: from a compass-api pod, both get.helm.sh and dl.k8s.io respond immediately. So this is specific to the runner pods and their download path, not the LAN as a whole and not upstream.

    The real problem: every staging deploy re-downloads ~60 MB of kubectl and ~20 MB of helm on a marginal link, and the setup actions exhaust their internal retries often enough to block releases. A retry does work — the deploy went green on the next attempt and staging is now on staging-20260827-1637 — but "retry until it lands" is not a deploy process.

    What is worth keeping from #446: the pin itself, on version-skew grounds. kubectl should track the cluster's server version, and unpinned it drifts past the supported one-minor window on its own. That is a good reason. It is just not the reason I gave, and it is not a fix for this.

    Leaving this task open and reframing it: the fix is to stop downloading these on every deploy — cache the tool directory, or bake kubectl and helm into the runner image (the stock ARC image ships neither, which is why the setup actions are there at all). Either removes the download from the critical path entirely rather than making it marginally more likely to succeed.

    Also still true and worth fixing alongside: auto-rerun.yml does not cover staging runs — it watches PR and main only — so every one of these needs a human to notice and re-run.
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
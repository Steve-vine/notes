---
id: 01M11ZFRMZBK6QRZP3P884M27K
created: 2026-08-27T16:05:14.015727Z
updated: 2026-09-01T13:55:51.618944Z
type: task
title: The staging deploy re-downloads 80MB of tooling every time, and often fails doing it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 466
sprint: snq23hz
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
- id: 01M14Z63Z1KD71R55MWKF573QB
  author: Steve Vine
  at: 2026-08-28T19:57:41.217366Z
  text: |-
    Merged as PR #483 (`bce4554`).

    **The deploy no longer downloads its tools.** kubectl and helm are baked into the runner image — the answer COM-327 gave for uv and Node, for the same reason. Versions sit in the Dockerfile beside `UV_VERSION` and `NODE_VERSION`, with `KUBECTL_VERSION` tracking the k3s server version: v1.36.2 today, helm v4.2.4.

    **Why the previous attempt did not work.** Pinning the versions (PR #446) fixed the wrong thing, on the wrong reasoning. Both kubectl versions download fine when retried, and helm v4.2.4 *succeeded and failed thirty minutes apart from the same host*. Making the download at all was the problem. The pin stays on its own merits — kubectl is supported within one minor of the API server and drifts past that unpinned.

    **The workflow prefers what the image carries and only fetches if it is absent.** Deliberate rather than belt-and-braces: releasing no longer depends on *which* runner image is live, so rolling the scale set forward or back cannot break a deploy. Once every runner carries the tools the fallback never fires and can be deleted.

    **auto-rerun now covers staging.** It was excluded because "that path builds and deploys" — but since COM-334 it builds nothing, and every step is idempotent: promoting a tag copies a manifest server-side, `helm upgrade` converges, the rollout and smoke checks only read. The signature gate still applies, so a deploy that failed for a real reason is never rerun; only one that died fetching something is. Before this, every download blip needed a human to notice a release had simply not happened.

    Also added npm's `Exit handler never called!` to the signature list. It took out `deps-scan` on this very PR while the branch was in flight, and again on COM-477's — the one shape from this uplink's family auto-rerun could not see.

    ## One step outstanding — it needs Steve

    The image is built, pushed and verified: `zot.citops.net/compass/ci-runner:2.336.0-20260828-1906`, carrying kubectl v1.36.2, helm v4.2.4, node 22.23.2 and uv 0.11.26. `arc-compass-runners-values.yaml` points at it.

    Rolling the scale set onto it is a `helm upgrade` in `arc-runners`, which this session was not permitted to run:

    ```
    helm upgrade compass-runners \
      oci://ghcr.io/actions/actions-runner-controller-charts/gha-runner-scale-set \
      --version 0.14.2 -n arc-runners \
      -f scripts/infra/arc-compass-runners-values.yaml --reuse-values
    ```

    Until that runs, the runners keep the old image and the fallback does the fetching exactly as today — so merging changed nothing about deploy reliability yet. Worth running while CI is idle; it recycles the runner pods.
assignee: steve
label:
- bug
priority: high
task_status: done
---
The staging deploy fails intermittently at the setup step, before touching the cluster. It failed three times in one afternoon — twice on `kubectl`, once on `helm` — each time dying on the download. Nothing is ever half-applied, but nothing can be released until someone notices and re-runs it.

## What is actually happening

The stock ARC runner image ships neither `kubectl` nor `helm`, so `azure/setup-kubectl` and `azure/setup-helm` fetch them on **every deploy**: roughly 60 MB and 20 MB, over a link that manages 22–28 seconds per download on a good run. The actions retry internally three times and then give up, often enough to block a release.

It is not a bad upstream version, and not the LAN as a whole:

- Both `v1.37.0` and `v1.36.2` of kubectl download fine when retried — three attempts each, full payload, 200.
- Helm `v4.2.4` succeeded at 16:01 and failed at 16:31 — same version, same host.
- From a `compass-api` pod, both `get.helm.sh` and `dl.k8s.io` respond immediately, so general cluster egress is healthy. This is specific to the runner pods' download path.

## What changes

**A deploy stops depending on an 80 MB download succeeding.** The tools are already there, so the setup step is instant and cannot fail this way.

## Scope

Either of two approaches, whichever fits the ARC setup better:

- **Cache the tool directory** (`actions/cache` over `_work/_tool`), so only the first deploy after a runner image change pays for the download; or
- **Bake `kubectl` and `helm` into a custom runner image**, which removes the download entirely and drops both setup actions.

Keep the version pinning that PR #446 added either way. It was the wrong fix for this problem and the reasoning in that PR is wrong — see the correction in the comments — but pinning is right on its own terms: kubectl is supported within one minor of the server, and unpinned it drifts past that on its own. The versions then need bumping when the cluster is upgraded, which is the right way round.

## Worth fixing alongside

`auto-rerun.yml` does not cover staging runs at all — it watches PR and `main` — so every one of these failures needs a human to spot it and re-run by hand. A deploy that fails on a download is exactly the infrastructure signature that job exists to absorb.
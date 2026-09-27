---
id: 01M3H6WWZZ3YX4SRVZ8X91Y6HC
created: 2026-09-27T10:34:44.607688Z
updated: 2026-09-27T12:09:33.532089Z
type: task
title: The chart offers an optional network add-on — any sidecar, DNS and volumes on the pods that talk to the directory
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 774
sprint: sme8esk
blocked_by:
- 01M3H6WFYD0APAYJZEZYSG6S25
comments:
- id: 01M3HCAFR0X39MR39EPG2PA56Z
  author: Steve Vine
  at: 2026-09-27T12:09:32.672687Z
  text: |-
    Done: PR #784, merged to main (7ca842f).

    The chart has a new optional **network add-on** (`networkAddon`), off by default, naming no product. When it's on, you can add any of these to the worker pod (or to api or beat if you list them):
    - a sidecar container, or an init container
    - volumes, and mounts into Compass's own containers
    - extra environment variables for Compass's containers (e.g. a proxy address)
    - pod annotations and labels
    - host-name entries or DNS settings (`hostAliases`, `dnsPolicy`, `dnsConfig`)

    Details:
    - A sidecar keeps its own security settings. Compass's locked-down defaults are never applied to it.
    - A misspelt target stops the install with a clear message.
    - With the add-on off, the chart output is byte-for-byte the same as before (checked for the default, staging and S3 setups).
    - CI now renders a complete add-on example on every chart change.
    - The chart README has a new "Network add-on" section: an example, what a kernel-mode tunnel needs from Pod Security Admission (and the userspace/proxy alternative), and four ways to make a domain controller's name resolve.

    **Not done yet: the staging part.** Your Twingate sidecar on staging needs a Secret on g5 holding its credentials. It is set in `values-staging.yaml` and is yours to decide. Once it's in place I'll wire the add-on on staging, and COM-776's Test connection proves the route.
assignee: steve
label:
- feature
priority: high
task_status: review
---
Part of the on-premises AD sprint (ADR in COM-773).

Compass has to reach the domain controllers from inside the cluster. **How** is the operator's decision: a VPN or zero-trust sidecar, or nothing at all because the route already exists. The chart offers a generic, **off-by-default** add-on for this: extra containers, init containers, volumes, environment, DNS settings and host aliases, applied to the pods that talk to the directory. It names no product and depends on none. The README shows one example shape.

Steve's own setup (a Twingate sidecar) lives in his values, not in the chart.

## Notes (technical)

- Today the chart has only `extraEnv`: no `extraContainers`, `initContainers`, `extraVolumes`/`extraVolumeMounts`, `podAnnotations`/`podLabels`, `hostAliases` or `dnsPolicy`/`dnsConfig`.
- **Shape**, following the chart's conventions: opt-in and verbatim YAML.
  ```yaml
  networkAddons:
    targets: [worker]      # api | worker | beat
    containers: []         # own securityContext — NOT merged with containerSecurityContext
    initContainers: []
    volumes: []
    volumeMounts: []       # into the app containers, if needed
    env: []                # e.g. ALL_PROXY for userspace modes
    podAnnotations: {}
    podLabels: {}
    hostAliases: []
    dnsPolicy: ""
    dnsConfig: {}
  ```
  One helper, in the manner of `compass.sized`, included from `api/worker/beat` deployments, with a `tpl` pass on `containers`.
- **Only the worker needs reach** if *Test connection* runs on the worker (COM-773). Sync runs on `default` and writes on `execution`, both in the worker pod, so one sidecar serves both.
- **Volumes.** `worker/deployment.yaml:135` renders `volumes:` only when storage is mounted. Rework it so it renders when storage **or** addon volumes exist.
- **securityContext / PSA.** The pod sets `runAsNonRoot: true`. A kernel-mode tunnel needs a container-level override (`NET_ADMIN`, often `/dev/net/tun`), which a namespace enforcing PSA baseline or restricted refuses. Document this in `chart/README.md`, along with the userspace/proxy alternative.
- **DNS.** Resolving a DC by name comes from the addon's own DNS, `dnsConfig`, `hostAliases`, or a cluster-level CoreDNS stub zone. Document all of them.
- **CI.** Add `chart/ci/network-addon-values.yaml` (a generic sidecar referencing an existing Secret) to the `helm lint`, `kubeconform` and immutable-fields runs, so the conditional path is exercised (the ADR 0073 warning). Watch the Helm 4 `nil` quirk.

**Done when:**
- With defaults, the render is unchanged.
- The CI shape renders and passes kubeconform.
- On staging, a sidecar in the worker pod lets the worker resolve and reach a domain controller.
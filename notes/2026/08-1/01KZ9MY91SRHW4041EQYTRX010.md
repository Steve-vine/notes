---
id: 01KZ9MY91SRHW4041EQYTRX010
created: 2026-08-05T19:03:27.03331Z
updated: 2026-08-13T19:00:06.918089Z
type: task
title: Facts sync, liveness and entity binding — servers become estate entities
project: 01KX671DATY39VW6GWK3M2T3DN
number: 565
sprint: sesjg7z
comments:
- id: 01KZGN3STRMJXX9TB0F25S6VG2
  author: Steve Vine
  at: 2026-08-08T12:21:09.080384Z
  text: |-
    DONE — merged to main 2026-08-08 as `c48ede7` (PR #549), CI green.

    Registered servers now join the estate, keep themselves alive, and raise an Observation when they stop answering.

    **Binding — the acceptance criterion**

    A registered machine publishes the keys other sources already know it by: the deliberately unscoped `k8s:node:<hostname>` (which EC2 emits as its private DNS name and Azure as its computer name), `datadog:host:<hostname>` (the join that makes the unknown-asset back-fill re-link existing DD alerts), and the ADR 0082 `dns:` alias. So registering an EC2 instance lands on its **existing `host` entity** and gains the in-OS attributes there. One machine, one row, both views — asserted by a test that fails if a second entity appears.

    The reported FQDN is published alongside the registered spelling: an operator registers `app-01` while DataDog knows `app-01.internal`, and stating only one leaves the join to luck.

    Routed through `discovery.reconcile_discovered` rather than creating entities directly. The status-page register makes its own rows and is the wrong model here — binding, aliases, merge-on-collision, naming and retire/unretire all already live in discovery, and a second implementation of any of them would drift.

    **Two judgement calls you may want to overturn**

    1. **A bound cloud VM keeps type `host`; only machines nothing else knew about become `server`.** That is what "bind, never duplicate" forces, but it means an estate query for "all machines" needs both types. I did not widen it into a retype of every EC2 instance without asking — say the word if the split grates in use.
    2. **Only CONTACTED servers reach the estate.** A registration is your assertion that a machine exists; a contact is ISE's own evidence of one. Minting from the first would put a typo in the estate permanently.

    **Unreachability**

    Observation, never Alert — a server has no detection layer to defer to. A single failed contact raises nothing, which is why the register counts *consecutive* failures rather than comparing timestamps: "unreachable since" cannot tell one bad minute from a week of downtime. The count is a declared ThresholdSpec (default 3, ONE rung — "unreachable" has a single meaning, and inventing warn/critical bands out of arithmetic on one number is how a config surface becomes unusable), so a flaky VPN link and a datacentre LAN can ask for different patience without a release.

    **Migrations 0110** (`consecutive_failures`, backfilled to 0 — a server already unreachable has an unknown history, and inventing one would fire or suppress a signal on a number nobody measured) and **0111** (widens the `entity.type` constraint; downgrade retypes to `host`, not `other`).

    **UI**: in-OS facts card on the entity page, rendering identically for an on-prem server and a bound cloud VM — the visible payoff of binding. Fleet rows gain the estate link, last-contact freshness, and the failing-but-not-yet-raised count.

    **CI note**: `backend-lint` went red once on `setup-uv` failing to fetch its manifest — a network fault in the install step, so ruff/mypy never ran. Re-ran the same commit and it passed. Worth recognising the shape rather than reading it as a code signal.

    **Still needs the smoke test**: the acceptance points that need live data — an EC2 instance showing AWS + in-OS facts on one entity, and an unreachable server producing an Observation that resolves on recovery — can only be proven against the real estate. That is what the staging push is for.
- id: 01KZGQFNP903SCES9Q8W8STXXK
  author: Steve Vine
  at: 2026-08-08T13:02:35.209757Z
  text: |-
    FIX-FORWARD after deploy — PR #550, merged as `b626c45`, staging redeployed and verified.

    Checking the deployed content rather than the run colour caught a fault that would have made **every preflight in the estate fail** before it reached your smoke test.

    The worker pod runs with `HOME=/`:

    ```
    $ kubectl exec -n ise deploy/ise-worker -c worker -- sh -c 'echo "HOME=[$HOME]"; id'
    HOME=[/]
    uid=10001 gid=10001

    $ kubectl exec ... -- /app/.venv/bin/ansible --version
    ERROR: Unable to create local directories '/.ansible/tmp': Permission denied
    ```

    A Kubernetes `runAsUser` overrides the image's `USER ise` and nothing re-exports a home directory. Two things break, and both would have read as the server's fault: ansible-core dies creating `~/.ansible/tmp` before dialling anything, and OpenSSH cannot write the `~/.ssh/known_hosts` that `StrictHostKeyChecking=accept-new` needs on first contact — which surfaces as an auth failure. Every row would have gone `unknown` with a message about a directory: exactly the bare-failure shape ISE-564's categorisation exists to prevent.

    Fixed in the connector rather than the Helm chart. A connector that only works under one deployment's environment breaks the next time someone tightens a security context, and the per-run temp directory is already created, already removed in a `finally`, and already the right lifetime for a `known_hosts` file nothing should keep. `runner_env()` points HOME, ANSIBLE_HOME and ANSIBLE_LOCAL_TEMP into it.

    Verified in the running pod after redeploy: `ansible [core 2.21.2]`, rc 0.

    **Deployed state confirmed on staging** (`b626c45`, image `staging-20260808-1258`): alembic at 0111, `registered_server` and `server_connection_profile` present and empty, the Servers connector registered with `['entities', 'observations', 'servers']` and its `sync-server-facts` sweep declared, ansible-runner + pywinrm + pykerberos all importable, and all six `/api/v1/servers*` routes served.
assignee: steve
label: null
priority: high
task_status: done
tech: null
---
Registered servers become living estate entities (ADR 0084 §read-state). Depends on ISE-564.

**Sync (read-state)**
- Scheduled **identity-facts slice** per registered server via ansible-runner (`setup` / `gather_facts` subset): OS/distribution + version, kernel, addresses, virtualization type, hardware summary. Slow schedule; a successful run is the **liveness sighting** that keeps the entity alive (Canon entity lifecycle). No volatile facts (uptime, memory-free) in the snapshot — churn is counted, not reported.
- **Entity minting/binding**: on-prem servers mint a `server` entity; servers matching an existing cloud entity (EC2 instance, Azure VM) **bind to it** — one entity carrying both cloud and in-OS facts, never a duplicate. Keys join on **hostname** (K8s-node precedent — the DataDog join key), so the unknown-asset back-fill re-links existing DD alerts to the new entities; verify that re-link against staging live data as an explicit acceptance step.
- ENTITY_TYPES change (new `server` type) ⇒ **OpenAPI snapshot reddens on this branch** — regenerate api-types on the feature branch (EntraID-sprint precedent).

**Detect**
- **Observations, never Alerts** (no native detection layer): a server unreachable past a configurable threshold of consecutive failed contacts raises an Observation; recovery resolves it. Single failed contact raises nothing.

**Frontend**
- Fleet list rows gain last-sighting staleness treatment (standard estate staleness UX).
- Entity detail page gains an **in-OS facts card** (works identically for bound cloud entities and on-prem servers).

**Acceptance**: register an EC2 instance → same entity now shows AWS + in-OS facts, no duplicate; an on-prem server appears in the estate; unplugging a test server (or blocking its port) yields a categorised unreachable state and, past threshold, an Observation that resolves on recovery.
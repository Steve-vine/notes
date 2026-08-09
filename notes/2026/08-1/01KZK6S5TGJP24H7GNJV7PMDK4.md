---
id: 01KZK6S5TGJP24H7GNJV7PMDK4
created: 2026-08-09T12:08:24.144019Z
updated: 2026-08-09T13:33:47.668001Z
type: task
title: Every connector that mints a machine must record its OS
project: 01KX671DATY39VW6GWK3M2T3DN
number: 622
sprint: sesjg7z
comments:
- id: 01KZKBNC3DFHRKHX86WW3478SC
  author: Steve Vine
  at: 2026-08-09T13:33:42.381673Z
  text: |-
    BUILT + MERGED to main 2026-08-09 — PR #566, `feature/ise-622-machine-os-attribute`.

    **The canonical key is `os_family`**, defined once as `connectors.base.OS_FAMILY_ATTRIBUTE`, alongside a single normaliser `os_family_from()`. One normaliser for the same reason `dns_key` is one function: two normalisations is the failure mode, and here the two sides are "what a connector wrote" and "what the coverage queue reads".

    **Surfaces covered — audited, not assumed.** Every `type="host"` site in the tree:

    | Connector | Field it was parsing and dropping |
    |---|---|
    | AWS EC2 | `PlatformDetails`, then `Platform` |
    | Azure VM / VMSS | `storageProfile.osDisk.osType`, then `imageReference`, then the scale set's own `virtualMachineProfile` |
    | Kubernetes nodes | `status.nodeInfo.operatingSystem`, then `osImage` |
    | **DataDog hosts** | `meta.platform`, then an `os:` tag — not on your list, found by the audit. Often the only source that sees an on-prem or third-party host at all |
    | Servers | already recorded it, under `server_os_family` — a name only it used. Renamed onto the canonical key; nothing else read the old one |

    Hyper-V guests still record nothing, as specified: a hypervisor knows a guest's name and power state, not what it runs.

    **Two rules that fell out of the build and are worth keeping:**

    1. **Only when the source really said.** `os_family_from` returns None for anything unrecognised — no default, no "probably Linux". Same reason as the queue's existing behaviour: the wrong pick dials SSH at a WinRM listener and fails as `auth_refused`.
    2. **Absent, not None.** `reconcile_discovered` merges attributes key by key, so writing `os_family: None` would *overwrite* a real answer from a source that bound onto the same entity. A connector that cannot say writes no key at all.

    **`servers_coverage` reads it into `os_family`** for cloud candidates, which was hard-coded `None` — so every cloud VM was making the operator declare a platform ISE had already been told.

    Tests are in `tests/test_machine_os.py` — the rule in one place, since it is one rule. Fixture strings taken from live payloads (`"Linux/UNIX"`, `"Ubuntu 22.04.3 LTS"`, `meta.platform`), explicitly not from what would be convenient to assert.

    Sequenced before ISE-624 as you specified: with one machine type this attribute is the only way to tell Windows from Linux, so 622 is what makes that collapse safe.
assignee: steve
label:
- improvement
priority: medium
task_status: review
---
Found on the ISE-621 smoke test, 2026-08-09; **widened by Steve the same day** from "AWS and Azure" to every scan surface. Linux and Windows can turn up on any of them, so the OS is not a cloud-provider detail — it is a property of a machine that ISE should always know.

Live counts that exposed it:

```
arc       os_family=windows   39
entra     os_family=windows   1114
azure_vm  os_family=None      12    <-- every one
```

**The rule this task establishes:** anything that creates a machine entity records its operating system as an entity attribute, under ONE canonical key, so every consumer reads the same thing regardless of which integration saw the machine first. Without a canonical key each connector invents its own and the reading side is back to per-source parsing — which is the shape of problem [ISE-620] was, in a different costume.

**Surfaces to cover** (audit rather than assume — this list is a starting point):

- **AWS EC2** — `PlatformDetails` / `Platform` is in the payload `aws.py` already parses, and is dropped.
- **Azure VMs and VMSS instances** — `properties.storageProfile.osDisk.osType`, likewise parsed and dropped.
- **Kubernetes nodes** — `status.nodeInfo.operatingSystem` and `osImage`. Windows node pools exist and would be indistinguishable today.
- **Servers connector** — already records it from the identity facts gather. It is the model the others should match, not an exception.
- Anything else that mints a machine — the audit is part of the work.

**Why it matters twice over.** For discovery, the operator has to declare the platform at Manage time for every cloud VM, and a wrong pick is the most expensive mistake this integration allows: a Linux profile on a Windows machine dials SSH at a WinRM listener and fails as `auth_refused`, sending someone to check an account that was never the problem. For the estate, ISE cannot currently answer "which of our machines are Windows" — a question a single pane of glass should not have to punt on, and one whose answer is already inside payloads ISE parses.

**Sharper still after the entity-type collapse** (see the `server`→`host` task): with one machine type, the OS attribute becomes the *only* way to tell a Windows machine from a Linux one. Ordering matters — this is what makes that collapse safe.

**Scope**: connectors record it; `servers_coverage` reads it into `os_family` the way it already reads Arc's and Entra's. Candidates that genuinely cannot say keep today's behaviour — make a human choose, never guess.
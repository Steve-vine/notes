---
id: 01KZK6S5TGJP24H7GNJV7PMDK4
created: 2026-08-09T12:08:24.144019Z
updated: 2026-08-09T13:00:07.756687Z
type: task
title: Every connector that mints a machine must record its OS
project: 01KX671DATY39VW6GWK3M2T3DN
number: 622
sprint: sesjg7z
assignee: steve
label:
- improvement
priority: medium
task_status: todo
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
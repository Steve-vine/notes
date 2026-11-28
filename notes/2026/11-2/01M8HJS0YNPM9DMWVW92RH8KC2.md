---
id: 01M8HJS0YNPM9DMWVW92RH8KC2
created: 2026-11-28T17:20:49.621813Z
updated: 2026-11-28T17:20:55.436074Z
type: task
title: 'Two servers sharing a hardware identity are never merged: a second server whose identity matches a reporting server under another name waits to join, saying why'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2238
sprint: smfrbak
assignee: steve
label:
- bug
priority: high
task_status: active
---
**On the chain** (joining logic; no migration expected). Found in the pre-UAT pass of sprint 130 (28 Nov). Fix forward for COM-2204 (ADR 0187 §4).

## What went wrong
On staging, the two test servers (srv-rig-ubuntu and srv-rig-rocky) both waited to join. Accepting both put them on **one** entry: srv-rig-ubuntu shows as reporting for srv-rig-rocky, and Rocky's build reads Ubuntu's. osquery identifies a server by its hardware UUID (`--host_identifier=uuid`); both containers run on the same physical machine, so both sent the same UUID, and Compass took the second for the first.

Real servers each have their own UUID, but **cloned virtual machines can share one** (a template's SMBIOS UUID copied), so this isn't only a test-rig problem.

## What people see after the fix
- A server whose hardware identity matches a server already known to the agent **under a different host name** is never merged with it. It waits to join with the reason "Shares its hardware identity with srv-rig-rocky — a cloned machine? Accept it as a server of its own, or refuse it."
- **Accept** makes it a server of its own (its own entry, its own facts and software); the first server is untouched.
- The same server re-joining under its own name (a reinstall, a new joining code) still finds its own entry, as now.

## Notes (technical)
- `joining._own_resource` keys a non-directory server's entry on `host_identifier` alone; `_reporting(host=…)` finds "the first" by host identifier too. Key the agent's own entry on identifier + host name, and treat "same identifier, different name" as a waiting reason rather than a claim on the reporting one.
- Rig: the staging test servers identify themselves distinctly (`--host_identifier=hostname` in `scripts/infra/server-agent-test.yaml`).
- Repair staging: remove the merged nodes and let the rig re-join.

**Done when:** in CI, two nodes sharing a UUID with different host names give two entries (the second waits with the reason, and Accept makes it its own); on staging both test servers report on entries of their own with their own operating systems.
---
id: 01M8FATKBRPVSNTVEM5E7C89ZT
created: 2026-11-27T20:23:23.768165Z
updated: 2026-11-27T20:25:13.980286Z
type: task
title: 'Inventory from the agent: a reporting server''s operating system, hardware, addresses and installed software arrive every 6 hours and on Read now, on the same entry the directory found'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2205
sprint: smfrbak
assignee: steve
label:
- feature
priority: high
task_status: todo
---
**On the chain** (API, possibly a migration for new facts). ADR 0187 §5, §6. After COM-2204.

## What people see
- On a **discovered server** and its **technology asset**, a **Reporting through the agent** line: "osquery 5.x · last seen 4 minutes ago" (or Not reporting / Out of date, from COM-2204).
- The server's facts fill in from the agent: **operating system** with version, build and revision; install date; last boot; **maker, model, serial number, CPU, memory**; **IP addresses** (into the asset's IP addresses, as discovery does today).
- **Installed software**: where the server read "Installed software: not reported", it now lists what's installed (Windows programs, Linux packages), marked **Found by the agent**. It appears on **Discovered ▸ Software** and the asset's Software tab like any other source's, support dates fill in, and the asset's support follows the worst-of rule (ADR 0150). Updates and hotfixes don't appear here (they're the patch level, COM-2206).
- **Read now** on the agent connection asks every reporting server at its next check-in (within 5 minutes); otherwise every 6 hours.
- An uninstalled program disappears at the next read; an upgrade moves to the new version (ADR 0114 §1: the list is replaced whole).

## Notes (technical)
- Use **distributed queries** for collection: Compass queues the inventory query set per node (every 6 hours from Celery beat, and on Read now) and the node picks them up on its next distributed read; results arrive on distributed write. Celery task idempotent, takes IDs; label in `core/task_labels.py`.
- Queries (Windows): `system_info`, `os_version` (incl. `revision`/UBR), `kernel_info`, `uptime`, `interface_addresses`, `programs`; Linux: `deb_packages`/`rpm_packages`. Keep them in one code-defined set (ADR 0187 §5; no service names, so ADR 0147 §9 holds).
- Write through **`core/discovery/sync.py upsert()`** with `Found.software` populated, `found_by = "agent"`, so `software.record()` and `installed.normalise_all()` (update filter) apply unchanged. A matched node writes onto the directory's `DiscoveredResource` (provider stays `directory`); facts merge, they don't replace the directory's own.
- Results larger than a sane cap per node are refused and recorded as an error on the node (health).
- Polaris reads are COM-2209.

**Done when:** on staging, the test-rig (COM-2208) agent's server shows its OS, hardware, addresses and installed packages within 5 minutes of Read now; a package removed in the container is gone after the next read; and a Windows server Steve installs shows its programs (Couldn't check for me: no Windows server on staging).
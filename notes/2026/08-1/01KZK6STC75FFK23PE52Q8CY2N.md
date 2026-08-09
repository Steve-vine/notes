---
id: 01KZK6STC75FFK23PE52Q8CY2N
created: 2026-08-09T12:08:45.19172Z
updated: 2026-08-09T12:08:45.19172Z
type: task
title: Windows volume usage needs the community.windows collection
label: improvement
assignee: steve
priority: low
task_status: backlog
project: 01KX671DATY39VW6GWK3M2T3DN
number: 623
---
Gap in ISE-567, flagged at build time rather than discovered later.

`server_disk_usage` works on Linux: `ansible.builtin.setup` with `gather_subset=hardware` returns `ansible_mounts`, and the evidence card shows filesystems with computed percentages.

On Windows it returns nothing usable. `ansible.windows.setup` does not report volume usage, and the module that does — `win_disk_facts` — lives in **`community.windows`**, which the image deliberately does not ship. ADR 0084 §2 keeps the shipped surface small: every collection ISE ships is a set of modules somebody could eventually invoke, and one collection was the whole point of not shipping the `ansible` megabundle.

**Current behaviour is honest, not silent.** The pull returns `ok=False` with "reading Windows volume usage needs a collection this deployment does not ship", and the card renders that. An empty list would have read as "this machine has no disks", which is the failure worth avoiding.

**The decision, not the work.** Adding it is one pinned collection in the Dockerfile builder and a branch in `servers_evidence._disks`. The question is whether "disk usage on Windows servers" is worth widening the shipped module surface for — a real judgement, since disk-full is one of the more common things an incident is actually about.

Options:
1. Ship `community.windows` pinned, use `win_disk_facts`. Simplest, widest surface.
2. Read it with a FIXED `win_powershell` query (`Get-Volume`), the same pattern `server_recent_logs` already uses — no new collection, no new invocable modules, and the command is written in ISE and reviewed at PR time.
3. Leave it. Windows disk usage stays a thing an operator checks elsewhere.

Option 2 is the closest fit to the existing design and adds nothing to the surface; option 1 is the more conventional Ansible answer. Worth a decision before it is built either way.
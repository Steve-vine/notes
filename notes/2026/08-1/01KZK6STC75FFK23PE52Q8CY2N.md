---
id: 01KZK6STC75FFK23PE52Q8CY2N
created: 2026-08-09T12:08:45.19172Z
updated: 2026-08-09T12:24:05.863742Z
type: task
title: Windows volume usage needs the community.windows collection
project: 01KX671DATY39VW6GWK3M2T3DN
number: 623
sprint: sesjg7z
comments:
- id: 01KZK7DQZXE8M9S6J0C9W04YDM
  author: Steve Vine
  at: 2026-08-09T12:19:38.109162Z
  text: |-
    DECIDED 2026-08-09 (Steve): **use Ansible** — option 1. Ship `community.windows` pinned in the Dockerfile builder and read volumes with `ansible.windows`/`community.windows` modules rather than driving PowerShell.

    Reading that as: a real Ansible module beats a shelled command, even a fixed one. Option 2 was the PowerShell route; say so if you meant that instead and I will flip it back before it is built.

    Consequences to carry into the work:

    - One more pinned collection in the image (`community.windows`), and the ADR 0084 §2 note about keeping the shipped surface small should be amended rather than quietly contradicted — the rule was "one collection, pinned, not the megabundle", and this is a second deliberate one with a reason.
    - `servers_evidence._disks` branches on platform: `ansible_mounts` from `setup` on Linux, `win_disk_facts` on Windows, normalised into the same `volumes` shape so the card and any agent reading the evidence do not have to know which platform answered.
    - The honest-degradation path stays for anything that still cannot answer. It should never become an empty list — "this machine has no disks" is the reading to avoid.
    - Worth revisiting `server_recent_logs` at the same time: it currently uses a fixed `win_powershell` query for the Windows event log. If the principle is "use Ansible modules", `community.windows.win_eventlog_entry`-style options should at least be considered, or the inconsistency deliberately recorded.
- id: 01KZK7NXF7PP1K7XDG4FR3NXNS
  author: Steve Vine
  at: 2026-08-09T12:24:05.863555Z
  text: |-
    CONFIRMED 2026-08-09 (Steve): option 1. Ship `community.windows` pinned and use `win_disk_facts` — a real Ansible module, not a shelled PowerShell command.

    That settles the two consequences noted above as work to do, not open questions:

    1. **ADR 0084 §2 gets an amendment.** The rule as written is "one collection, pinned, not the megabundle". A second deliberate collection does not contradict the intent — keeping the invocable surface small and known — but it does contradict the letter, and an ADR that quietly stops matching the image is worse than one that records why it changed.
    2. **`server_recent_logs` becomes the odd one out**, still reading the Windows event log through a fixed `win_powershell` query. Either it moves to a module under the same principle, or the exception is written down where the next reader meets it. Left as a judgement for whoever builds this, but it should not be left silent.
assignee: steve
label:
- improvement
priority: low
task_status: backlog
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
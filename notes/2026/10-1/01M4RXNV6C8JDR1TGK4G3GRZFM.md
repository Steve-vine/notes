---
id: 01M4RXNV6C8JDR1TGK4G3GRZFM
created: 2026-10-12T20:43:13.484821Z
updated: 2026-10-15T12:08:53.017773Z
type: task
title: 'ADR: the directory is the on-prem source — servers are found from Active Directory computer accounts and Entra ID devices, and nothing is scanned, installed or logged in to'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 932
sprint: surilj1
comments:
- id: 01M4ZDFHW4K2Q38V0J6TJ79VF0
  author: Steve Vine
  at: 2026-10-15T09:14:51.139871Z
  text: |-
    Merged to main (PR #955, 2026-10-15) as ADR 0108, "The directory is the on-premises source". Not on staging until the rest of the sprint is in Review.

    What it settles, beyond the task text:
    - A server's identity is the machine's directory identity: its AD objectGUID, or its Entra ID deviceId. For a machine joined to both these are the same value, so one known to both directories is one entry without matching on names, and moving from Entra ID only to Hybrid re-identifies nothing. That answers the "what happens to an Entra-only record when it gets an AD twin" question the task left open.
    - "Runs SQL Server" stays a fact on something that runs things (a shared SQL Server would otherwise be limited to one technology asset).
    - A computer account with no operating system (created ahead of a machine that never joined) is left out, as are Macs joined to the domain.
    - Rules will hold an OU by its id, not its path, so a renamed OU is followed.
    - Windows Server versions use the Software sprint's key shape (os:windows-server:2019), as the comment from that sprint asked.

    ADR 0099 §6 and §13 carry a note pointing at 0108. No code.
assignee: steve
label:
- brief
priority: high
task_status: done
---
Part of sprint 66, Inventory discovery - On-prem. Scoped with Steve 2026-10-12. This record is the first task and gates the rest.

ADR 0099 §6 named on-prem estates as a later source that reuses the resource record, the three outcomes, the rules and the findings, and listed the candidates: Active Directory, Proxmox, Hyper-V, an existing management tool, or facts reported in. This record settles which of those Compass uses first, and what is the directory's own.

## What it decides

- **Servers come from the directory.** Steve's choice, 2026-10-12: Active Directory and Entra ID. Compass already talks to both, so there is no new key, no new network path and nothing to install.
- **Not in this sprint, and named as later:** Hyper-V and Proxmox (Steve: leave Hyper-V out), a management tool that already has an agent on the servers (Steve: none of these today), and servers reporting in by a script (belongs with the Software sprint that follows).
- **Still ruled out for every source,** as ADR 0099 §6 has it: network scanning, an agent of Compass's own, and Compass logging in to servers.
- **What counts as a server.** In Active Directory: a computer account whose operating system says "Server", or whose operating system is not Windows at all (a Linux machine joined to the domain). In Entra ID: a device whose operating system says "Server", or whose build number only a server carries. Workstations, laptops, phones, cluster names and service accounts are never listed: they are not Inventory's business.
- **One entry per server.** A server both directories know is one entry that says which directories know it. The two are matched on the directory's own identity for the machine, never on its name.
- **Three setups, one behaviour** (ADR 0083). AD only reads Active Directory; Hybrid reads both and merges; Entra ID only reads Entra ID.
- **Which company a server belongs to.** The directory is shared by the whole deployment; Inventory is per company. So a company switches server discovery on for itself and chooses which OUs hold its servers. Two companies may choose different OUs.
- **What is kept:** name, full name, operating system and version, where it sits in the directory, its description, when the account was made, about when it last signed in, whether the account is enabled, whether it is a domain controller.
- **What is never read:** local administrator passwords (LAPS), BitLocker recovery keys, and anything on the server itself. Both of the first two live on or beneath computer accounts, so the reader names every attribute it asks for and these are not among them.
- **The description is untrusted display text,** capped and never interpreted, as a cloud tag is.
- **Physical or virtual is not known** from a directory, and Compass says "not known" and does not guess.
- **Quiet is not gone.** A server is gone when its account is deleted or leaves the chosen OUs. One that has not signed in for a long time is still listed, and that is a finding.
- **Servers nothing sees** (bare-metal or stand-alone Linux, off the domain) stay typed by hand as technology assets. Steve: few or none.

## Notes (technical)

- `decisions/NNNN-*.md`, next free number. Amends ADR 0099 §6 and §13 by note (on-prem is no longer "later"); ADR 0083 is unchanged.
- Provider `directory`. Native id is the AD computer's `objectGUID`. A hybrid-joined Entra device's `deviceId` equals that GUID, which is the match.
- The directory connection is one per deployment (`ad_settings`, the Entra app); what a company adds is a scope, not a credential. It becomes a child of `discovery_connections` once COM-925 has made that the one relation.
- Record what was found on staging on 2026-10-12, because it shapes the Entra task: 2,072 devices mirrored, none with "Server" in its operating system, none hybrid-joined, and two with builds a server could carry (20348 once, 17763 once; 17763 is also Windows 10 1809).
- Settle here: whether "runs SQL Server" makes a server something that holds data, or stays a fact on something that runs things (the roles task assumes a fact); and what happens to an Entra-only record when a change of setup gives it an AD twin.

**Done when:** the ADR is merged and the tasks that follow can be built without another product decision.
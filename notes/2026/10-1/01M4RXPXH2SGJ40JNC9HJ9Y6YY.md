---
id: 01M4RXPXH2SGJ40JNC9HJ9Y6YY
created: 2026-10-12T20:43:48.642382Z
updated: 2026-10-15T09:21:05.546548Z
type: task
title: Compass reads servers from Active Directory — every domain-joined Windows and Linux server in the chosen OUs appears on the Discovered tab, every six hours and on demand
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 934
sprint: surilj1
blocked_by:
- 01M4RXPA383WKHTPHC5JWKBKJ0
assignee: steve
label:
- feature
priority: high
task_status: active
---
Part of sprint 66, Inventory discovery - On-prem (ADR in COM-932). This is the reading. What it finds appears on the Discovered tab the cloud sources already use, and is decided the same three ways.

## What people see

- **The Discovered tab lists servers** beside what the clouds found. The kind is "Server"; "Found in" is the domain. Each row shows the name, the operating system and its version, and says so when the server is a domain controller or its account is disabled.
- **Opening one shows what the directory knows:** its full name, operating system and version, where it sits in the directory, its description, when its account was made, about when it last signed in, and whether the account is enabled. "Physical or virtual" reads "not known".
- **"About when it last signed in" is honest about its precision.** Active Directory only keeps this to within a couple of weeks, so Compass says "about 3 weeks ago" and never a time of day.
- **The same three outcomes** as any discovered resource: make a technology asset from it, add it to one, or discard it with a reason. A server may sit beneath several technology assets. The same bulk actions.
- **What is not listed:** workstations and laptops, cluster names, and service accounts. The card on Inventory ▸ Settings says how many computer accounts were left out, so nobody wonders where they went.
- **A server whose account is deleted, or that leaves the chosen OUs,** is treated as any resource that has gone: one attached to a technology asset stays and says it is no longer found; one still awaiting a decision is removed.
- **The card shows** when the directory was last read for servers, how many were found, and, if an OU could not be read, which one and why.
- **Read now** is on the card.

## Notes (technical)

- **Reader** in `core/discovery/directory/`, registered through `core/discovery/sources.py`. Category `compute`. `region` is left empty; the OU is a fact.
- **What it asks for, by name and never `*`:** `objectGUID`, `cn`, `dNSHostName`, `operatingSystem`, `operatingSystemVersion`, `description`, `whenCreated`, `lastLogonTimestamp`, `pwdLastSet`, `userAccountControl`, `primaryGroupID`, `distinguishedName`. A test holds the list and fails if a LAPS attribute (`ms-Mcs-AdmPwd`, `msLAPS-*`) or anything `msFVE-*` is added. The search is one level of object: recovery-key child objects are never walked.
- **What a server is:** `objectCategory=computer` (which already leaves out managed service accounts), with an operating system that contains "Server" or does not begin "Windows". Cluster name objects (`servicePrincipalName=MSClusterVirtualServer/*`) are left out.
- **Last signed in** is the later of `lastLogonTimestamp` and `pwdLastSet`. A machine changes its own password about every 30 days, so the second catches one the first is slow to show.
- **Reach** through `core/active_directory.py`, with whichever of LDAPS or Kerberos the directory card chose. Paged. One search per chosen OU; a server beneath two ticked OUs is one row.
- **`sync.upsert` and `sync.sweep`** as the other sources use them. Native id is `objectGUID`, so a renamed or moved server keeps its decision.
- **The description** is stored as untrusted display text under the caps `base.py` already sets for tags.
- **Celery.** The read takes the connection id, is idempotent and safe to run twice at once. Six-hourly beat, with the others.
- **Tests.** `tests/fake_ad.py` for the reader and the sweep; one read against the Samba test DC, which has real computer accounts to join.

**Needs from Steve before smoke-testing:** nothing new in Active Directory. Any domain account can read computer accounts, so the account Compass already uses is enough. Staging needs the directory connection working.

**Done when:** on staging the servers in a chosen OU appear on the Discovered tab with their operating systems, the count on the card matches what Active Directory Users and Computers shows for that OU, and one server has been made into a technology asset.
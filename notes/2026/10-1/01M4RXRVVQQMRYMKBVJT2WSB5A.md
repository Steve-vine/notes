---
id: 01M4RXRVVQQMRYMKBVJT2WSB5A
created: 2026-10-12T20:44:52.47111Z
updated: 2026-10-17T08:19:51.110542Z
type: task
title: Compass finds servers in Entra ID too — and a server both directories know is one entry
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 938
sprint: surilj1
blocked_by:
- 01M4RXRA4PMAD8HZ0N71H8P6HT
comments:
- id: 01M4ZP3K471X30WHKZ4YB0KVQK
  author: Steve Vine
  at: 2026-10-15T11:45:36.391039Z
  text: |-
    Merged to main (PR #961, 2026-10-15). Going to staging with the rest of the sprint.

    What to look at:
    - On staging today (Hybrid, 2,072 Entra devices, none named Server, none joined to both directories) expect 0–2 servers from Entra ID, probably Azure VMs and so left to Azure. The card says "N Entra ID devices left out as not servers" and "N Azure virtual machines left to the Azure subscription".
    - A server known to both directories is one entry: its detail has "Known to: Active Directory, Entra ID", plus Joined, Managed (Entra ID), Compliant (Entra ID) and Last signed in to Entra ID. "Not seen for 90 days" uses the later of the two sign-ins.
    - In Entra ID only, "Switch on" has no OU tree and reads every server Entra ID knows; "Found in" reads "Entra ID".

    Things that differ from the task text:
    - The device mirror is not changed. Rather than adding physicalIds to the 15-minute device sync (a failure there would stop the whole device mirror), Compass asks Entra ID for physicalIds only for the few devices that are servers and match no AD account, at read time. If Entra ID can't be asked, nothing is left out on a guess.
    - A server's identity is the machine's directory identity (ADR 0108 §5), so an Entra-only record keeps its decision when AD later knows it too; the task left that to the ADR.
    - Where a company chose OUs in Hybrid, a server only Entra ID knows is not read: it has no OU. With "the whole domain" it is.
    - Hybrid with no AD connection set up reads Entra ID alone, rather than nothing.
    - A device Entra ID calls just "Windows" is a server only on build 20348; it then gets no out-of-support check, because "Windows" names no release. 2022 is supported until 2031, so nothing is missed today.

    Technical: core/discovery/directory/entra.py (server_devices, merge, physical_ids as the test seam); availability gains reads_entra; sync_left_out holds computers, devices, azure_vms and missing_ous.
assignee: steve
label:
- feature
priority: medium
task_status: done
---
Part of sprint 66, Inventory discovery - On-prem (ADR in COM-932). Steve asked for Entra ID as a source beside Active Directory (2026-10-12). It is last in the sprint so that the Active Directory work does not wait on it.

**What to expect, from staging on 2026-10-12.** Entra ID holds 2,072 devices there. None calls itself a server, none is joined to both directories, and two carry a build number a server could have. So in this tenant, today, this task will find at most one or two servers, and those are probably Azure virtual machines. It earns its place in the two other setups: a company with Entra ID only, and a Hybrid tenant whose servers are joined to both.

## What people see

- **In Entra ID only,** switching on "Servers from the directory" lists the servers Entra ID knows. There are no OUs to choose.
- **In Hybrid,** a server both directories know is one entry. Its page says "Known to: Active Directory, Entra ID" and shows what each says. Entra ID adds whether the server is managed, whether it is compliant, and when it last signed in there.
- **What counts as a server in Entra ID:** a device whose operating system says "Server", or whose build number only a server carries. Entra ID calls most Windows machines just "Windows", and several server versions share a build number with a desktop version, so a server Compass cannot tell from a laptop is not listed. The card says how many devices were left out.
- **A server that is an Azure virtual machine is not listed here.** The Azure subscription finds it, with far more to say about it. If the subscription is not connected the card says how many were left for it.
- **Phones, tablets, laptops, Macs and printers are never listed.**
- **The same outcomes, rules, checks and findings** as servers from Active Directory. "Not signed in for 90 days" uses the later of what the two directories say.
- **Nothing new is asked of Microsoft.** Compass already reads the device list.

## Notes (technical)

- **Reads the mirror, not Graph.** `directory_devices` is already kept current every 15 minutes; the discovery read turns the rows that are servers into resources.
- **The twin.** For a hybrid-joined device (`trust_type` server_ad) Entra's `device_id` equals the AD computer's `objectGUID`. That is the only match used. In Hybrid the native id stays the AD GUID and the Entra facts are held beside the AD ones under their own key, so neither overwrites the other.
- **Server-only builds** are a short list in code with a test: 20348 (Windows Server 2022) qualifies; 17763, 14393 and 26100 do not, since each is also a desktop release.
- **Azure virtual machines** are recognised by the Azure resource id Entra keeps in the device's `physicalIds`. The mirror does not hold that today: add it to the device `$select` and the table (migration, and the mirror's select version goes up so a full read refills it).
- **Entra ID only has no OU scope,** so every company that switches discovery on sees the same servers. Accepted; a rule discards what is not theirs.
- **A change of setup:** what happens to an Entra-only record when its AD twin appears is for the ADR. The intent is one record that keeps its decision.
- `entra_in_use()` guards the Entra half, as it guards every other Entra read.

**Needs from Steve before smoke-testing:** nothing for Entra ID only behaviour beyond the tenant already connected. The Hybrid merge cannot be seen on staging until a server there is joined to both directories; until then it rests on tests.

**Done when:** on staging the card says how many Entra ID devices were recognised as servers and how many were left out and why, and any that were recognised are on the Discovered tab once and only once.
---
id: 01KZK1PMKEVDBNHQXC0WK0T06X
created: 2026-08-09T10:39:38.094923Z
updated: 2026-08-09T10:39:38.094923Z
type: task
title: Entra server detection is a heuristic — let the tenant declare instead
assignee: steve
task_status: backlog
label: tech_debt
priority: medium
project: 01KX671DATY39VW6GWK3M2T3DN
number: 620
---
Follow-up to ISE-569, raised 2026-08-09 from live tenant data. **Entra has no attribute that says "this is a server."** Everything ISE does today to decide is a proxy, and the current proxy — a build-number allow-list — needs a code change every time Microsoft ships a Windows release.

**What the tenant actually carries** (2,005 devices, surveyed 2026-08-09):

| signal | reality |
|---|---|
| `operatingSystem` | `"Windows"` for all 1,480 Windows devices — DCs and laptops alike |
| `operatingSystemVersion` | build number only; 26100 = Server 2025 AND Win11 24H2 |
| `onPremisesSyncEnabled` | **None for all 2,005** — nothing is synced from on-prem AD, so no AD-sourced OS strings |
| `extensionAttributes` | **unused, all 15 slots free on every device** |
| `deviceCategory` | populated on 552 — but by region ("Moneypenny UK Devices"), not role |
| `managementType` | MDM on 1,517 (Intune = workstation), None on 486 |
| `trustType` | only **11** Windows devices are `Workplace`; the rest are `AzureAd` |

The last two are better discriminators than the build number — all three known servers are `Workplace` and not Intune-managed, which narrows 1,480 → 11. But they are still proxies, and they would break the day someone Entra-joins a server or enrols one in Intune.

**The proposal: configuration over classification.** ISE should read a set the ORGANISATION maintains, so a new Windows release never needs an ISE release:

1. **An Entra group** the Servers integration is pointed at (static, or dynamic with a membership rule the Entra owner controls). Read membership, propose those. Authoritative, and it moves the definition to the people who own the directory.
2. **`deviceCategory`** — already in use here for regions, operator-assignable, so a "Servers" category costs no new mechanism.
3. **`extensionAttributes`** — 15 unused slots that exist for exactly this kind of org-specific classification.

Any of these turns detection into a declared value rather than a rule ISE has to keep current.

**Also worth deciding: is the Entra source worth keeping at all?** Its entire marginal contribution over Arc in this tenant was ONE machine (`mpwxexchange`, an Exchange server on Server 2025 that Arc does not know about). Arc gives 39 servers with an unambiguous signal. A source that needs heuristics to be useful may not be worth the false-positive risk — "drop it, and rely on Arc + Azure + Hyper-V" is a legitimate outcome of this task.

**Current behaviour** (shipped in `36ea61c`): builds 14393/17763/20348/25398 are proposed; 26100 is excluded as ambiguous, so an Entra-joined Server 2025 that Arc does not know about is missed. `mpwxexchange` is the known live example.

A corroboration rule (admit 26100 when `trustType != AzureAd` and not Autopilot-enrolled) was written and tested and would find it — but it was NOT merged, because it is more of the same fragility this task exists to replace. Reinstate it only as an interim if the declared-set work is deferred.
---
id: 01M7838HHKVG0RABFKZ1EFK632
created: 2026-11-12T14:40:49.203278Z
updated: 2026-11-12T15:26:44.802513Z
type: task
title: 'Inventory: a Windows 11 machine''s release and support dates come from Entra ID'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1762
assignee: steve
label: null
priority: medium
task_status: backlog
---
**Why.** Four Moneypenny assets run Windows 11 Pro (SFT-26: AST-20 BadgeReader, AST-107 BadgeReaderWin11, AST-58 MPWXNet2, AST-86 MPWXBMS) and read **Not recorded**, because the software record has no release and no dates. Support for Windows 11 depends on the feature release installed (23H2, 24H2, 25H2…), and Entra ID already knows each machine's build. Steve asked (2026-11-12) for Compass to work it out itself.

**What blocks it today.**
- Entra server discovery (COM-938, ADR 0108 §3) lists only servers. A Windows 11 machine is "Windows" with a desktop build, so it never reaches Inventory.
- The lifecycle catalogue (`core/lifecycle.py` `_PRODUCTS`, `core/discovery/os_names.py`) knows Windows Server only, not the Windows client.

**What it should do.**
1. **A person links an Inventory asset to its Entra device.** On a technology asset, pick the device from Entra ID (the device mirror Access Control already keeps). Desktops are *not* listed wholesale in Discovered: laptops stay in Access Control. Only an asset someone links is read. Matching on the device identity, never by name.
2. **Compass reads the release from the build.** It reads `operatingSystemVersion`: 22621 → 22H2, 22631 → 23H2, 26100 → 24H2, 26200 → 25H2. Unknown builds read as Windows 11 with no release, so their dates stay blank. Windows 10 (19044/19045) can use the same mapping if it's cheap.
3. **The installed software follows the device.** Its OS row becomes "Windows 11 <edition> <release>", found by discovery. It is kept current on each sync, so an upgrade from 24H2 to 25H2 moves the asset onto the new release's dates without anyone typing anything.
4. **Support dates come from endoflife.date** (product `windows`; check its cycle naming, e.g. `11-24h2-w` for Home/Pro and `11-24h2-e` for Enterprise/Education). The dates *follow* the catalogue, as the other OS dates do.
   - **Edition:** Entra ID doesn't say Pro or Enterprise. Take it from the typed software record when it names one. Otherwise use the Home/Pro dates, the shorter and safer choice. Say which one was assumed.

**Probably needs** an ADR 0108 amendment, since Inventory reads a desktop when a person links it, and is likely **on the chain** (the asset↔device link). Decide when building.

**Done when:**
- AST-20, AST-107, AST-58 and AST-86 can each be linked to their Entra device, if they are in Entra ID. If one isn't, the screen says so.
- A linked machine shows its Windows 11 release as installed software, found by discovery, with Microsoft's mainstream/extended dates and the asset's support worked out from them (ADR 0150).
- Changing a test device's build in the mirror moves it to the new release and dates on the next sync.
- A Windows 11 machine nobody linked doesn't appear in Inventory's Discovered tab.
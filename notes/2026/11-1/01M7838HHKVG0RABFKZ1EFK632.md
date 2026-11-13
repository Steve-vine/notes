---
id: 01M7838HHKVG0RABFKZ1EFK632
created: 2026-11-12T14:40:49.203278Z
updated: 2026-11-13T23:19:09.216263Z
type: task
title: 'Inventory: a Windows 11 machine''s release and support dates come from Entra ID'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1762
sprint: spsp226
comments:
- id: 01M7B4Q8ZYEDA8MG1TCHVXWJ9H
  author: Steve Vine
  at: 2026-11-13T19:04:03.838623Z
  text: |-
    Built — PR #1790 (feature/com-1762-windows11-entra). On the chain: migration 0841 (the asset↔device link) and new API routes; ADR 0108 amended. I merge it in chain order.

    How to link: open a technology asset (Inventory ▸ Technology ▸ the asset). A new **Entra ID device** card sits between Resources and Installed software. **Link device** opens a search of Entra ID's devices, pre-filled with the asset's name; click one to link it. A device already linked elsewhere shows "Linked to AST-…" and can't be picked. No match says "No device in Entra ID is called that". The card shows to people who manage the register, and not on SaaS / container / not-applicable assets.

    Once linked:
    - The card shows Device, Build ("Windows 10.0.26100.4652"), Windows release ("Windows 11 24H2"), Edition, Last signed in, with Change device and Unlink. An unknown build says Compass doesn't know its release, so dates stay blank. If the device leaves Entra ID, a warning says so and the last release read stays.
    - Installed software: the typed "Windows 11 Pro" line becomes "Windows 11 Pro 24H2", keeping licences and notes, marked "Found by discovery · <build> · <DEVICE> (Entra ID)". Only unlinking removes it. The asset's support follows that release (ADR 0150).
    - Every directory sync (~15 min) re-reads the build, so 26100 → 26200 moves it to 25H2 and its dates.
    - Nothing new appears on Discovered.
    - Polaris can link and unlink, and sees the linked device.

    Choices:
    - Compass creates the "Windows 11 <edition> <release>" register entry if the company has none (owned by the previous Windows entry's owner, else the asset's owner). The old "Windows 11 Pro" entry stays in the register.
    - Edition comes from the typed line's name. Enterprise and Education get the longer dates; everything else, including no edition, gets the Home/Pro dates ("Not named, so Home and Pro support dates are used").
    - Also mapped: 21H2, 26H1, 26H2 for Windows 11, and 21H2/22H2 for Windows 10.

    **Heads-up:** Windows 11 24H2 Home/Pro went out of support on 13 Oct 2026, so any of AST-20/107/58/86 still on 24H2 will read **Out of support** once linked (25H2 runs to 12 Oct 2027). That's the catalogue being right.

    For you to check (tests can't reach Entra): the picker lists real devices; linking a Windows 11 device shows the right release; a build change in Entra moves the asset after the next sync.

    Checks: ruff/mypy clean, unit 2256 passed, integration 157 passed (new device-link tests + inventory/assistant/sync/support), EntraDeviceCard and related vitest pass.
- id: 01M7BKABN0CX0GTMHDAXPGDJD4
  author: Steve Vine
  at: 2026-11-13T23:19:09.215994Z
  text: |-
    Pre-UAT: Passed, except the four Moneypenny assets and a build change on sync, which I couldn't check (staging 2f72416b, E2E Test Company, as E2E Admin A). Screenshots: ~/compass-uat/spsp226/COM-1762/

    Steps:
    1. New AST-64 "E2E pre-UAT COM-1762 Windows 11 machine" (System), with a new register entry SFT-27 "Windows 11 Pro" (Operating system) installed on it, as on the Moneypenny machines. The asset shows the new "Entra ID device" card with Link device.
    2. Link device opens "Link AST-64 to its Entra ID device", searching for the asset's name. That gives "No device in Entra ID is called that. A device added since the last directory sync appears within fifteen minutes."
    3. Searched MP-00137 (build 10.0.26100.4061): the picker reads "Windows 11 24H2". I linked it. The card shows Device MP-00137, Build "Windows 10.0.26100.4061", Windows release "Windows 11 24H2", Edition "Pro", Last signed in.
    4. Installed software: the typed "Windows 11 Pro" line became SFT-28 "Windows 11 Pro 24H2", "Found by discovery · 10.0.26100.4061 · MP-00137 (Entra ID)", licences 1, OUT OF SUPPORT. SFT-28 reads Mainstream support ends 13 Oct 2026, "Support dates: endoflife.date", Edition Pro, Version 24H2, Publisher Microsoft. The asset's Support reads OUT OF SUPPORT, "Windows 11 Pro 24H2 (SFT-28), ended …" (ADR 0150).
    5. Change device to MP-00055 (10.0.26300.9911): it reads "Windows 11 26H2". The line moved to a new SFT-29 "Windows 11 Pro 26H2", mainstream to 10 Oct 2028 from endoflife.date. The asset's own Support reads "Not recorded — its own end of support isn't recorded", which is the ADR 0150 rule. On Steve's assets, their own support must be N/A for the release's dates to show.
    6. From AST-62, the picker shows MP-00055 as "Linked to AST-64 · E2E pre-UAT COM-1762 Windows 11 machine" and it can't be picked.
    7. Polaris's view of AST-64 shows entra_id_device MP-00055, build, "Windows 11 26H2", edition Pro, and the software row "kept_from_entra_id_device".
    8. Unlink: the card goes back to Link device. SFT-29 stays installed, no longer marked found by discovery. The Activity log reads "Kept from its Entra ID device: Yes → No". I left AST-64 unlinked.
    9. The Activity log names every step in screen words ("linked AST-64 to its Entra ID device MP-00137", "AST-64 now has SFT-28 installed instead of SFT-27"). Discovered stays at 0.

    Couldn't check, for Steve:
    - AST-20, AST-107, AST-58 and AST-86 are Moneypenny production assets. On staging no Entra device is called BadgeReader*, so look in production: link each one, and see whether it says it isn't in Entra ID.
    - A build change moving the release on the next sync needs a real device's build to change in Entra ID. Look at a linked machine after it updates.
    - I found no device with a build Compass doesn't know, so I couldn't see the "doesn't know its release" wording.

    Small things seen:
    - The asset's Support line shows an ISO date: "Windows 11 Pro 24H2 (SFT-28), ended 2026-10-13" (other screens say "13 Oct 2026").
    - "Last signed in: about 23 Jan 2026": "about" sits oddly before a full date.
    - After unlinking, is it right that the "Windows 11 Pro 26H2" line stays? The build note said "Only unlinking removes it". Steve's call.
assignee: steve
label: null
priority: medium
task_status: review
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
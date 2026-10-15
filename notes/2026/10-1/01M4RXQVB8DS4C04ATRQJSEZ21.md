---
id: 01M4RXQVB8DS4C04ATRQJSEZ21
created: 2026-10-12T20:44:19.176888Z
updated: 2026-10-15T10:59:05.591428Z
type: task
title: Servers are checked — an operating system out of support, a server that has gone quiet, a disabled server still in use — and Windows Server versions appear in the Software register
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 936
sprint: surilj1
blocked_by:
- 01M4RXQ9BQFRPX38EG83HGRTZW
comments:
- id: 01M4XZN6PHMXKG281PSJCBTVZ8
  author: Steve Vine
  at: 2026-10-14T19:54:01.80908Z
  text: |-
    2026-10-14, from planning sprint "Inventory discovery - Software" (COM-959..968). This task is how on-prem servers reach that sprint. Steve: "On-prem servers (will be provided by sprint 66)". Two things follow when this is built:
    - The Windows Server versions found here should use the key shape in COM-959 (os:windows-server:2019), so they land in the same Discovered ▸ Software rows as cloud servers (COM-964).
    - The in-code Windows Server support table is a stopgap. COM-962 replaces it with the shared lifecycle catalogue, and dates are then filled into the register entry, not shown beside it (Steve's decision, which reverses COM-889's call).
    If this is built after COM-960, put the suggestion in Discovered ▸ Software, not in the Software tab banner (which COM-960 removes).
- id: 01M4ZKEA13KH6GYHGNSEK8ZCYJ
  author: Steve Vine
  at: 2026-10-15T10:59:01.79517Z
  text: |-
    Merged to main (PR #959, 2026-10-15). Not on staging until the rest of the sprint is in Review.

    What to look at:
    - Put a few servers beneath a technology asset (Discovered ▸ make an asset / add to one), then Read now. The asset's findings card shows, where they apply:
      - "OLD01 runs Windows Server 2008 R2, which Microsoft stopped supporting on 14 January 2020."
      - "QUIET01 has not signed in to the directory for over 90 days. It may no longer exist."
      - "The directory account of OLD01 is disabled, yet it is still part of this asset."
    - On the Discovered tab an undecided server that has gone quiet carries "Not seen for 90+ days" on its row.
    - Inventory ▸ Software: the Windows Server releases running beneath technology assets are suggested ("Windows Server 2019", found in "Directory"), with Microsoft's mainstream and extended support dates.

    Things that differ from the task text:
    - The suggestion lists the technology assets the release runs beneath, as the cloud engines' suggestions do — not a count of servers.
    - The key is os:windows-server:2019 (the Software sprint's shape, as COM-959's comment asked), not directory.os:windows-server:2019.
    - Windows Server 2003 is in the table too, for old estates.
    - Dates checked against Microsoft's lifecycle on 2026-10-15: 2008/R2 ended 14 Jan 2020, 2012/R2 10 Oct 2023, 2016 ends 12 Jan 2027, 2019 9 Jan 2029, 2022 14 Oct 2031, 2025 14 Nov 2034. Paid extended security updates are not assumed.
    - Findings are re-evaluated at each read (every six hours), so the day support ends the finding appears at the next read rather than at midnight.

    Technical: checks.Check gains applies_on(facts, now) and words(facts); findings._expected passes the moment. core/discovery/directory/support.py holds the table, pinned by a test. software.key_of / running learn the server kind. No migration.
assignee: steve
label:
- feature
priority: high
task_status: review
---
Part of sprint 66, Inventory discovery - On-prem (ADR in COM-932). The findings and the Software register already exist for the cloud sources (COM-888, COM-889, COM-921); this gives servers their checks and puts their operating systems in the register.

## What people see

- **A technology asset with servers beneath it shows findings,** raised to its owner as one action, accepted with a reason or turned into a risk, exactly as cloud findings are.
- **Three checks:**
  - *Runs an operating system its maker no longer supports.* It names the version and the date support ended.
  - *Has not signed in to the directory for 90 days.* The register says this server exists; the directory suggests it may not.
  - *Its account is disabled, yet it is still part of this asset.*
- **On the Discovered tab,** a server awaiting a decision that has been quiet for 90 days says so on its row, so it can be discarded without opening it. Findings themselves appear once a server sits beneath a technology asset, as now.
- **The Software register suggests the Windows Server versions in use:** "Windows Server 2019, running on 14 servers", added in one click or dismissed. Once added, the entry shows the servers it runs on and Microsoft's support dates beside any typed by hand, as the cloud engines do.
- **A support date that is coming is not a finding yet.** It is on the Software register entry; the finding starts the day support ends.
- **Linux is not checked for support.** A directory rarely states a Linux version in a form that can be trusted, so Compass shows what the directory says and judges nothing.

## Notes (technical)

- **Checks** in `core/discovery/checks.py` for the server kind. Two of the three depend on today's date, where every check so far depends on facts alone: give the evaluation the read time. Do not store "days quiet" as a fact, which would change every read.
- **Quiet** is measured from the later of the two sign-in facts the reader keeps. 90 days is a constant, named once.
- **Support dates** are a small table in code (`core/discovery/directory/support.py`), Windows Server 2008 through 2025, taken from Microsoft's published lifecycle at build time, with a test that pins it. The end of extended support is the date used; paid extended security updates are not known and not assumed.
- **The version** comes from the operating system name ("Windows Server 2019 Standard" → 2019), with the build number as the fallback.
- **Software** (`core/discovery/software.py`): `_FAMILIES` gains the server kind with family `directory.os`, key `directory.os:windows-server:2019`. Derived, not synced, as now.
- A server beneath several technology assets raises its finding on each, as a shared cloud component does.
- No migration expected. Regenerate `schema.d.ts` if the Software suggestion payload gains a field.

**Done when:** on staging a technology asset with a Windows Server 2012 R2 server beneath it (or the oldest there is) shows the out-of-support finding with the right date, a server quiet for 90 days shows its finding, and the Software register suggests each Windows Server version found with the right count.
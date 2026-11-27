---
id: 01M8FJ6FP65A48HF2SCP8MPF4K
created: 2026-11-27T22:32:13.254289Z
updated: 2026-11-27T22:32:13.254289Z
type: task
title: 'ADR 0188: known vulnerabilities from discovered software — exact matches (Windows builds, Linux distribution packages) raise and close vulnerabilities by themselves; other software stays "possibly affects us"'
priority: high
label: brief
task_status: todo
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2211
---
**Independent** (decision record only). Sprint 131 "Vulnerabilities - Software matching". Follows the Server Agent sprint (ADR 0187), which gives on-premises servers a software list, a full build and installed updates.

Steve, 27 Nov 2026: identify known vulnerabilities from discovered software versions; **exact matches raise vulnerabilities automatically** (and close when fixed); the rest keep the person-confirmed route.

What the ADR records:
- **Matching moves to each server's own version.** Today the Security Feed compares the version on the Software register entry's product link (ADR 0139 §5, §7). It will compare each server's exact installed version (discovered software, ADR 0114), for cloud servers as well as agent ones.
- **Two kinds of match:**
  - **Exact** — no person needed to say what the software is:
    - **Windows** (and Microsoft server products where the server reports a full build): Microsoft's fixed build per product, compared with the server's full build. Updates are cumulative, so build ≥ fixed build means fixed.
    - **Linux packages**: the distribution's own security data (Ubuntu, Debian, Red Hat, Rocky, Alma, through **OSV.dev**, a new Security Feed source), compared with the installed package by the distribution's version rules. NVD's upstream ranges are never used for distribution packages (backported fixes).
  - **Possible** — everything else (third-party Windows programs): NVD and vendor data through the product link a person confirmed (ADR 0139 §5), now naming each server and its version. Still "possibly affects us" until a person confirms (ADR 0139 §8).
- **Exact matches raise vulnerabilities by themselves** (Steve's call): one issue per CVE per server in the register (ADR 0129), source **Version match**, through the same path scanners use — so it joins an existing Nessus issue as a sighting, **closes as Fixed when the next read shows the fixed version** (only where Compass looked), and reopens if it comes back. A person's Accepted or False positive is kept.
- Amends ADR 0139 §5/§7/§8/§9 (exact matches need no product link and are confirmed by the match; no Security Feed action for something already raised), ADR 0129 (a new source), ADR 0187 §7 (patch level judged by missing security fixes, with the age rule as fallback).

My calls (for Steve to overturn):
1. Only **when a fix is available** is a vulnerability raised; "no fix yet" stays on the Security Feed as affects us.
2. Every severity is raised by default; a company can set a minimum severity, and can switch automatic raising off.
3. Data source for Linux is OSV.dev (one source for all five distributions) rather than each distribution's feed.
4. A Windows server whose full build isn't known (some cloud servers) is never an exact match; it falls back to the possible route.

**Done when:** ADR 0188 is on main as Proposed, with the calls listed.
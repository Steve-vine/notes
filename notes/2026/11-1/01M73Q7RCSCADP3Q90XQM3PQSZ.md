---
id: 01M73Q7RCSCADP3Q90XQM3PQSZ
created: 2026-11-10T21:53:42.809128Z
updated: 2026-11-10T22:41:50.414411Z
type: task
title: 'ADR 0147 (planned as 0145): Collection feeds — a Collection integration can feed Vulnerabilities, Inventory and Secrets, and everything a feed does lives in its configuration; code that knows a particular service is never allowed'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1695
sprint: sep79bz
comments:
- id: 01M73SZTFVGEGRC0V5XECXAYH3
  author: Steve Vine
  at: 2026-11-10T22:41:48.539373Z
  text: |-
    **Done: merged to main in PR #1694.**

    - **`decisions/0147-collection-feeds.md`** is numbered 0147, because 0145 and 0146 went to the SOC 2 work earlier today. I've updated the title.
    - **What it records:**
      - A feed connects one Collection integration to one area: Vulnerabilities, Inventory, Secrets (keys at their source) or Secrets (stored copies).
      - Each area has a fixed shape, slot by slot (§2).
      - The mapping language is data only: a path, a fixed value, first non-empty, joined, then a value map, a date or a case change (§3).
      - A feed closes a record either when *the source says so* or when it's *missing from a complete read* (§4).
      - Each area's own rules still apply (§5).
      - Approval needs the area's own right, and changing the reads, mapping or closing rule sends a feed back to waiting for approval (§6).
      - A run is held when its shape changes, or when it would close or mark gone more than a quarter (at least 10), add half as many again (at least 50), or comes back empty (§7).
      - Approving a feed and deciding a held run stay on screen (§8).
      - **The hard rule (§9):** no code knows a service.
    - **Rule written down:** the hard rule is in CLAUDE.md's Hard rules, with a new section in `brief/ways-of-working.md`. CLAUDE.md's key-ADR list names 0147.
    - **ADR 0142** gets a short amendment pointing to 0147.

    **My calls in the ADR:**
    - each feed is its own source in Vulnerabilities, so one feed never closes another's findings;
    - a feed's switch belongs to the feed, not to ADR 0128's table of switches for coded tiles.
assignee: steve
label:
- brief
priority: high
task_status: review
---
The decision this sprint builds. Steve, 2026-11-10: expand Collection integrations beyond Evidence to Vulnerabilities, Inventory and Secrets. People is left out for now, because he's concerned it would add lots of local accounts, and logs are on hold.

**Chain:** independent (an ADR, plus the rule written into CLAUDE.md and `brief/ways-of-working.md`)

## What it decides

- **A feed** connects one Collection integration to one area. It is the reads, how each item becomes that area's record, what closes a record, and how often it runs. A service can have several feeds. For example, GitHub could have Dependabot alerts going to Vulnerabilities and repositories going to Inventory.
- **Each area has a fixed shape** that says what it needs:
  - **Vulnerabilities:** a finding, its target, the issue (a CVE or the service's own rule), severity, open, solved or accepted in the source (with the reason and an end date), first seen, and the service's own reference.
  - **Inventory:** a discovered resource, with its kind, name, the service's own ID, chosen facts and when it was created.
  - **Secrets:** a key at its source (name, the service's ID, owner, created, expiry, last used, what it can do) or a stored copy (name, last changed).
- **The area's own rules still apply.**
  - Vulnerability targets are placed by what Compass already knows, then by matching rules, then on Unmatched.
  - Inventory resources wait on Discovered for a person to decide what each one is.
  - Secrets wait on Secrets ▸ Discovered, and rotation proof works as for coded sources.
  - Text from the service is shown as the service's words (ADR 0129 §3).
- **What closes a record is declared by the feed:**
  - *the source says so*, e.g. state = fixed; or
  - *it's missing from a complete read*, and only within what was read.
  - A read that can't finish closes nothing (ADR 0142 §4).
- **Approval belongs to the area.**
  - Setting up the service needs *Manage integrations*, as today.
  - Approving a feed, and confirming a held run, need the area's own right: *manage vulnerabilities*, *Inventory admin* or *manage secrets*.
- **A run that changes far more than usual is held** for a person to look at, as well as a run whose shape has changed (ADR 0142 §5).
- **Each feed has a switch** on its tile (ADR 0128 §5).
- **The hard rule (Steve):** all logic lives in the integration's configuration. Code never says "if the service is GitHub, do this". There is no service name, ID or URL in the collection or feed code, no per-service branch, and no per-service mapping table shipped in code. If a service needs something the configuration can't express, the configuration language gains a general capability that every service can use (sprint "Collection integrations - more applications").
- Coded (Core) integrations stay as they are for now. Sprint sj4f1kj aims to recreate GitHub, Aikido and Nessus as configuration.

## Done when

- `decisions/0145-collection-feeds.md` is accepted. It amends ADR 0142 (§1, §5, §8) and ADR 0128 (§5), and lists my calls for Steve to overturn.
- The hard rule is in CLAUDE.md under Hard rules, and in `brief/ways-of-working.md`.
- CLAUDE.md's key-ADR list names 0145.
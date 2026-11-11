---
id: 01M7625PJHFPQ4SFS4Q7XNEX0F
created: 2026-11-11T19:43:18.609509Z
updated: 2026-11-11T22:43:42.56006Z
type: task
title: 'The left-hand menu is grouped by job: Modules splits into four named groups, and every group folds, with the one you''re in left open'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1739
sprint: spsp226
assignee: steve
label:
- improvement
priority: medium
task_status: cancelled
---
Found by Steve while testing (2026-11-11): the left-hand menu has become long and hard to navigate.

**Today:** 37 entries across seven headings. **Modules** alone holds 14 entries in the order they were built, so nothing tells you where to look. Every heading is always open, so the menu runs well past one screen.

### 1. Split Modules into four groups named after the job

| Group | Entries |
|---|---|
| **Overview** | Dashboard, Actions, Initiatives, Reports (unchanged) |
| **Playbook** | Frameworks, Domains, Controls, Content (unchanged) |
| **Posture** | Assessments, Gaps, Risks, Exceptions, Checks, Compliance, Continuity, Decisions (unchanged) |
| **Systems** | Inventory, Access Control, Secrets, Vulnerabilities, Security Feed |
| **Risk & Assurance** | Risk Assessments, SAP, Incidents |
| **People & Privacy** | Attestations, Data Subject Requests |
| **Third Parties** | Vendor Management, Contracts, DDQ, Trust Centre |
| **Audit** | Audits, Evidence (unchanged) |
| **Portals** | User Portal, the public Trust Centre (unchanged) |
| **Admin** | Admin, Integrations, Activity, System status (unchanged) |

- The order within each group follows the reader's path: what we hold, what's wrong with it, and what might be; then what could go wrong, the work that proves it's looked after, and what happened anyway; then suppliers, then clients.
- A group shows only if the person can see at least one entry in it, as Modules does today.

### 2. Every group folds

- Click a heading to fold or open it. Compass remembers the choice per person on that browser.
- **The group holding the page you're on is always open**, so following a link never leaves you lost.
- The first time, only the group you're in and Overview are open. Everything else starts folded, so the menu fits on one screen.
- Folded to icons only (the existing toggle): groups show as thin dividers with the heading as a tooltip. Nothing folds in that mode.

### 3. Search finds pages too

The top-bar search also matches menu entries ("vuln" → Vulnerabilities, "privacy" → Data Subject Requests, using each entry's note as well as its name), listed first under **Go to**. That gives a keyboard route that doesn't depend on the menu at all.

**Not changing:** page addresses, entry names and permissions. Only where entries are filed and how the groups behave.

Needs an amendment to ADR 0017 (IA), recording the groups and the folding rule, and `brief/information-architecture.md` updated to match.

**Done when:**
- The menu shows the groups above in that order. Each folds and opens, and stays as left after a reload.
- Opening any page, from the menu, a link, the search or the trail, opens its group.
- A person who can see only some modules sees only the groups that hold them.
- Typing a page's name, or a word from its note, in search offers it under Go to.
- With everything folded except the current group, the menu fits on a laptop screen without scrolling.
---
id: 01M7DJBPYNA11VCJVRNMC8QXM0
created: 2026-11-14T17:40:53.845402Z
updated: 2026-11-15T11:22:18.709494Z
type: task
title: Each connection says what a company uses it for (a tick-list people can add to), and Polaris only takes evidence from the system marked for it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1835
sprint: spsp226
comments:
- id: 01M7DSMFYMEMG5VN19X01NQXWC
  author: Steve Vine
  at: 2026-11-14T19:48:01.620085Z
  text: |-
    Built and merged: PR #1830, main 8d91b011.

    What people see now:
    - **A "What we use it for" tab** on every Collection integration the company has an account on, and on the Microsoft 365, Active Directory, AWS and Azure pages. AWS and Azure have one list per account or subscription.
      - It follows the company picker and shows a tick-list of evidence areas plus an optional note.
      - It starts with 15 areas: changes, incidents, service requests, problems, assets, software, vulnerabilities, access and identity, access reviews, backups, logging and monitoring, configuration, code and releases, training, vendors. Nothing is ticked to begin with.
    - **Adding to the list:** anyone who can manage integrations can add an area, and every company's connections then offer it. An area can be renamed, and removed only once nothing is ticked against it anywhere.
    - **Polaris follows it strictly.** It's told what each connection is used for, and every check it designs must name the area it evidences.
      - A read against a connection ticked for other areas is refused, and Polaris is told why. If a proposal still uses one, it's sent back once; after that the read is left out.
      - The same rule applies when Polaris changes a proposed check in chat. Your own edits on screen aren't restricted.
    - **When nothing is marked for what a control needs,** Polaris answers "can't be collected automatically" with the reason, e.g. "Nothing connected is marked as where you keep assets.", and the card links to Integrations.
    - **A connection with nothing ticked still works.** A check proposed from it shows "<name> hasn't been told what it's used for — Set what it's used for" on Review. Review reads the ticks as they are now, so ticking it clears the line.
    - **Polaris in chat can read** what each connection is used for (new tool: list connection uses). Setting it is on screen only.
    - ADR 0142 has an amendment: "Polaris takes evidence only from where the company keeps it".

    Tests:
    - Backend, against a real database with a scripted Polaris:
      - the starting list; an added area is shared, can't be removed while ticked, and can be renamed;
      - permissions;
      - what Polaris is told;
      - a connection ticked "Changes" is refused for an assets control and the check comes from the one ticked "Assets";
      - "nothing marked for assets" comes back as manual;
      - a change control leaves out a connection not marked for changes;
      - an untold connection still works and carries the Review line.
    - Vitest: ticking and saving with a note, adding an area, Remove only when nothing is ticked, the read-only view, one list per AWS account, and the Review line.

    For the pre-UAT pass on staging: mark FreshService on E2E Test Company "Changes" only, then ask Polaris to design for an asset control. The live design needs Polaris's AI provider, so I'll say what I could and couldn't see.
- id: 01M7DX8Q52MN920K7QQ35BP4QM
  author: Steve Vine
  at: 2026-11-14T20:51:30.082552Z
  text: |-
    Pre-UAT (staging 22572d0b, E2E Test Company): **Passed** where I could reach it; **Couldn't check** three parts.

    Passed:
    - The "What we use it for" tab is on Microsoft 365 and Active Directory (full list), and on FreshService, AWS and Azure. E2E has no account on any of those three, so they say so.
    - The list shows the 15 starting areas plus a note box. With nothing ticked it warns "Nothing is ticked yet: Microsoft 365 hasn't been told what it's used for."
    - As Admin A on Microsoft 365: ticked "Access and identity" with a note; both stayed after a reload and the warning went away.
    - Shared area list:
      - Added "E2E UAT area". It was offered on Active Directory too.
      - Ticked it there, and Remove was held ("Ticked on 1 connection").
      - Renamed it (the label updated), unticked it, and removed it.
    - Review: CHK-3, a proposal reading Microsoft 365 (nothing ticked), shows "Microsoft 365 hasn't been told what it's used for. Set what it's used for". The link opens Microsoft ▸ What we use it for.

    Couldn't check:
    - **Follows the company picker:** that needs another company, and the pass stays in E2E Test Company. Steve: switch company on a connection's tab and watch the ticks change.
    - **Polaris reading connection uses:** this session's Polaris connection was started before the deploy, so the new tool wasn't on its list. Steve: ask Polaris "what is each connection used for?"
    - **Polaris refusing FreshService for assets:** needs Polaris's AI provider and a real FreshService account. Steve:
      1. In a company with a FreshService account, tick only Changes on FreshService ▸ What we use it for.
      2. On Checks ▸ Overview, tick an asset-inventory control and choose Ask Polaris to design checks.
      3. Expect no FreshService proposal. The control should come back as "can't be collected automatically", saying nothing connected is marked as where you keep assets.

    Notes for Steve, not defects:
    - Viewer and Analyst can't open Integrations at all (as before), so the read-only view only shows to roles that can open Integrations without managing them.
    - Any Admin can remove an unticked starting area with one click and no confirmation, and the list is shared by every company.

    Test data left as it was: nothing ticked on Microsoft 365 or Active Directory, note empty, and the list back to its 15 starting areas.
    Screenshots: ~/compass-uat/spsp226/COM-1835/
assignee: steve
label:
- improvement
priority: medium
task_status: done
---
## What happened

Steve, testing Checks (2026-11-14): Polaris suggested taking asset information from FreshService, but the business uses FreshService for changes, not assets. Polaris has no way to know that. When it designs a check, all it's told about each connection is its name, documentation address, base address and paging (`available_sources` in `core/collection/runner.py`; the prompt in `core/collection/polaris_design.py`). So it reasons from what a service *could* do. FreshService has an asset module, so it's a plausible source. A connected Jira would look just as plausible a place for changes, even if nobody uses it for that. The integration's own description isn't passed to Polaris either. Today the only safeguard is rejecting the check on Review, and nothing stops Polaris proposing it again.

## What people see

- **On each connection, for each company: "What we use it for".** This is a tick-list of evidence areas, plus an optional note for anything the list doesn't cover. It appears on every Collection integration the company has an account on, and on the core connections (Microsoft 365, AWS accounts, Azure subscriptions, Active Directory). It's per company, because one company may run changes through FreshService and another through Jira on the same integration.
- **The list starts with the common areas.** For example: changes, incidents, service requests, problems, assets, software, vulnerabilities, access and identity, access reviews, backups, logging and monitoring, configuration, code and releases, training, vendors.
- **People can add to the list.** Anyone who can set up connections can add an area. An area that's added is shared by every company, so everyone uses the same words. It can be renamed, and it can be removed once nothing is ticked against it.
- **Polaris follows it strictly.** When it designs checks for a control, it's told what each connection is used for. It takes evidence only from a system marked for that kind of thing: changes from FreshService, never assets, and Jira not for changes unless someone marks it so.
- **When nothing is marked for what a control needs, Polaris says so instead of guessing.** For example: "Nothing connected is marked as where you keep assets." That points to the answer, which might be Compass's own Inventory, ticking a system or a manual step.
- **A connection with nothing ticked yet** can still be used, so nothing stops working on the day this lands. But any check Polaris proposes from it says on Review that "FreshService hasn't been told what it's used for", with a link to set it.
- **Polaris (in chat) can read what a connection is used for,** to explain a proposal. Setting it is on screen only, because it's a statement about how the business works.
- Already-approved checks aren't changed. Re-designing a control's checks uses the new setting.

## Done when

- FreshService on E2E Test Company is marked "Changes" only. Asking Polaris to design checks for an asset-related control doesn't propose a FreshService read. It proposes from a system marked for assets, or says nothing connected is marked for assets.
- A change-management control gets a FreshService check, and a connected integration not marked for changes isn't used.
- An area added on one company's connection is offered on every company's connections. One with nothing ticked against it can be removed.
- A connection with nothing ticked still works, and its proposals carry the "hasn't been told what it's used for" line on Review.
- Backend tests cover what Polaris is told and that it can't read a system that isn't marked for the area. Vitest covers the tick-list and adding an item.

**On the chain** (migration for the areas and each company-connection's ticks, plus API changes). Amends ADR 0142, so the amendment goes in the PR.
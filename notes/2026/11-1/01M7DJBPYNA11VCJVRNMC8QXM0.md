---
id: 01M7DJBPYNA11VCJVRNMC8QXM0
created: 2026-11-14T17:40:53.845402Z
updated: 2026-11-14T17:40:56.817499Z
type: task
title: Each connection says what a company uses it for (a tick-list people can add to), and Polaris only takes evidence from the system marked for it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1835
sprint: spsp226
assignee: steve
label:
- improvement
priority: medium
task_status: todo
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
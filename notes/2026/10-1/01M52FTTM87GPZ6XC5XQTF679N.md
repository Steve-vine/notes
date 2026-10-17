---
id: 01M52FTTM87GPZ6XC5XQTF679N
created: 2026-10-16T13:53:41.000051Z
updated: 2026-10-17T03:00:01.007Z
type: task
title: 'The assistant can work Inventory ▸ Settings, except secrets — review intervals, and each cloud and directory connection: how its last read went, test it, read it now, and switch accounts on or off'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1032
sprint: sfzoxya
blocked_by:
- 01M52FSZS2RZE5QX196YJJQRXW
comments:
- id: 01M53WTMKKDE372143C347ABEA
  author: Steve Vine
  at: 2026-10-17T03:00:00.75558Z
  text: |-
    Done — merged to main (PR #1030). Going to staging now with the rest of sprints 73 and 74.

    What the assistant can now do (Inventory admins, as on screen):
    - Read and set the review intervals for technology, data and software assets.
    - List every connection — AWS accounts, Azure subscriptions, Google projects, directory servers — with when it was last read and whether that worked (and why not), its health check, regions refused, how it signs in, and what it found; and every AWS organisation, Azure tenant and Google organisation with its accounts and which are on, off or undecided.
    - Test a connection — a failure comes back in Compass's words (e.g. "update the role from the current template").
    - Read one now (it runs in the background; check back for the result).
    - Change what carries no secret: name, default environment, an AWS account's regions (or stop reading refused ones), a directory's whole domain or OUs.
    - Refresh an organisation's list, switch an account on for a company through the organisation's own sign-in, or leave one off with a reason (asks first).

    Secrets, as you decided: no tool takes a key, a secret or a key file at all — the test checks every Inventory tool's inputs. Nothing returned includes the AWS external ID or role ARN (checked too). Adding a connection, replacing its key, switching an account on with its own key, and removing one stay on screen; the assistant's descriptions say so.

    Tested with the fake AWS account and organisation: test passes, then fails readably when the region listing is refused; read-now queues; regions narrowed; an organisation refreshed, Sandbox switched on (it then appears as a connection) and Old platform left off with a reason.

    Not built: the Azure secret's expiry date — Compass doesn't record it today.
assignee: steve
label:
- feature
priority: medium
task_status: review
---
Sprint 74, MCP - Inventory (ADR in COM-1023). Built on COM-1030. Steve, 2026-10-16: **everything except secrets.**

## What people can ask of it

- **Read (Inventory admins, as on screen):**
  - the **review intervals**: how many months between reviews, for each register;
  - each **connection** (AWS account or organisation, Azure subscription or tenant, Google project or organisation, on-premises directory server):
    - when it was last read and how it went;
    - which kinds or regions were refused, and what to change to fix that;
    - which way it signs in;
    - for an Azure secret, when it expires if Compass knows;
  - for an organisation or tenant, the accounts, subscriptions or projects in it, and which are switched on or left off.
- **Write (Inventory admins, as on screen):**
  - set the review intervals;
  - **test** a connection;
  - **read it now**;
  - **refresh** an organisation's list;
  - **switch an account on**, to be read through the organisation's own sign-in, or **leave it off** with a reason;
  - change a connection's settings that carry no secret: its name, which regions or OUs it reads, and stopping a blocked region.
- **Stays on screen** (Steve's decision): **adding** a connection, **replacing** a key or secret, switching an account on **with its own key**, and **removing** a connection. When asked, the assistant says where on screen to go, and what the setup steps there will ask for.
- **Example:** "Did last night's reads all work? The Azure one failed — test it and tell me why." Or: "switch on the three new accounts in our AWS organisation and read them now."

## Notes (technical)

- Wraps `inventory-settings` GET/PUT. Also wraps the list, test, sync and PATCH (non-secret fields only) routes, plus the organisation sync, switch-on (no key) and leave-off routes, in:
  - `aws_connections.py` and `aws_organisations.py`;
  - `azure_connections.py` and `azure_tenants.py`;
  - `gcp_connections.py` and `gcp_organisations.py`;
  - `directory_connections.py`.
- **Not wrapped:**
  - POST and DELETE on any connection;
  - the `/setup` routes, which hand back templates and Compass's identity. The assistant can describe what setup involves without them.
- **The PATCH and switch-on tools' input schemas have no key, secret or key-file field at all.** It isn't enough to drop the field. Also strip `external_id` and `role_arn` from what is returned (COM-1023).
- One tool set across providers: `inventory_list_connections`, `inventory_test_connection`, `inventory_read_connection_now`, `inventory_update_connection`, `inventory_refresh_organisation`, `inventory_switch_on_account`, `inventory_leave_off_account`. Each resolves its target through `find_connection`.
- Read-now queues a read, so it returns at once with a pointer to check back. Test is synchronous and returns the reason a sign-in failed.
- Leave-off is `destructive`, because those resources stop being read.
- New module `tools/inventory_settings.py`.
- Tests:
  - every tool is hidden without Inventory admin;
  - no tool schema carries a secret field;
  - no result carries `external_id`;
  - a test failure comes back readably.

**Done when:** on staging, the assistant reports how each connection's last read went, tests one and reads it now, and the Settings tab shows the new read.
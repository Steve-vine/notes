---
id: 01M6BBTGXMZBSPRV9NVNDCZQ27
created: 2026-11-01T10:52:28.468676Z
updated: 2026-11-01T14:22:48.2403Z
type: task
title: Every employee can open the user portal; Access Control, Inventory and Vulnerabilities only appear when there's something of yours in them
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1505
sprint: s53765q
comments:
- id: 01M6BPWT13CFVMMSFZH96C097T
  author: Steve Vine
  at: 2026-11-01T14:05:57.667805Z
  text: |-
    Done: PR #1525 merged. New ADR 0138; ADR 0046 amended.
    - Anyone signed in can now open the user portal. An Entra sign-in by an enabled member of the directory who is in no mapped group gets a portal-only account with no roles, where it used to be refused.
    - Guests, disabled accounts and people the directory copy doesn't hold are still refused.
    - Holding no internal role means portal-only, so nobody new reaches internal Compass.
    - Access Control, Inventory, Vulnerabilities and SAP now appear in the portal menu only while you have something in them (a recertification review, an asset you own or co-own, a vulnerability you own, a plan entry). My actions and Security incidents are always there. Vendors keeps its own gate.
    - Side effects:
      - the rating scales and data vocabularies the portal's forms read are now readable by anyone signed in (changing them stays admin-only);
      - a person with no role can be assigned a DDQ question and answers it in the portal.
    - Asset owner, Recertifier and Attester are still granted as before; nobody needs them to get in any more.
    Pre-UAT after the staging deploy. There's no E2E test account with no roles yet, so the no-role menu may be "Couldn't check".
- id: 01M6BQVMXG3GMAJRM71EMP0BC6
  author: Steve Vine
  at: 2026-11-01T14:22:48.240101Z
  text: |-
    Pre-UAT: Partly checked (API).
    - E2E Analyst and E2E Viewer, who hold no portal role, now reach the portal; E2E Asset Owner is portal-only.
    - E2E Analyst has nothing of their own in recertifications, assets, vulnerabilities or plan entries, so all four lists are empty, which means those menu entries are hidden.
    - The Browser smoke passed (25), including the portal journeys.
    Couldn't check: signing in with Entra as someone in no mapped group (it needs a real directory account), and the menu on screen. Steve to look at: sign in as an employee in no Compass group and check you land on the portal with only My actions and Security incidents.
assignee: steve
label:
- feature
priority: high
task_status: review
---
Sprint 101, Roles and Permissions. Raised by Steve on 1 Nov 2026.

## Why

Today you can open the user portal only if you hold one of the five portal roles (Asset owner, Attester, Recertifier, Vendor Approver, Vendor Contact) or can view vendors. Three of those roles (Asset owner, Recertifier, Attester) do nothing except let someone in. Everything inside the portal is already limited to your own work. So the door is a role to manage, not a protection: the portal shows nobody anything that isn't theirs.

## Behaviour

- **Every employee can open the portal.** "Employee" means anyone who signs in to Compass with their work account (assumption, stated for Steve). Someone who isn't in any group mapped to a role gets a portal-only account on first sign-in, with no roles. They can never reach the internal app, as today.
- Suppliers in the Vendor Portal, auditors and Trust Centre visitors sign in separately. They are unaffected.
- **What a person with no roles sees:** My actions and Security incidents (report an incident, and see the reports you've made). Nothing else until work is given to them.
- **Access Control, Inventory and Vulnerabilities appear only when you have something in them,** the same way the other eight entries already work:
  - Access Control: a recertification review you've been given, open or finished.
  - Inventory: an asset you own or co-own.
  - Vulnerabilities: a vulnerability you own, open or closed.
- An entry appears as soon as the work arrives. If you open an empty one by its address, it says there's nothing of yours there; it doesn't show an error.
- Vendors still needs Vendor Contact, Vendor Approver or the ability to view vendors. That's unchanged here.
- Asset owner, Recertifier and Attester are still granted as today, but nobody needs them to get in any more. Whether to retire them is decided in the roles rework later in this sprint, not here.
- The "someone who only signs sees only Attestations" rule becomes the general rule: anyone sees only the entries they have work in.

**Chain:** on the chain (who can sign in and reach the portal changes on the API).

**Done when:**
- An employee in no mapped group can sign in and lands on the portal, seeing only My actions and Security incidents.
- They can report an incident and see it under Security incidents.
- Given a recertification review, an asset or a vulnerability, the matching entry appears. Without one, it doesn't.
- Nobody reaches the internal app who couldn't before.
- People who already use the portal see every entry they had, as long as they have something in it.
- Pre-UAT in E2E Test Company: sign in as a test account with no roles, if there is one, or note that one needs adding. Check the menu shows only My actions and Security incidents. As E2E Analyst, check Inventory appears only while they own an E2E Test Company asset.
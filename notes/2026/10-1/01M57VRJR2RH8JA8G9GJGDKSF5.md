---
id: 01M57VRJR2RH8JA8G9GJGDKSF5
created: 2026-10-18T15:58:22.466439Z
updated: 2026-10-18T22:38:39.373297Z
type: task
title: Anyone with something to sign can sign in to the User Portal with their work account — no group mapping needed — and sees only their own attestations
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1096
sprint: s7s7mn9
blocked_by:
- 01M57VR859FTKHNPFBF5TXVK5X
comments:
- id: 01M58JNFPSMRCTHF42NY08TV2E
  author: Steve Vine
  at: 2026-10-18T22:38:38.296973Z
  text: |-
    Done: PR #1086, built on top of #1085, all checks green, waiting to be merged in order.

    - Anyone a business role asks to sign can sign in with their work account, even if they're in no mapped group. They land on Portal ▸ Attestations.
    - Compass gives them an account before they ever sign in: within the hour, or straight away when content goes on their role for today. So Actions and emails reach them too.
    - Someone who's only there to sign sees Attestations, Actions, Report an incident and My reports. They don't see Vendors, Access Control, Inventory or Plan, and the internal app sends them back to the portal.
    - Staff who already use Compass keep what they have, and sign from the portal as well.
    - The access follows the work. It stays while they have a signature on record, so they can still see what they signed. With nothing to sign and nothing signed, it goes.
    - Someone with nothing to sign is refused at sign-in, with the same message as before. People with no Microsoft account (AD-only directories) don't get an account.

    Two existing gaps were closed along the way:
    - The portal's vendor pages let recertifiers and asset owners read the whole vendor register through the API. Now only people meant to see it can.
    - The dashboard's data (company posture and recent activity) was available to any signed-in account, including portal-only people. It now needs an internal role.
assignee: steve
label:
- feature
priority: high
task_status: review
---
Sprint 78, Attestations (ADR in COM-1092; Steve's decision: anyone with assigned content). Builds on the portal Attestations section (COM-1095).

## Why

Today single sign-on only lets someone in if they're in a directory group mapped to Compass access. Most staff, contractors and temps aren't, so they'd get the email and then be refused at sign-in.

## What people see

- **Someone who holds a role that assigns content**, or who has a signature on record, signs in with their work account and lands on **Portal ▸ Attestations**. They see the portal header and Attestations, and nothing else: no Vendors, Inventory or Access tabs unless something else gives them those.
- **Someone who already has a Compass account** sees Attestations alongside whatever else they have, in the portal and in the user menu.
- **Someone with nothing to sign and no other access** is refused at sign-in as today, with the same message.

## Rules

- This grants attestation access only. It adds no catalogue permission and can't be composed into a role (permission catalogue, "Where the portal sits").
- The access follows the role. When someone stops holding every role that assigns content, their next sign-in shows **Signed** only. They can still see their own history.
- People without an Entra account (AD-only directories) can't sign in this way. They are flagged in the Open view (COM-1099) rather than silently missed.

## Notes (technical)

- In `auth_sso.py`, after `derived_roles_for` returns nothing, admit the sign-in if the directory user is an attestation subject (has a due row or a signature). Create or keep a portal-only account carrying an attestation-only grant. Mind the "derived-only" conversion rules for linked accounts so manual roles aren't lost.
- The portal routing tests and `isPortalOnly` landing logic need the new grant.
- Add the security-relevant cases to tests: refused with nothing to sign; admitted with something; no access to any other portal or internal route.

**Done when:** a role-holder who isn't in any mapped group can sign in and sign, and can reach nothing else.
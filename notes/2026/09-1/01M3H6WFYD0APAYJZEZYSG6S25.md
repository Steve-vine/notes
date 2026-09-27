---
id: 01M3H6WFYD0APAYJZEZYSG6S25
created: 2026-09-27T10:34:31.245824Z
updated: 2026-09-27T10:36:51.925418Z
type: task
title: On-premises Active Directory inception — three setups, one behaviour (ADR)
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 773
sprint: sme8esk
assignee: steve
label:
- brief
priority: high
task_status: todo
---
Scoped with Steve 2026-09-27 (sprint 63). **Gates every other task in the sprint.**

Compass talks to the on-premises Active Directory directly and works in three setups: **AD only**, **Hybrid** (AD synced to Entra — today's estate) and **Entra ID only**. Once set up, nobody using Compass needs to know which directory made a change: requests, roles, reviews, to-dos and history behave the same in all three.

## What the ADR settles

- **The setup is an admin's choice, shown plainly.** A selector on Admin — *AD only / Hybrid / Entra ID only* — saying what each does. It can be changed as the environment changes; **AD only → Hybrid → Entra ID only** is a supported path (an AD-only estate adopts the cloud, then eventually retires AD).
- **One record per person and per group, whatever the setup.** A person keeps one record through every change of setup; their roles, history, reviews and to-dos follow them. In hybrid, the AD account and its Entra copy are one person, never two.
- **Where a change is made.** An object that lives in AD is changed in AD. One that lives in Entra is changed in Entra (Exchange for cloud lists and mailboxes, as today). A change Compass can't make becomes the ADR 0079 to-do — now only the **fallback**: AD not connected, or the object outside the OUs Compass may manage.
- **The boundary in AD is the admin's.** Compass's service account holds rights only over the OUs an admin ticks on the Admin tab. Outside them Compass reads, never writes.
- **Where new starters go.** Each business role names the OU its joiners are created in.
- **Signing in to Compass.** AD only has no Microsoft 365, so no SSO — local Compass accounts only. Signing in with AD credentials is out of scope.
- **Reaching the domain controllers is the cluster's job.** The chart offers a generic, optional network add-on (any sidecar, DNS, volumes). No product is named or required.
- **Single forest.** Multi-forest is out of scope.

## Notes (technical)

- **Identity.** Today every mirror PK and FK is the Entra object id — `business_role_groups`, `governed_memberships`, `directory_user_business_roles`, `access_changes`, `access_manual_steps`, `recert_*`, `sso_group_role_mappings`, `shared_mailboxes`. AD only has no Entra id. Proposal: a Compass-own key per directory object carrying anchors `entra_id` and `ad_object_guid` (+ SID, DN, sAMAccountName). Hybrid match: objectGUID / ms-DS-ConsistencyGuid ↔ `onPremisesImmutableId` — verify the tenant's sourceAnchor.
- **One write path (ADR 0045 §5.1) widens:** `tasks/access_execute.py` stays the only module that writes to Graph, Exchange **or LDAP**; restate the grep-provable claim.
- **Routing per object:** AD (on-premises source, AD connected, inside a managed OU) → Graph/Exchange (cloud) → manual step.
- **Confirmation:** an AD write is confirmed by the AD read (immediate), not by the Entra mirror after Entra Connect's ~30 min cycle; the Entra copy converges.
- **Transport:** LDAPS (636) with an admin-supplied CA certificate; `ldap3` (pure Python, sync — fits Celery and ADR 0002). Setting `unicodePwd` requires an encrypted channel.
- **Only the worker pod talks LDAP.** *Test connection* is dispatched to the worker (the ADR 0075 §1 pattern), so the API pod needs no network reach.
- **Amends:** ADR 0045 (§3 scope, §5 write path), 0046 (no SSO in AD only), 0079 (the to-do becomes the fallback).

**Done when:** the ADR is merged and the sprint's remaining tasks still match it (or are updated to).
---
id: 01M3H6WFYD0APAYJZEZYSG6S25
created: 2026-09-27T10:34:31.245824Z
updated: 2026-09-27T11:04:59.907823Z
type: task
title: On-premises Active Directory inception — three setups, one behaviour (ADR)
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 773
sprint: sme8esk
comments:
- id: 01M3H858SMSQ6A6SGH4AN723K5
  author: Steve Vine
  at: 2026-09-27T10:56:47.412048Z
  text: |-
    **The rule for a change Compass can't make** (Steve, 2026-09-27). It holds in every setup, for AD and for the cloud alike, and the ADR states it in these terms:

    1. **Something broke** (the directory is unreachable, times out or returns an error): the change is **Failed**, with the reason and a **Retry**. It never becomes a to-do.
    2. **Not set up** (there's no connection for that directory in this setup, the object is outside the managed OUs, or Compass's account has no rights in a ticked OU): a **manual to-do** (ADR 0079).
    3. **Not allowed** (the object isn't governable, e.g. a dynamic or role-assignable group): **refused in Compass** when the request is raised. It never becomes a to-do.

    Routing is decided before the write, from configuration. A failure at the write is always case 1. This supersedes the earlier wording in COM-783, which said "if AD goes away, changes fall back to to-dos".
assignee: steve
label:
- brief
priority: high
task_status: backlog
---
Scoped with Steve 2026-09-27 (sprint 63). **Gates every other task in the sprint.**

Compass talks to the on-premises Active Directory directly and works in three setups: **AD only**, **Hybrid** (AD synced to Entra — today's estate) and **Entra ID only**. Once set up, nobody using Compass needs to know which directory made a change: requests, roles, reviews, to-dos and history behave the same in all three.

## What the ADR settles

- **The setup is an admin's choice, shown plainly.** A selector on Admin — *AD only / Hybrid / Entra ID only* — saying what each does, and which connections each needs. It can be changed as the environment changes; **AD only → Hybrid → Entra ID only** is a supported path (an AD-only estate adopts the cloud, then eventually retires AD).
- **One record per person and per group, whatever the setup.** A person keeps one record through every change of setup; their roles, history, reviews and to-dos follow them. In hybrid, the AD account and its Entra copy are one person, never two.
- **Where a change is made.** An object that lives in AD is changed in AD. One that lives in Entra is changed in Entra (Exchange for cloud lists and mailboxes, as today).
- **What happens to a change Compass can't make** (Steve, 2026-09-27). This applies in every setup, to AD and cloud alike:
  1. **Something broke** (unreachable, timed out, error): **Failed**, with the reason and a **Retry**. It never becomes a to-do.
  2. **Not set up** (no connection for that directory in this setup, object outside the managed OUs, or no rights in a ticked OU): a **manual to-do** (ADR 0079).
  3. **Not allowed** (not governable): **refused in Compass** when the request is raised.
- **The boundary in AD is the admin's.** Compass's service account holds rights only over the OUs an admin ticks on the Admin tab. Outside them Compass reads, never writes.
- **Where new starters go.** Each business role names the OU its joiners are created in. Someone with several roles stays in the OU of the role they joined with.
- **Signing in to Compass.** AD only has no Microsoft 365, so no SSO — local Compass accounts only. Signing in with AD credentials is out of scope.
- **Reaching the domain controllers is the cluster's job.** The chart offers a generic, optional network add-on (any sidecar, DNS, volumes). No product is named or required.
- **Single forest.** Multi-forest is out of scope.

## Notes (technical)

- **Identity.** Today every mirror PK and FK is the Entra object id — `business_role_groups`, `governed_memberships`, `directory_user_business_roles`, `access_changes`, `access_manual_steps`, `recert_*`, `sso_group_role_mappings`, `shared_mailboxes`. AD only has no Entra id. Proposal: a Compass-own key per directory object carrying anchors `entra_id` and `ad_object_guid` (+ SID, DN, sAMAccountName). Hybrid match: objectGUID / ms-DS-ConsistencyGuid ↔ `onPremisesImmutableId` — verify the tenant's sourceAnchor.
- **Routing is decided before the write, from configuration, never health:** AD (on-premises source, AD configured, inside a managed OU with rights) → Graph/Exchange (cloud, Entra configured) → manual step. A failure at the write is always case 1 (fail + retry), never a step. Today's "on-premises mastered" Graph error → step stays correct: in Entra ID only, AD is not set up.
- **One write path (ADR 0045 §5.1) widens:** `tasks/access_execute.py` stays the only module that writes to Graph, Exchange **or LDAP**; restate the grep-provable claim.
- **Confirmation:** an AD write is confirmed by the AD read (immediate), not by the Entra mirror after Entra Connect's ~30 min cycle; the Entra copy converges.
- **Transport:** LDAPS (636) with an admin-supplied CA certificate; `ldap3` (pure Python, sync — fits Celery and ADR 0002). Setting `unicodePwd` requires an encrypted channel.
- **Only the worker pod talks LDAP.** *Test connection* is dispatched to the worker (the ADR 0075 §1 pattern), so the API pod needs no network reach.
- **Amends:** ADR 0045 (§3 scope, §5 write path), 0046 (no SSO in AD only), 0079 (the to-do is now specifically "not set up").

**Done when:** the ADR is merged and the sprint's remaining tasks still match it (or are updated to).
---
id: 01M1PKRFYYSDJJP3SV3YJP3TKD
created: 2026-09-04T16:24:20.190918Z
updated: 2026-09-04T16:30:09.593223Z
type: task
title: A capability provider is picked from 6,000 entities, and need not be a member
project: 01KX671DATY39VW6GWK3M2T3DN
number: 775
sprint: s7nj09w
assignee: steve
label:
- improvement
priority: high
task_status: todo
tech: null
---
Smoke finding, ISE-765 (#705). The Capabilities editor picks providers by
searching the whole estate. It should be offering this application's members.

**The consequence is not cosmetic.** `PUT /business-applications/{id}/capabilities`
validates only that the entity **exists**
(`business_applications_api.py:868-875` — "a provider names an entity that does
not exist"). Nothing checks membership. So a provider may be an entity the
application does not contain, and then:

- It never appears in the Members table, because that table is built from
  `composes` edges (`business_applications_api.py:636-642`). Its Role is
  therefore invisible — the Role column can only ever show a member.
- It still drives the application's derived state. `derive()` computes `graded`
  from every provider's entity id and subtracts it from `member_ids`
  (`business_capabilities.py:318-319`), and `capability_states` reads its
  signals regardless of membership. An entity outside the application decides
  whether the application is healthy, degraded or down — and now, after ADR
  0110, who gets woken up.
- It is exempt from the prune as a capability provider, so it is durable, and
  durably invisible.

**Why the estate-wide search is there.** `EntitySearchSelect` was written for
ADR 0108 §2 — the rule that names one entity outright, the legacy box on site
that no tag describes. There it is exactly right: you are reaching into the
estate to pull something *in*. A capability provider is the opposite motion —
you are describing structure among things already in the application — and the
same component was reused for both.

**Proposed**

- Offer the members list first: the provider picker's default option set is the
  application's resolved membership, no typing required, in the order the
  Members table shows. Choosing a provider becomes recognition rather than
  recall, and the common case takes one click.
- Keep an estate search as a deliberate second step, if we want it at all —
  "not in this application? search the estate" — so that naming an outside
  entity is a decision rather than the only path.
- If an outside entity IS named, it must not stay invisible: either the API
  refuses it (422, "a provider must be a member of this application"), or the
  Members table shows it with a badge saying it provides a capability but is not
  a member. Silently letting it set the application's state is the option to
  rule out.
- Decide which, and record it — ADR 0109 §1 says a capability is "something the
  application needs, satisfied by an ordered provider list" and is silent on
  whether a provider must be a member. That silence is what produced this.

**Related, same component**

`EntitySearchSelect` does not pass `ENTITY_DROPDOWN_COMBOBOX` /
`ENTITY_DROPDOWN_STYLES` (`lib/entityPicker.ts`), which the three other estate
pickers all use. That shared shape was ISE-698's fix for exactly this estate: a
fixed 340px dropdown wrapping long names over three lines, when the
distinguishing characters are at the END — "four `kong` results on staging
differ only after 86 identical leading characters". The new picker reintroduces
the defect ISE-698 removed, in both its usages, on a 340px field. See also
ISE-774 for what this picker does when the request fails.

---
id: 01M1PKRFYYSDJJP3SV3YJP3TKD
created: 2026-09-04T16:24:20.190918Z
updated: 2026-09-04T18:29:27.3462Z
type: task
title: A capability provider is picked from 6,000 entities, and need not be a member
project: 01KX671DATY39VW6GWK3M2T3DN
number: 775
sprint: s7nj09w
comments:
- id: 01M1PTXJSCYA7AD9HSEG8MY8N5
  author: Steve Vine
  at: 2026-09-04T18:29:26.956586Z
  text: |-
    Shipped as PR #716, merged to main (54ea228a). Records **ADR 0112 — a capability provider is a member of the application it serves**.

    The task asked which of the two options to take, and to record it. **The API refuses it.** ADR 0109 §1 was silent on where providers come from; the rule follows from what the two concepts mean. Membership answers *what is this application made of*; a capability answers *what does it need, and which of its parts provide that*. A thing that decides whether an application is healthy is, by any ordinary reading, part of it — and after ADR 0110 it decides who gets woken up. The alternative, an application whose state is set from outside its own boundary, makes the boundary decorative.

    Nothing is lost by refusing: ADR 0108 §2's entity rule already says "this outside thing is part of my application", and does it visibly, in the Members table. The operator's route is one step longer and one step more honest.

    **§2 — the editor offers members.** New `MemberSelect`: the options are the resolved membership, in the Members table's order, nothing to type. No estate-search fallback, because after §1 it could only offer choices the API will refuse.

    **§3 — drift is surfaced, not silent.** This is the half the task's either/or did not cover, and it is needed: membership re-resolves, so a write-time rule cannot be the whole answer. A provider still in the estate but no longer a member is reported `outside` and badged **"not a member"** on the capability card. It keeps its position and keeps deciding the state — dropping it silently would move an application's derived state with nobody saying so, which is the fault the ADR exists to stop — and the next edit of the list has to resolve it. `outside` is distinct from `missing`: gone from the estate is not the same condition as not part of this application.

    **Related, same component:** `EntitySearchSelect` now passes `ENTITY_DROPDOWN_COMBOBOX` / `ENTITY_DROPDOWN_STYLES`, so ISE-698's fix is no longer reintroduced. It keeps exactly one caller — the rule editor of ADR 0108 §2, where reaching out into the estate is the whole point.

    Four new integration tests, three frontend. Full suites green.
assignee: steve
label:
- improvement
priority: high
task_status: review
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

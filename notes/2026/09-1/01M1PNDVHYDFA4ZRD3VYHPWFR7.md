---
id: 01M1PNDVHYDFA4ZRD3VYHPWFR7
created: 2026-09-04T16:53:28.766144Z
updated: 2026-09-04T17:23:44.411978Z
type: task
title: A rule that matches nothing should say what nearly matched
project: 01KX671DATY39VW6GWK3M2T3DN
number: 776
sprint: s7nj09w
assignee: steve
label:
- improvement
priority: high
task_status: active
tech: null
---
Smoke finding, 2026-09-04. Reported as "status page checks can't be added to a
Business Application". They can; the rule was matching on the wrong tag key by
one character, and ISE said so without saying what would have worked.

**What actually happened, in full.** `MongoDB Atlas.prod` holds one rule:
`{role: platform, value: mongodb-atlas, environment: prod}`. The `platform` role
is bound to the tag key **`mp_project`** (underscore). The two status-page
entities carry **`mp-project`** (hyphen):

```
MongoDB Atlas — MongoDB Cloud          mp-project:mongodb-atlas, mp-env:prod, mp-geo:uk/us
MongoDB Atlas — MongoDB Atlas Search   mp-project:mongodb-atlas, mp-env:prod, mp-geo:uk/us
```

Verified in the API pod: the rule resolves to key `mp_project`, dimension
`infrastructure`, 0 members. Substituting `mp-project` for the same value and
environment resolves to **2 members** in every dimension. Nothing else about the
rule, the entity type (`application`), the `operated_by: external` attribute or
the status-page source is a factor — status page checks are ordinary estate
entities and a Business Application rule reaches them fine.

**ISE detected this correctly.** The membership machinery did everything ADR 0096
and ISE-654 designed it to do: `at_fault` is true, `match_count` is 0, the
Membership Rules section shows a red "1 of 1 rules match nothing" alert, and an
estate Observation was raised three minutes after the tag landed —

> MongoDB Atlas.prod: the rule `mp_project:mongodb-atlas in prod` matches nothing

So this is not a missing-signal bug. **It is a message that stops one sentence
short.** The reason names `mp_project:mongodb-atlas`; the estate contains
`mp-project:mongodb-atlas` on 99 entities, 2 of them carrying exactly the value
typed. A one-character difference between an underscore and a hyphen is the
single hardest class of error for a person to see and among the easiest for a
database to find, and ISE is sitting on the tag table that answers it.

**Proposed**

- When a predicate rule resolves to zero members, look for the near miss before
  writing the fault text: same value under a different key, same key with a
  different value, and keys within a small edit distance of the resolved one.
  Then say it — "Nothing carries `mp_project:mongodb-atlas`. **`mp-project:mongodb-atlas`
  matches 2 entities** — did you mean that key?" — in the rule row's fault
  tooltip, the Membership Rules alert, and the estate Observation's body.
- Where the near miss is a key that a governed role could reach, offer the
  action: add it as an alias of the bound key, or rebind the role. Both are Tag
  Dictionary edits an admin can already make; the point is knowing which.
- Same treatment for the region and environment halves of a rule, which fail the
  same way and are equally invisible.

**Secondary, same screen.** The rule editor's Value, Environment and Region are
bare `TextInput`s (`ruleDrafts.tsx:207-235`) — only Key is a select. There is no
suggestion from the estate and no live match count while typing, so the author
learns the rule is empty only after saving. A count beside the value as it is
typed would move this from "detected afterwards" to "impossible to type".

**Estate hygiene, separate from the code** — the `platform` role is the only one
of four still bound to the legacy convention. `application`→`mp-app`,
`environment`→`mp-env`, `region`→`mp-geo`, but `platform`→`mp_project` (alias
`project`, 426 hosts). The newer `mp-project` key covers 99 entities across six
types and no role reaches it. Fix by adding `mp-project` as an alias of the
`mp_project` key — the same mechanism `project` already uses. Until then every
Business Application rule stated against `platform` is blind to the `mp-`-tagged
estate.

**One other Business Application is already in this state** —
`Kora.prod.uk: the rule kube_deployment:openanswer-app in production in UK matches nothing`,
open since 2026-09-02.

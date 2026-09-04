---
id: 01M1PNDVHYDFA4ZRD3VYHPWFR7
created: 2026-09-04T16:53:28.766144Z
updated: 2026-09-04T19:09:51.449719Z
type: task
title: A rule that matches nothing should say what nearly matched
project: 01KX671DATY39VW6GWK3M2T3DN
number: 776
sprint: s7nj09w
comments:
- id: 01M1PX7J20RZXBQWXC81WDREMY
  author: Steve Vine
  at: 2026-09-04T19:09:51.040281Z
  text: |-
    Shipped as PR #718, merged to main (3a39ec12).

    The report was right that this is not a missing-signal bug, and the fix is where it said: the message stopped one sentence short.

    **What nearly matched.** New `tag_near_miss`. Same value under another key first — the reported case, and the one where the author's own words prove what they meant — then the same key with a value a short edit away. Separator shape is checked *before* edit distance, because `-` and `_` are one character to the person typing and two to Postgres. Edit distance orders the candidates and never filters them: a key carrying the exact value typed is worth offering however far its name sits from the one used.

    A near miss without an action is trivia, so the sentence ends in the fix. For a role-stated rule that is a Tag Dictionary edit — add the key as an alias, or rebind the role — because changing the rule alone would leave every other rule on that role just as blind.

    **Which half.** The task asked for the same treatment for environment and region, and that turned out to need something underneath it: a rule ANDs up to three predicates and reported one verdict, so "matches nothing" never said which half was empty. The halves are priced separately now and the empty one is named.

    That exposed a second emptiness worth saying differently (ADR 0056's rule): when every half matches on its own and nothing carries all of them, the rule over-narrows. Reporting that as a typo would send an author hunting for one that is not there, so the counts are quoted instead — "Each half of this rule matches on its own — `app:chinwag` (1) and `env:staging` (1) — but nothing carries all of them together."

    All three surfaces named in the task carry it without further work: the rule row's fault tooltip, the Membership Rules alert, and the Observation body already render `fault_reason`, and there is still exactly one of it.

    **The secondary item, which turned out to be the more valuable half.** `GET /business-applications/rule-preview` resolves an unsaved rule through the same `rule_members` + `fault_reason` path, and the editor shows a live match count beside the value with the reason under the row — not behind a hover, because the near miss IS the answer and hiding it would leave it as undiscoverable as the alert it replaces. Detection moves from "afterwards, on a screen you have left" to "while you are typing". One implementation on purpose: a cheaper second one would be a second answer, and the two would disagree on exactly the day it mattered.

    **Still outstanding — the estate hygiene item, which is yours to make.** Adding `mp-project` as an alias of the `mp_project` key (the same mechanism `project` already uses) is a Tag Dictionary edit against live staging data that moves real Business Applications' membership. The task separates it from the code and I have not made it. Until it is, every Business Application rule stated against `platform` stays blind to the 99 `mp-`-tagged entities. `Kora.prod.uk` is in the same state, open since 2026-09-02 — worth checking whether the new near-miss text now names its answer.

    **CI note.** The backend job failed twice at `setup-uv` before passing, and it was not this code: `raw.githubusercontent.com` resolves to AAAA records only in the g5 cluster while IPv6 egress is blackholed. curl falls back to IPv4 after ~7.7s; Node's `fetch` does not fall back and dies in ~1s. `backend-lint` runs the identical action and passed on the same run, so it is a flaky path rather than a hard block — but it will keep costing re-runs, and pinning a `version:` on `setup-uv` would remove the manifest fetch entirely. Worth its own task if it recurs.

    Five backend tests on the near miss, two on the preview endpoint, five frontend on the live count.
assignee: steve
label:
- improvement
priority: high
task_status: review
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

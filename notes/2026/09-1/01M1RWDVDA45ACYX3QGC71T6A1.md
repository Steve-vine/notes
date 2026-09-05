---
id: 01M1RWDVDA45ACYX3QGC71T6A1
created: 2026-09-05T13:34:17.514882Z
updated: 2026-09-05T14:22:02.836296Z
type: task
title: A DataDog alert names its Business Application with ise-ba, and gets priced
project: 01KX671DATY39VW6GWK3M2T3DN
number: 786
sprint: s7nj09w
comments:
- id: 01M1RZ55R0JYQ4PBQC8DAYTD9A
  author: Steve Vine
  at: 2026-09-05T14:21:58.912074Z
  text: |-
    Done — PR #726 merged to main (2026-09-05). ADR 0115 §1-§5 built.

    - `ise-ba` seeded as a governed Tag Dictionary key, open values, no expected types (meaningful on signals only). Lands on the next app start via the additive seed.
    - `signal_attribution.Resolver`: `ise-ba:` values → applications by display name; current names win over former ones; more than eight values is refused with a stated reason, never truncated.
    - Correlator second door: an entity-less signal with a resolving tag is judged by ADR 0110's matrix (a tag-matched signal lands on the unassessed column with its own sentence — "named outright by this signal, which no capability covers" — rather than being told to describe a member it does not have). Entity + tag = judged against the union, worst decides.
    - Model decisions (migration 0153): `signal_decision.considered` is a JSONB snapshot `[{application_id, name, priority, reason}]`, not a child table — read on one screen, never queried across, and a name outlives its application. `business_application.former_names` is a JSONB list maintained by `rename()`; renaming back lifts the name out.
    - Unmatched values: one Observation per VALUE on the estate pass (`obs/ise-ba-unmatched/<value>`), with what nearly matched (separator shape → prefix → edit distance ≤ 2), recovered by absence. `unsubjected` survives, narrowed, and its advice names the tag.
    - Screens: the decision panel lists every application considered (deciding one filled); the BA page gains "Signals naming this application" and a "Formerly …" line after a rename.

    Watch on staging: 86 unsubjected monitor_alerts become priceable once tagged — expect first-pass escalations nobody has seen before (ADR 0115, Consequences).
assignee: steve
label:
- feature
priority: high
task_status: review
tech: null
---
Build ADR 0115 §1-§5. The load-bearing slice: it turns **86 permanently
unjudgeable `monitor_alert` signals** into priced ones.

**Today** `correlator.judge()` opens with `applications_for(finding.entity_id)`
and returns `reason: unsubjected` on a null entity, before any capability or
priority is considered (`correlator.py:206-215`). Every synthetic monitor sits
there. Staging: `graded 3902 / unsubjected 117 / uncovered 71 / escalated 6`.

## Scope

**The governed key.** `ise-ba` as a Tag Dictionary key, `value_mode: open`
(§3). Discoverable, in the tag cloud and compliance report like any other key.
Values are **not** validated against live application names.

**The resolver.** A signal's `ise-ba:` tags → Business Applications, by
`display_name(app_name, environment, region)`. Split on the **first colon only**
— DataDog values contain colons (`probe_dc:aws:eu-west-1`). Cap at **eight
applications per signal** (§2); beyond that, take none and say so rather than
silently truncating.

**The Correlator's second door.** `applications_for` gains the tag-matched set.
An entity-less signal with a resolving `ise-ba:` tag is judged by ADR 0110's
matrix exactly as an entity-mediated one — the existing per-application loop and
`_outranks` need no change (§4). `unsubjected` survives, narrowed to signals
naming neither an entity nor an application; its detail sentence must stop
saying "attach an entity" as the only advice.

**Rename alias (§5) — same change, not a follow-up.** ADR 0114 made `app_name`
renameable, so without this the first rename silently unpicks every tag naming
that application and drops those signals back into the bucket that can never
escalate. A rename keeps the old `app_name` resolvable by `ise-ba:`.

**Unmatched values (§3).** Call `tag_near_miss` — it is documented as "only ever
consulted on the empty path", so it is free here. Raise an Observation on the
same reasoning ADR 0109 §4 gives for an application with no criticality: a
stated intent ISE could not honour is worth saying out loud, not absorbing.

## Screens

- **Signal decision panel** (`SignalDecisionPanel.tsx`): where a signal resolved
  to several applications, name **every** one it was judged against and say the
  worst decided. §4 makes this a requirement, not a nicety — a second `ise-ba:`
  tag is additive, never replacing, so a forgotten tag silently *raises*
  priority and the panel is the only place that becomes visible.
- **Business Application page**: a section for tag-matched signals. They have no
  entity and so no row in the Members table — they belong to the application
  without belonging to anything *in* it. Without this a stray tag is discoverable
  only from the monitor, which is where nobody looks.

## Model

`SignalDecision` holds one `business_application_id`. Recording the full
considered set needs either a column or a child table — decide which, and note
that `SIGNAL_DECISION_REASONS` is a check constraint (`models.py:608`), so a new
reason value is a **widening** swap and safe in that direction only.

## Acceptance

- A DataDog alert tagged `ise-ba:kora.prod.uk`, naming no entity, is escalated or
  graded by the same matrix as an entity-mediated signal, and its decision names
  the application.
- Two `ise-ba:` tags on one signal: priced by the worst, both named in the panel.
- Rename the application; the existing tag still matches.
- `ise-ba:kora.prod.uk-typo` raises an Observation naming what nearly matched.
- Nine `ise-ba:` tags: refused with a stated reason, not silently truncated.
- An entity-less signal with no `ise-ba:` tag is still `unsubjected`.

**Do not include the synthetic fan-out collapse** — separate task, because it
changes a finding key and carries the ISE-153 churn hazard.

---
id: 01M1RWDVDA45ACYX3QGC71T6A1
created: 2026-09-05T13:34:17.514882Z
updated: 2026-09-05T13:40:48.957231Z
type: task
title: A DataDog alert names its Business Application with ise-ba, and gets priced
project: 01KX671DATY39VW6GWK3M2T3DN
number: 786
sprint: s7nj09w
assignee: steve
label:
- feature
priority: high
task_status: todo
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

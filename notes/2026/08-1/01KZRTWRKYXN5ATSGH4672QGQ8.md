---
id: 01KZRTWRKYXN5ATSGH4672QGQ8
created: 2026-08-11T16:36:05.374052Z
updated: 2026-08-12T13:51:37.480128Z
type: task
title: 'Blast radius: an alert names the Business Applications and Services it hits'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 656
sprint: sj9fsph
comments:
- id: 01KZSD908APSFV2QZTPA72P32A
  author: Steve Vine
  at: 2026-08-11T21:57:20.777944Z
  text: |-
    Done — stacked on ISE-655, PR to follow it onto main.

    All six points in the brief are addressed, and the diagnosis held up: **three separate faults in one read**, any one of which alone would have made a cluster failure return "nothing affected".

    1. `IMPACT_EDGE_TYPES` gains `runs-on` and containment `part-of`.
    2. **The inverted comment was exactly as described.** `test_the_impact_walk_direction_is_pinned` now holds both halves down — upstream from a host yields its workloads, upstream from a workload reaches nothing — because the argument is genuinely easy to talk yourself back into. There was also an existing test (`test_impact_follows_consequence_not_containment_downward`) *asserting the inverted claim*; I rewrote it to state the corrected rule rather than deleting it, since the reasoning is the useful part.
    3. `part-of` admitted and judged by entity type.
    4. **The rollup now runs over the dependent set.** This was the fault that mattered most: even with the walk fixed, a cluster composes into nothing, so the rollup would still have named zero Business Applications.
    5. Proportions on both layers — `chinwag.prod (1 of 8)` on the panel and in the summary line.
    6. `HEADLINE_TAG_KEYS` `tier` → `impact`.

    **One extra guard, not in the brief.** Admitting `part-of` opens a case the target-type filter doesn't close: if the *subject* of the walk is itself a group or identity-group, an upstream walk reports every member as a casualty — 20k users for one identity-group. So a lens as the subject drops `part-of` from the walk entirely. A group doesn't fail, so this costs nothing and bounds the worst case.

    Also: a rollup with no proportion renders as a plain name, never a fabricated `(0 of 0)` — a missing proportion is a gap in what ISE knows, and printing zeroes would state something false about the blast radius.
- id: 01KZSF2W3MAG7F98T4GA0Z2RHX
  author: Steve Vine
  at: 2026-08-11T22:28:57.076844Z
  text: 'Merged to main as de8a62a (PR #608), all checks green.'
assignee: steve
label:
- feature
priority: medium
task_status: done
---
The impact read currently answers "nothing affected" for the two cases that matter most — a whole production cluster failing, and a shared database failing. Fix the traversal and the rollup. This is the same mechanism as the inferred-entities list, walked upstream instead of downstream.

- **`IMPACT_EDGE_TYPES` is `["depends-on", "routes-to"]`** — add `runs-on` and containment `part-of`. A production cluster failing today returns ZERO dependents, because workloads reach it only via `runs-on` / `part-of`.
- **The stated reason for excluding `runs-on` does not hold.** `impact.py:30` says the reverse walk would claim a workload failing takes its node down. The walk is `direction="upstream"` (target→source, `estate.py:34`), and the edge is `workload -runs-on-> host`, so upstream from a host yields its workloads — the correct direction. Upstream from a workload can never reach the host. Include it, and pin the direction with a test.
- **`part-of` is overloaded**: containment (namespace→cluster, host→network) IS consequence; group membership (workload→group, user→identity-group) is a lens and is not. Filter by TARGET type rather than excluding the key — that also drops 20,721 of 23,449 part-of edges from the walk, keeping it bounded.
- **Roll up over the dependent set.** `_applications_of(db, entity.id)` (`impact.py:270`) reads the subject's own composition only, so a cluster failure would list 40 workloads and name zero Business Applications.
- **Report proportions, not just a set.** "3 of 18 members affected" — `_member_counts` already exists. One host failing and a whole cluster failing are not the same event, and this is where the `impact:` tag finally earns its place (nothing reads it today).
- **`HEADLINE_TAG_KEYS`** (`impact.py:45`) still names `tier`, which the tagging strategy renamed to `impact`; neither key exists in the estate. Fix or drop.

Surface: the impact panel on entity and incident names the Business Applications and Business Services hit, with proportions.
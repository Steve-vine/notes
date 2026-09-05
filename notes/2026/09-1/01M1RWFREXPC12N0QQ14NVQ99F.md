---
id: 01M1RWFREXPC12N0QQ14NVQ99F
created: 2026-09-05T13:35:20.029142Z
updated: 2026-09-05T15:25:44.952723Z
type: task
title: 'Signal Context: describe the monitor from the page where its alert landed'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 789
sprint: s7nj09w
blocked_by:
- 01M1RWDVDA45ACYX3QGC71T6A1
- 01M1RWF4BT0QKT0NTYCR7JPJH0
comments:
- id: 01M1S2SXJ32ZKZQRDWDDACT9GH
  author: Steve Vine
  at: 2026-09-05T15:25:44.387424Z
  text: |-
    Done — PR #730 merged to main (2026-09-05). ADR 0115 §8 tier 3.

    - **Build question answered**: a new `signal_annotation` table (migration 0155) keyed on `(system_id, monitor_ref)` — `monitor/{id}` for DataDog, the source key where a source has no grouping — not `entity_annotation` against a minted monitor entity, which waits on the deferred monitors-as-entities decision. Shape mirrors `entity_annotation`: authored, sticky, untouched by discovery; keyed on the monitor so a signal recovering or being pruned never touches it. One row per monitor, replaced not appended, audited.
    - **Authored from the Business Application page** (the ISE-786 tag-matched section gains a Signal Context column in the Members table's Entity Context shape) and from the signal detail as a second door beneath tiers 1 and 2. Operator-gated.
    - **Read path**: `signal_context.enrich()` is called by the Oracle's `get_affected_entity_context`, Assist's twin, and the MCP incident brief — the same place Entity Context is read. For an entity-less signal the authored sentence is the whole answer where before there was only "no entity resolved".
    - Acceptance verified in tests: survives recover/re-fire; same context on a different group of the same monitor; reaches the brief; viewer 403 / operator writes; a monitor with no context keeps ISE-788's honest empty line.

    Staging deployed at the merge commit with all six tasks.
assignee: steve
label:
- feature
priority: medium
task_status: review
tech: null
---
Build ADR 0115 §8 tier 3 — the rung only a human can fill. Follows ISE-788,
which supplies the two tiers beneath it and the empty-state that prompts this one.

**The gap.** ADR 0108 §6 composes an explanation from the **Entity Context** of
the affected thing, the **Business Application Context** of what it is part of,
and the Business Service above. A tag-matched signal has no entity, so the bottom
rung — the only one describing *the specific thing that failed* — is missing by
construction. "kora.prod.uk is our call-routing platform" does not explain what a
failing Message Centre check means.

**Signal Context is that rung.** Not a fourth concept: it is what Entity Context
is for a signal with no entity, and it makes ADR 0108 §6's chain whole rather
than longer.

## Two design constraints from the ADR

**Authored against the monitor, never the alert.** The alert instance is
ephemeral — it recovers and re-opens on the same row as the source's state moves
— while `monitor_id` / `synthetics_public_id` are durable and stable across every
fire. Author once, applies forever.

**Authored from the Business Application's page**, beside the members. This is
ADR 0108 §4's argument transplanted intact: `entity_annotation` held **zero rows**
for months because describing one thing at a time from its own page is not a job
anybody sits down to do, and the fix was to put authoring where somebody is
already looking. The same holds for a monitor whose alert is sitting unexplained
on an application somebody is already reading. Authoring only from the signal
detail would rebuild the exact failure ADR 0108 §4 diagnosed.

## Build question

Either a new `signal_annotation` keyed on `(system_id, monitor reference)`, or
reuse `entity_annotation` against a minted monitor entity. The latter depends on
ADR 0115's **deferred** monitors-as-entities decision, so it is likely the former
unless that lands first. If a new table: `entity_annotation`'s shape is the
model — authored, sticky, exempt from the prune, and never touched by discovery
(ADR 0028 §1, ADR 0039).

## Read path — required, not optional

Anything reading Entity Context reads Signal Context in the same place:
`estate.investigation_context` and `bound_investigation_context`, and therefore
`ai/tools.py`, `ai/assist_tools.py` and `mcp_server/briefs.py`. Without this the
authoring goes into a void, which is precisely how the annotation register sat
empty and unread since ADR 0028.

## Screens

- **Business Application page** — the tag-matched signals section from ISE-786
  gains an inline editor, the same shape as the Members table's Entity Context
  cell: a dashed "Describe what this monitor watches…" invitation when empty, an
  edit icon when set.
- **Signal detail** — shows the authored context beneath tiers 1 and 2, and is a
  second door to editing it, not the only one.
- Gate on `operator`, matching Entity Context. ADR 0113 made *declaring a
  capability* an admin act because it is a structural claim; describing what a
  monitor watches is local knowledge, which ADR 0113 explicitly leaves to the
  desk.

## Acceptance

- Context authored against a monitor from the Business Application page survives
  the alert recovering and re-firing.
- The same context appears on every signal from that monitor, including a
  different group.
- It reaches the Oracle: an investigation rooted on a tag-matched signal has the
  authored sentence in its context.
- An operator can author it; a viewer cannot.
- A monitor with no context still shows ISE-788's honest empty line rather than a
  blank.

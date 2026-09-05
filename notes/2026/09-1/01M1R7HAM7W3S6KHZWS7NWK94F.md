---
id: 01M1R7HAM7W3S6KHZWS7NWK94F
created: 2026-09-05T07:29:11.303161Z
updated: 2026-09-05T07:29:11.303161Z
type: task
title: What does this alert mean? — context for a signal that has no entity
label: brief
assignee: steve
priority: high
task_status: backlog
project: 01KX671DATY39VW6GWK3M2T3DN
number: 784
tech: null
---
Follow-on from ISE-782. Once `ise-ba:` attributes an entity-less alert to a
Business Application, the alert escalates — and still says nothing about what it
means. This is what fills that gap.

**Why the gap exists.** ADR 0108 §6 makes explanation a composition: the **Entity
Context** of the affected thing, the **Business Application Context** of what it
is part of, and the Business Service above. A tag-matched synthetic has no
entity, so the bottom rung — the only one that describes *the specific thing that
failed* — is missing by construction. "kora.prod.uk is our call-routing platform"
does not explain "Message Centre US is failing".

**The kind dictionary cannot fill it.** Every DataDog monitor arrives as
`kind: monitor_alert` — one kind for all of them. It can say "a DataDog monitor
fired"; it can never say "customers cannot retrieve messages".

Three tiers, cheapest first. The first two need no authoring at all.

---

**1. What ISE already knows and does not say.**

A synthetic's `details` are richer than the sentence ISE builds from them:

```json
{"type": "synthetics alert", "state": "No Data", "group": "total",
 "monitor_id": 39317789, "synthetics_public_id": "kdd-mk9-z72",
 "tags": ["MP-Service:OpenRita", "env:Production", "probe_dc:aws:eu-west-2",
          "check_type:browser", "check_status:paused", "ci_execution_rule:blocking"]}
```

Every field there changes what the alert means, and ISE composes none of it:

- `check_type: browser` — a browser test failing is a broken **user journey**, not
  an unreachable endpoint. An `api` test failing is the opposite.
- `probe_dc` + `group` — failing from three locations is an outage; from one, a
  probe glitch. The multi-value `probe_dc` (ISE-782's comment) already tells ISE
  how many.
- `state: No Data` vs `Alert` — two different events sharing one presentation.
- `check_status: paused` — see the separate task; **all 6 currently-firing No Data
  synthetics are paused tests**.

A deterministic sentence assembled from these — *"A browser test of OpenRita
failed from 2 of 3 locations"* — costs nothing, cannot hallucinate, and is
already more than the title says.

**2. What the author already wrote, badly surfaced.**

ISE ingests the monitor's `message` and `SignalDetail.tsx:210` renders it. The
problem is what is in it. Across the synthetics, most are notification routing
and nothing else:

```
"@italerts@moneypenny.co.uk \n@openrita@moneypenny.co.uk\nOpenRita (UK) Synthetic test failed"
```

Strip the handles and the remainder restates the title. But two monitors do carry
a real sentence:

```
"Moneypenny Portal has not returned a valid response from 2 locations for 5 minutes."
"UK Telephone Answering - Invalid response received"
```

So: strip `@handles` before display, show what remains as the source's own words,
and where nothing remains **say so** rather than rendering an empty box — an
absence of explanation is a fact worth stating, and it is the prompt for tier 3.

**3. What only a human knows — Signal Context.**

The missing rung. Its home is the **monitor, not the alert**: the alert instance
is ephemeral (the Differ recovers and re-opens the same row), while `monitor_id`
/ `synthetics_public_id` are durable and stable across every fire. Author once,
applies forever.

This is ADR 0108 §4's argument transplanted. `entity_annotation` sat at zero rows
for months because "describing one entity at a time, from the entity page, is not
a job anybody sits down to do", and the fix was to move authoring to where
somebody is already looking. The same holds here: describe the monitor from the
Business Application's page, beside the members, at the moment its alert is
sitting there unexplained.

Whether it is a new `signal_annotation` table keyed on `(system_id, monitor
reference)` or a reuse of `entity_annotation` against a minted monitor entity
(ISE-782 option A) is the build question. The design question is settled by the
composition: **Signal Context is the entity-less signal's Entity Context**, and
with it ADR 0108 §6's chain is whole again rather than gaining a fourth concept.

---

**Consequences to work through**

- The Oracle and `investigation_context` should read Signal Context wherever they
  read Entity Context today, or tier 3 is authored into a void.
- A tag-matched signal has no member row on the Business Application page, so
  there is nowhere to put its "Describe what this does…" invitation. The Members
  table is keyed on entities; entity-less signals need their own section — which
  is also where ISE-782's stray-`ise-ba:`-tag visibility problem gets solved.
- Priced but unexplained is a state worth counting: the members list already
  reports graded / explainable / unknown, and an attributed signal with no
  context of any tier is the same "unknown" in a different place.

---
id: 01M1R7HAM7W3S6KHZWS7NWK94F
created: 2026-09-05T07:29:11.303161Z
updated: 2026-09-05T07:36:47.908498Z
type: task
title: What does this alert mean? — context for a signal that has no entity
project: 01KX671DATY39VW6GWK3M2T3DN
number: 784
sprint: s7nj09w
comments:
- id: 01M1R7Z8H42MNTNC2078NP4DZH
  author: Steve Vine
  at: 2026-09-05T07:36:47.908382Z
  text: |-
    **Correction to tier 1 (2026-09-05). "Failing from one location is a probe glitch" is wrong, and would have under-priced every single-location monitor.**

    The right reading is a **ratio, never an absolute**: 1 of 1 is *every* location, and total failure. Only where the denominator is greater than 1 does a partial count mean partial failure.

    **The denominator is already on the finding.** The `probe_dc` tag count is the monitor's configured locations. From staging:

    ```
    monitor     title                                probe_dc   groups
    112360179   [Synthetics] Kora (UK) (Test)              1     pl:staging-uk-…, total
    112374886   [Synthetics] Kora (US) (Test)              1     pl:staging-us-…, total
    11470042    callroutingtwilio - Call Routing           2     aws:eu-west-1, aws:eu-west-2, total
    15216836    Twilio - api.twilio.com                    3     aws:eu-west-1, aws:eu-west-2, aws:us-east-1, total
    388322      Message Centre US                          2     aws:us-west-1, aws:us-east-2, total
    ```

    The Kora tests run from **one private location each** — precisely the case where "only one location failed" must read as 100%.

    **Better still: DataDog has already done the aggregation.** ISE creates one finding per `(monitor_id, group)`, and the groups are the individual locations **plus a `total` group** — DataDog's own verdict across all of them. So ISE should not infer breadth for the headline at all:

    - `group == "total"` firing ⇒ **the monitor is failing**, by the source's own evaluation, whatever the location count.
    - a per-location group firing ⇒ that location is failing, and `probe_dc` count gives the honest "1 of 3".

    That the two genuinely diverge is visible in monitor `11470055`: `aws:eu-west-1` **resolved**, `aws:eu-west-2` **recovered**, `total` **resolved**. They are not redundant copies.

    **So the tier-1 rule becomes:**

    - Lead with the `total` group's state. It is the source's aggregate and needs no arithmetic.
    - Where a per-location group is the subject, phrase it as `n of N` from the `probe_dc` count — and never let a small N reduce severity. A one-location monitor failing is not weaker evidence than a three-location monitor failing once; it is stronger.
    - Say the location count plainly rather than implying confidence from it: *"A browser test of OpenRita failed from its only location"* reads correctly and cannot be misread as a glitch.

    ---

    **A consequence this exposes, worth its own decision.** One synthetic failure produces **N+1 findings** — one per location plus `total`. Twilio's is four signals for one event. Once ISE-782's `ise-ba:` tag lands, those four are all attributed to the same Business Application and priced four times.

    `correlation_memory.py` (ISE-648) already met this at the incident level and deliberately solved it by remembering a human's merge decision, reasoning that *"a host-scoped monitor firing on five hosts genuinely is five incidents. It is wrong for a synthetic whose groups are views of one failure, and only a human can tell those apart."*

    The data above says the discriminator now exists for this one source: `type: synthetics alert` plus the presence of a `total` group is DataDog declaring which signals are views of one failure. That does not make ISE-648 wrong — its memory generalises past DataDog and past this shape, which the deterministic rule would not — but for synthetics specifically the fan-out could be collapsed at ingest without asking anybody. Worth deciding before `ise-ba:` multiplies it by the number of Business Applications a monitor names.
assignee: steve
label:
- brief
priority: high
task_status: backlog
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

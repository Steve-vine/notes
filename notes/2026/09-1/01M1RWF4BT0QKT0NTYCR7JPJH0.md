---
id: 01M1RWF4BT0QKT0NTYCR7JPJH0
created: 2026-09-05T13:34:59.450339Z
updated: 2026-09-05T13:35:38.156948Z
type: task
title: An alert says what it means from what ISE already has
project: 01KX671DATY39VW6GWK3M2T3DN
number: 788
sprint: s7nj09w
assignee: steve
label:
- feature
priority: medium
task_status: backlog
tech: null
---
Build ADR 0115 §8 tiers 1 and 2 — the two that need **nobody to author
anything**. Tier 3 (Signal Context) is a separate task.

Once ISE-786 lands, a synthetic escalates against a Business Application and
still says nothing about what it means.

## Tier 1 — what the payload already states

A synthetic's `details` are richer than the sentence ISE builds from them:

```json
{"type": "synthetics alert", "state": "No Data", "group": "total",
 "monitor_id": 39317789, "synthetics_public_id": "kdd-mk9-z72",
 "tags": ["MP-Service:OpenRita", "env:Production", "probe_dc:aws:eu-west-2",
          "check_type:browser", "check_status:paused", "ci_execution_rule:blocking"]}
```

Every field changes what the alert means, and ISE composes none of it:

- `check_type` — a **browser** test failing is a broken user journey; an **api**
  test failing is an unreachable endpoint. Different sentences.
- `probe_dc` + `group` — the ratio from ADR 0115 §7. Say "from its only location"
  where N is 1; never imply confidence from a small N.
- `state` — `Alert` and `No Data` are different events sharing one presentation.
- `check_status` — see ISE-785.

Assemble a deterministic sentence: *"A browser test of OpenRita failed from 2 of
3 locations."* It cannot hallucinate, costs nothing, and already says more than
the title.

## Tier 2 — what the author already wrote

ISE ingests the monitor's `message` and `SignalDetail.tsx:210` renders it
(`DETAIL_HIDDEN` at :40 keeps it out of the raw rows). The problem is its
content. Most are notification routing:

```
"@italerts@moneypenny.co.uk \n@openrita@moneypenny.co.uk\nOpenRita (UK) Synthetic test failed"
```

Strip the handles and what remains restates the title. But some carry a real
sentence:

```
"Moneypenny Portal has not returned a valid response from 2 locations for 5 minutes."
"UK Telephone Answering - Invalid response received"
```

So: **strip `@handles` before display**, show what remains as the source's own
words and labelled as such, and where nothing remains **say so** rather than
rendering an empty box. An absence of explanation is a fact worth stating — and
it is the prompt that makes somebody author tier 3.

## Screen

The signal detail modal, beneath the decision panel. Tier 1's sentence always;
tier 2 where the source gave one; and where neither says anything beyond the
title, an honest line saying nothing describes this monitor yet.

Order matters: the decision panel answers "should I care?", these answer "what
is it?". Neither replaces the other and they must not be merged into one
paragraph.

## Not in scope

- Signal Context authoring — separate task.
- The `check_status: paused` rule — ISE-785, which this should not pre-empt.
- Any AI-generated explanation. Both tiers here are deterministic on purpose;
  that is what makes them trustworthy on an incident at 3am.

## Acceptance

- A browser synthetic failing from 2 of 3 locations reads as exactly that.
- A one-location synthetic reads "from its only location", not "from 1 location".
- A monitor whose `message` is only `@handles` shows the honest empty line, not a
  blank box or a bare list of addresses.
- A monitor with a real message shows it, attributed to the source.
- A non-synthetic `monitor_alert` still renders correctly — the tier-1 sentence
  degrades to whatever fields exist rather than asserting synthetic-only ones.

---
id: 01M1Q6R5GA3DYX7Q0EVA91YGWX
created: 2026-09-04T21:56:12.426219Z
updated: 2026-09-04T21:56:15.623326Z
type: task
title: A synthetic monitor is evidence a capability works, and ISE cannot hear it
project: 01KX671DATY39VW6GWK3M2T3DN
number: 782
sprint: s7nj09w
assignee: steve
label:
- brief
priority: high
task_status: backlog
tech: null
---
Design question raised 2026-09-04: DataDog synthetic monitors fire when an
application is effectively unavailable, but they name no entity, so nothing
connects them to a Business Application.

**Where it stands today.** The synthetics already arrive — 64 synthetic-related
findings on staging, 49 of them with `entity_id IS NULL`. The Correlator then
returns before it can do anything with them (`correlator.py:206-215`):

```python
applications = context.applications_for(finding.entity_id)
if finding.entity_id is None:
    return Decision(escalated=False, reason="unsubjected", ...)
```

Every subsequent step — `application.covering(finding.entity_id)`, the
criticality × state matrix, the priority — is keyed on the entity. An
entity-less signal is not merely uncovered; it is **structurally unjudgeable**.

Current decision spread on staging:

```
graded       3902
unsubjected   117    ← 86 of these are monitor_alert
uncovered      71
escalated       6
muted           1
```

So the signal that most directly answers "can a customer use this?" is in the
one bucket that can never escalate.

**Workaround available today.** `POST /findings/{finding_id}/entity` attaches an
entity to a signal and sets `entity_pinned_by`. Dedup is on `(source, alert_key)`
and the synthetic's `source_key` is stable per monitor and group
(`monitor/112360179/pl:staging-uk-cluster-…`), so pinning once should survive
re-fires. Pin each synthetic to something already in the Business Application and
it starts being priced. Crude, manual, and it asserts something false — the
synthetic is not *about* that entity — but it works now.

**Three ways to do it properly**

**A — mint the synthetic as an entity.** There is precedent: Status Page checks
are already minted as `application` entities carrying `source: status-page`, and
they are ordinary BA members (that is what ISE-776 was about). A synthetic could
be minted the same way, becoming eligible for an ADR 0108 §2 entity rule and for
capability provider lists with no new concepts at all. Cheapest by far. The cost
is honesty: a synthetic is a *test*, not a component, and putting it in the
membership inflates the denominator that "3 of 18 members affected" is measured
against with things the application is not made of.

**B — let a signal name a Business Application from its own tags.** Rejected on
inspection. `signal_environment.py` documents why: signal tags and entity tags
are disjoint vocabularies, and a signal carries no `app:`/`project:` sibling so
it has no dimension — which is exactly the rule ADR 0073 §7 exists to protect.
Resolving BA membership from signal tags would require guessing a dimension ISE
has deliberately refused to guess.

**C — a capability gains a verifier (recommended).** A synthetic does not
*provide* a capability; it *observes* one. That is a different role and the
model has no word for it.

This is the sharp version of the argument. ADR 0109 §1 says "**the outcome is
not a property anybody can author**, because it is a fact about the current
state of several things at once", and derives service state by inference from
provider health. A synthetic is a direct *measurement* of that same outcome. So
it does not compete with the authored structure — it is the one input that can
confirm or contradict what was inferred. Today ISE prices the inference and
discards the evidence.

The case that makes it worth building is the disagreement: the capability derives
**healthy** because every provider is serving, and the synthetic says the
application is down. Something between the providers and the customer is broken —
DNS, a certificate, an ingress, a WAF rule — and that is precisely the failure
class an estate-health model built from component signals cannot see. A verifier
that disagrees with the derived state is the most valuable signal ISE could
produce, and right now it is filed under `unsubjected`.

**What this needs**

- An ADR. It amends ADR 0109's derivation (a third input beside providers and
  their signals) and touches ADR 0107's pipeline (the Correlator gains a path
  that does not start at an entity).
- Decisions to make in it: does a failing verifier set the capability's state, or
  sit beside it as a separate channel the way resilience already does (§2 has
  the pattern, and the argument for "reported alongside, never instead" applies
  here too)? What does ISE do when verifier and inference disagree — and is that
  disagreement itself an Observation? Does a verifier need to be an entity (A) or
  can a capability hold a signal-source reference directly?
- Whichever way it lands, the Correlator's `unsubjected` early return needs a
  second door, and its current message — "Attach an entity on the signal and it
  will be priced on the next pass" — should stop being the only advice ISE can
  offer about a signal of this kind.

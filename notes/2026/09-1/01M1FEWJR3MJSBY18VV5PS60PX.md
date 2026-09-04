---
id: 01M1FEWJR3MJSBY18VV5PS60PX
created: 2026-09-01T21:44:30.21178Z
updated: 2026-09-04T16:51:11.779848Z
type: task
title: 'The Correlator: escalation becomes a business judgement'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 764
sprint: s7nj09w
comments:
- id: 01M1ME39NDE4PFXBVREBZEKR6E
  author: Steve Vine
  at: 2026-09-03T20:06:53.869091Z
  text: |-
    Built and MERGED to main — PR #708, migration 0148. Full backend suite green (3,922 passed).

    THE CHAIN (ADR 0110 §2)
    Severity is consumed at the BOTTOM — it decides whether a PROVIDER counts as impaired — and from there the estate's own structure carries the meaning: capability service state × Business Criticality → Priority. That is what stops a source's scale setting the priority of a business it has never heard of.

    AN INCIDENT IS CREATED HERE AND NOWHERE ELSE
    A signal that is not escalated is retained and inspectable, and **every decision is RECORDED as it is made** (`signal_decision` table, one row per signal, replaced each pass). That is deliberate and it is ISE-767's whole foundation: `signal_decision.py` re-derives from CURRENT config, so it explains what would happen now rather than what did happen then — clear an override and every past signal silently re-explains itself. A record cannot drift from the decision because it IS the decision. There is a test that changes a definition after the fact and asserts the record does not move.

    ⚠️ THE BEHAVIOURAL CHANGE YOU SHOULD KNOW ABOUT BEFORE THE SMOKE TEST
    A signal on an entity in no Business Application is NOT escalated (ADR 0110 §6). With 2 Business Applications against ~6,000 entities that is close to everything. Episodic signals (ticket bursts) and un-hinted webhook alerts name no subject at all and fall in the same bucket permanently until someone pins an entity.

    This is what the ADR asks for, and the coverage figure exists to keep it honest: `GET /issues/coverage` reports the gap in the two halves that need different fixes — `uncovered` (define the Business Application) and `unsubjected` (tell ISE what the signal is about). **Staging will look very quiet.** That is the honest starting position, not a fault, but it is worth expecting.

    TWO DECISIONS WORTH NAMING
    - **Unset criticality is priced as a STATED MIDDLE and says so in the sentence.** Defaulting to Low is how the near-empty definitions became harmless right up until they decided who was woken; defaulting to the top would page on everything nobody has graded.
    - **Priority is re-read on every pass, unlike severity.** Severity is upward-only because it records the worst the estate GOT (ADR 0040 §2); a priority is what to do about it NOW, and a replica coming back genuinely changes that. A resolved or dismissed incident is not re-priced — that is a human's decision the Correlator must not half-undo.

    Migration 0148 backfills NOTHING: an existing incident was opened under the old rule from severity alone, and stamping a priority on it would invent a judgement nobody made against definitions that did not exist.

    THE TEST ESTATE — the biggest single piece of this task
    ~20 test files changed semantics honestly rather than cosmetically. A test about the incident LIFECYCLE is not a test about the business judgement, so each now describes its estate first (`tests/described_estate`) and then tests what it came to test. **That the old tests passed against an estate nobody had said anything about is precisely the state that made "unimportant things surfaced repeatedly" possible** — the tests were as under-described as production.

    Two live-found traps while doing it: the webhook payload field is `entity`, not `entity_hint` (the model column's name); and a recovered signal never opens anything retrospectively, so a subject pinned after the fact has to be pinned per episode.
assignee: steve
label:
- feature
priority: medium
task_status: done
tech: null
---
The load-bearing change in ADR 0107. `promotion.promote_findings` leaves the sync transaction, becomes the Correlator, and gains the input it has never had.

**An Incident is created here and nowhere else.** A signal that is not escalated remains an Alert or an Observation, retained and inspectable rather than discarded.

Escalation stops being severity-and-policy alone and starts reading the definitions: Business Criticality, and what the affected entity is *for*.

**Its first real correlation, now concrete (ADR 0109).** Deriving a capability's state means reading signals across several entities and drawing one service-level conclusion — is the primary provider impaired, is a later one carrying it, are they all gone. That is genuine correlation rather than deduplication, and it arrives as a by-product of the capability model rather than as a feature of its own.

Today `correlation_key` is `f"{system_id}:{source_key}"` — a dedup key — and of 240 incidents, 232 have exactly one signal and none have more.

**Also in scope:** the unassessed path. A signal on a member no capability covers must resolve to neither "fine" nor "the service is down"; it inherits the service's criticality, carries no impact claim, and is marked unassessed. Never silently zero.

**Blocked by** the prioritisation vocabulary (ISE-759) — ADRs 0108 and 0109 have settled the definitions, but how criticality and capability state combine into a priority is still open.
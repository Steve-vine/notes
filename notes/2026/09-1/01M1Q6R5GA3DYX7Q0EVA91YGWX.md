---
id: 01M1Q6R5GA3DYX7Q0EVA91YGWX
created: 2026-09-04T21:56:12.426219Z
updated: 2026-09-05T13:30:57.777958Z
type: task
title: A synthetic monitor is evidence a capability works, and ISE cannot hear it
project: 01KX671DATY39VW6GWK3M2T3DN
number: 782
sprint: s7nj09w
comments:
- id: 01M1R661DSBEAT1P151R73DY3T
  author: Steve Vine
  at: 2026-09-05T07:05:32.857877Z
  text: |-
    **Steve's proposal (2026-09-05): tag the alert `ise-ba:kora.prod.uk` and match on ingest. This supersedes option B and is better than option C as a first step.**

    **Why my objection to B does not apply here.** B was "resolve membership from the signal's own tags", which fails because `env:prod` is a *dimensioned* value with no honest canonical form absent an entity's sibling tags (ADR 0073 §7). `ise-ba:kora.prod.uk` is not a dimensioned value — it is a **direct reference**. Nothing is being canonicalised or inferred; the author is naming the application outright. That is the signal-side twin of ADR 0108 §2, which added an entity rule for exactly the case no tag predicate could describe. Same escape hatch, other side of the pipeline, and the precedent is already accepted.

    **The multi-application case is already built.** `Context.applications_for()` returns a **list**, and `judge()` loops over every application, forming a Decision per application and keeping the worst via `_outranks` (`correlator.py:232-266`). Its docstring already argues the case: *"An entity in a critical application and a minor one really is part of the critical application, so its failure really does hurt it — and the recorded reason names which application decided."*

    So an alert affecting several Business Applications needs no new rule: it is priced by the worst of them, and `SignalDecision.business_application_id` records which one decided. At the storage layer `finding_tag` is a many-to-many with a unique constraint on `(finding_id, tag_id)`, so repeating the key with different values — `ise-ba:kora.prod.uk` **and** `ise-ba:kora.prod.us` on one monitor — already works. The tag resolver just has to return a list and hand it to the existing loop.

    **The real challenge is the one not named: the match key is now renameable.** ADR 0114 shipped last night and decided *"the name IS `app_name`, one of the identity's three components, and renaming is an edit of the identity on the object's own page"*. So `kora.prod.uk` is a mutable string, and there is now a supported UI act that changes it.

    Tag ninety DataDog monitors with `ise-ba:kora.prod.uk`, rename the application, and every one of them stops matching — landing back in `unsubjected`, the bucket that can never escalate. It fails **silently**, because a signal that resolves to no application is indistinguishable from one nobody tagged. That is the same shape as the `mp-project` / `mp_project` bug: correct behaviour, invisible cause.

    Three mitigations, best first:

    - **Match on the name, and make a rename carry the old one as an alias** — the entity-alias pattern, applied to `app_name`. Existing tags keep working; new ones use the new name.
    - **Warn at rename time**: "N signals currently name this application by its present name." Cheap, and it makes the consequence visible at the moment of the act.
    - **Match on the entity UUID instead.** Stable and unambiguous, but nobody will maintain `ise-ba:9622cdf3-3c33-4bd9-aa1f-4351e735e84f` by hand in DataDog. Rejected on ergonomics.

    **Reuse ISE-776.** An `ise-ba:` value matching no application must say what nearly matched — `tag_near_miss.py` shipped yesterday for precisely this failure class and is documented as "only ever consulted on the empty path", so calling it here is free. A typo in a DataDog tag is the same error as a typo in a rule, and the near-miss sentence is the whole reason ISE-776 exists.

    **Also to decide**

    - Is `ise-ba` a **governed key** in the Tag Dictionary? Making it governed makes it discoverable and lets ISE validate values, but a `defined` value_mode would have to track live application names. Probably governed with `open` values plus the near-miss sentence, rather than closed.
    - Does a tag-matched signal count as **covered** for the coverage figure, and does it appear on the Business Application's page as a member-less signal? It has no entity, so it belongs to the application without belonging to anything *in* it — the Members table has nowhere to put it.
    - Does this obviate the **verifier** (option C)? No, but it defers it. Tag-matching gets the synthetic attributed and escalating, which is most of the value. The verifier question — whether a synthetic *sets* a capability's state or reports beside it, and what a disagreement means — stays open and can be decided later on top of this.

    **Recommendation: build the tag match first.** It is small, it reuses the multi-application machinery and the near-miss sentence already in the tree, and it turns 86 permanently-unjudgeable `monitor_alert` signals into priced ones. Take the rename-alias mitigation with it in the same change, or the first rename will quietly undo the work.
- id: 01M1R6KFB3JFPW5DFX856K9MS8
  author: Steve Vine
  at: 2026-09-05T07:12:53.091004Z
  text: |-
    **Confirmed empirically: yes, and your own synthetics already do it.** DataDog tags are a flat list of `key:value` strings — the key is a convention inside the string, not a unique field — so one monitor can carry any number of values for a key, and ISE already ingests them all.

    From the staging DB, DataDog-sourced findings with repeated keys:

    ```
    [Synthetics] Message Centre US            env       3 values   Depricated, Production, UK
    [Synthetics] Twilio - api.twilio.com      probe_dc  3 values   aws:eu-west-1, aws:eu-west-2, aws:us-east-1
    [Synthetics] Internal Services - Billing  probe_dc  3 values   aws:eu-central-1, aws:eu-west-1, aws:eu-west-2
    [Synthetics] UK Digital Switchboard       env       2 values   Production, UK
    ```

    So `ise-ba:kora.prod.uk` + `ise-ba:chinwag.prod.uk` on one monitor works end to end with no change: `finding_tag`'s unique constraint is on `(finding_id, tag_id)` and a tag row is a key **and** value, so both land. `probe_dc:aws:eu-west-1` also shows values may themselves contain colons — irrelevant for a dotted application name, but the resolver must split on the FIRST colon only.

    **The hazard this creates.** Multi-value means a second `ise-ba:` tag is **additive, never replacing**. Move a monitor from `kora.prod.uk` to `chinwag.prod.uk` and forget to delete the old tag, and the alert is now judged against both — and `_outranks` takes the **worst** of them. A forgotten tag silently *raises* priority, and nothing on the alert says why it is being priced against an application it no longer relates to.

    Two things follow:

    - `SignalDecision` records only the winning `business_application_id`. When a signal resolves to several applications, the screen should say which others it was judged against and that the worst won — otherwise the recorded reason names an application the operator cannot connect to the alert.
    - Worth surfacing an application's tag-matched signals on its own page, so a stray `ise-ba:` tag is visible from the application it wrongly names rather than only from the monitor.

    Note also that `env` on `Message Centre US` holds `Depricated, Production, UK` — the exact case `signal_environment.py` documents as `unlisted` (a source using `env` for region, plus a source-side misspelling). It is a live demonstration that a key can carry several values including nonsense ones and flow all the way through without complaint. `ise-ba:` will behave the same way, which is why the ISE-776 near-miss sentence on an unmatched value matters as much as the match itself.
- id: 01M1R89K4VMAG11NZZ83MGB2R0
  author: Steve Vine
  at: 2026-09-05T07:42:26.459484Z
  text: |-
    **On "mint the monitor as an entity when it first fires" (2026-09-05) — right instinct, and the premise it rests on is happily false.**

    **ISE already enumerates every monitor, on every sync.** `_monitor_findings` opens with:

    ```python
    monitors = list(apis.monitors.list_monitors(group_states=_GROUP_STATES))   # datadog.py:1720
    ```

    `_GROUP_STATES = "all"`, and the comment above it explains why: `all` rather than the alerting states alone, because it is what distinguishes "reports groups, all of them OK" from "simple monitor, no groups" (ISE-153). Synthetics get the same treatment — `_synthetics_public_ids()` calls `list_tests`.

    So the full inventory — healthy and firing — is already in hand once per sync. Everything not firing is then discarded. There is no discovery problem to solve and no extra API call to pay for; the list is being fetched and thrown away.

    **And mint-on-fire has a flaw that the full list does not: `last_seen_at` would come to mean "last failed".**

    ADR 0039 retires an entity no integration has reported for its window. Stamp a monitor entity only when it fires and a **healthy** monitor — the normal and desired state — looks absent, and is retired on its window. The estate would then contain precisely the monitors that are broken and be blind to every one that is working. That is inside-out for anything wanting to answer "is this application watched?", and it is the same trap as reading `last_seen_at` as anything other than the source's own clock.

    Minting from `list_monitors` inverts all of that correctly: every monitor is stamped every sync because DataDog still lists it, and one deleted in DataDog falls out of the list and retires honestly on its own clock.

    **What the full list buys that mint-on-fire cannot**

    - *"These 6 monitors watch this application; 5 healthy, 1 firing."* Coverage, not just failure.
    - **"This critical application has no synthetic watching it at all"** becomes answerable, and is probably worth more than anything the alerts themselves provide. It is the same shape as ISE-765's ungraded-application Observation: an absence of assessment is a finding, not a blank.
    - ISE-785's paused check gets a home — a member whose state is "not watching" rather than a mystery `No Data` alert.

    **This also settles option A vs option C: A becomes the mechanism for C, not an alternative to it.** A verifier needs something durable to attach the verifier role to, and a monitor entity minted from the enumerable list is exactly that. The earlier objection to A — that a synthetic is a test, not a component, and pollutes the membership denominator — is answered by giving it a role rather than a membership: it verifies the capability, it does not provide it, and it stays out of the count that "3 of 18 members affected" is measured against. `DEPENDENCY_EXCLUDED_TYPES` already establishes the pattern of a type that appears in a view without joining a denominator.

    **Two things to settle before building**

    1. **Measure the scale first.** The connector holds `len(monitors)` on every sync and nobody has ever looked. A few hundred is fine; several thousand would flood an estate of 7,769 entities and change the character of every list and search. Log it for one sync before committing. Scoping the first cut to **synthetics only** is the safer start regardless — it is a far smaller set, and it is the one where "this thing verifies an application works" is unambiguous.
    2. **Decide the entity type deliberately.** Not `application` — that already carries the discovered-externally sense (ADR 0096 §6) and Status Page checks sit there. A distinct type keeps the membership arithmetic honest and makes it filterable out of the graph, which after ISE-780 matters.
- id: 01M1R8TEGHSMNN34HFECH6JH2T
  author: Steve Vine
  at: 2026-09-05T07:51:38.769352Z
  text: |-
    **DECIDED 2026-09-05 — build to these, not to the options above.**

    1. **`ise-ba` is a governed Tag Dictionary key with `value_mode: open`.** Discoverable, appears in the tag cloud and tag compliance like any other key, and no dictionary syncing of live application names. An unmatched value is answered by the ISE-776 near-miss sentence rather than by validation — say what nearly matched, do not refuse the tag.

    2. **The synthetic fan-out collapses at ingest, for synthetics only.** Where `type: synthetics alert` and a `total` group is present, the per-location groups are views of one failure and raise **one** signal. The source declares the aggregate, so nothing is inferred. Scope the rule tightly to synthetics: ISE-648's "only a human can tell those apart" stands everywhere else, and `correlation_memory` keeps doing its job for every other shape. A synthetics monitor reporting **no** `total` group must fall back to per-group signals rather than silently dropping to zero.

    3. **A rename carries the old `app_name` as an alias.** Existing DataDog tags keep matching; new ones use the new name. This is a hard dependency of the tag match — build it in the same change, not after, or the first rename after go-live quietly unpicks the work. ADR 0114 made renaming a supported act, so this is now a live risk rather than a theoretical one.

    4. **All four tasks stay in sprint 69** — ISE-781, 782, 784, 785.

    **Still open, and fine to settle in the ADR rather than here:** whether a failing verifier sets a capability's state or reports beside it (ADR 0109 §2's "alongside, never instead" is the precedent); whether monitors are minted for synthetics only or all monitors — measure `len(monitors)` on one sync first; and the entity type name, which must not be `application`.
- id: 01M1R8W1A90W4ZQPJZ440R1VZY
  author: Steve Vine
  at: 2026-09-05T07:52:30.792687Z
  text: |-
    **Build hazard on the fan-out collapse — this exact change has bitten before (ISE-153).**

    Collapsing synthetics to one signal changes their finding key. `datadog.py`'s own comment records what happened last time the key scheme moved:

    > Conflating those two is what made the finding key flip between `monitor/{id}` and `monitor/{id}/{group}` across syncs, which is the churn half of the same bug.

    So the collapse is not purely additive. On the first sync after it ships, every currently-open per-location synthetic finding has a `source_key` the connector will no longer report. Left alone, the Differ's recovery sweep closes them — which is arguably correct (they *are* superseded), but it will land as a burst of recoveries, and any incident holding one of those findings loses its subject.

    Decide deliberately, and state it in the ADR:

    - Which key the collapsed signal takes — `monitor/{id}` (the ungrouped shape, matching `_UNGROUPED_GROUP` handling) or `monitor/{id}/total`. The former is tidier; the latter preserves the group provenance and avoids colliding with a genuinely ungrouped monitor of the same id.
    - What happens to the open per-location rows: let them recover naturally, or migrate them onto the collapsed key so incident links survive.
    - Whether the burst trips the Differ's mass-recovery guard, which already warns when "a Differ pass recovered most of a system's open signals at once" — it fired for EntraID twice yesterday, so it is live and would fire here.

    Cheap way to size it first: count open synthetic findings per monitor on staging before shipping, so the expected recovery burst is a known number rather than a surprise in the Platform Log.
- id: 01M1R96TD7ZS6P87F0ZQM1832B
  author: Steve Vine
  at: 2026-09-05T07:58:24.166784Z
  text: |-
    **ADR 0115 merged to main 2026-09-05** — `docs/decisions/0115-a-signal-may-name-its-business-application.md`, PR #724, commit `28041f2e`. Docs only; no code, no migration, nothing to deploy.

    One ADR rather than two, following ADR 0108's precedent — that one covered both the membership escape hatch (§2) and context (§4-6), and these decisions are coupled the same way: context for a tag-matched signal only matters once attribution exists. It therefore closes the design half of **both** this task and ISE-784.

    **Eight sections:** a signal may name its application outright; the ADR 0037 §6 amendment and its bounds; the governed `ise-ba` key with the near-miss sentence; several applications and the worst deciding; the rename alias; the synthetic fan-out collapse; breadth as a ratio; Signal Context as the missing rung. Two things deferred with the reasoning recorded — the verifier role, and minting monitors as entities.

    **§2 is the section that changed while writing.** Drafting it surfaced a sharper objection than anything in the discussion above: ADR 0037 §6 states that tag ingestion, rule evaluation and membership churn *"never create an Incident, and never change one's severity"*, and §3 calls tag values attacker-influenceable content that is read, never followed. `ise-ba:` breaches both. The ADR states the amendment openly and answers it by bounding rather than dismissing — meaningful on a signal only, selects but never creates, **at most eight applications per signal**, and whoever can tag a DataDog monitor can already set that monitor's severity, so the tag redirects a signal its author already controls rather than manufacturing one. The residual risk is stated: a wrong tag can price against a more critical application than it belongs to, which is why §4 requires the decision to record *every* application it was judged against rather than only the winner.

    The eight-application cap is new and was not discussed — it exists because ADR 0037 §3 bounds a finding to 50 tags, and without a tighter limit a monitor could name fifty applications and be priced against the worst of a set nobody could read. Worth a look; it is the one number in the ADR that was chosen rather than derived.

    **What remains here is build, not design.** This task and ISE-784 are `brief`-labelled and their ADR has landed, matching how sprint 69's other spec tasks closed. The implementation wants its own tasks — the tag resolver and Correlator door, the rename alias, the fan-out collapse, and the context tiers are four separable slices, and the fan-out one carries the ISE-153 key-churn hazard that should not ride along inside a larger change.
assignee: steve
label:
- brief
priority: high
task_status: todo
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

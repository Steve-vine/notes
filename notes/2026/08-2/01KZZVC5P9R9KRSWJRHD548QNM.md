---
id: 01KZZVC5P9R9KRSWJRHD548QNM
created: 2026-08-14T09:59:11.305035Z
updated: 2026-08-14T14:32:31.473156Z
type: task
title: A ticket burst has no identity, so every future burst reopens the same incident forever
project: 01KX671DATY39VW6GWK3M2T3DN
number: 706
sprint: sevhjex
comments:
- id: 01M008NXCQ7A9SE07J8CHS3C19
  author: Steve Vine
  at: 2026-08-14T13:51:41.975189Z
  text: |-
    Built and merged — PR #658 (squashed to main 2026-08-14). Treated as the design decision the ticket asked for, not a patch.

    **The decision.** A signal may declare itself `episodic` (`FindingData.episodic`). Its source key becomes the episode's FAMILY rather than its identity, and reconcile matches an incoming detection against the family's currently OPEN row (`finding.episode_key`, `resolved_at IS NULL`) instead of by exact key.

    - Within an episode the open row is found and updated — the count ticks 5→6→5 without the incident flapping. That is exactly the property the constant key was protecting, and it is preserved.
    - Between episodes a recovered row is never resurrected. A later burst mints a new episode with its own key, its own incident and its own resolution note. IN-1277's note stays with the investigation that wrote it.

    **On ADR 0030's no-cross-pass-state rule.** The detector gained a boolean and stays a pure function of a live read. The state an episode needs is `resolved_at` on the row itself — durable, visible on the Signals screen, already audited. That is the signal's own recorded lifecycle, not the hidden per-pass state §2 keeps out of the loop. Neither of the two shapes the ticket floated (a minted episode id, a coarse window bucket) survived contact with the numbers: the obs cadence is 3600s against a 60-minute window, so consecutive passes barely overlap and any key derived from the window's *contents* would recover and re-open every hour of a sustained burst.

    **The sibling detector — checked, and it had the same flaw.** Not a singleton: its key is a per-vocabulary digest, so a different problem always got its own row. But the same vocabulary is what recurs, and "Printing is down" in September resurrected August's resolved row. It is episodic too, with its own test.

    **Your fourth bullet, and it falls out rather than needing new machinery.** The two acts were previously the same click on the same permanent row, which is the deeper reason a closure could be undone by an unrelated event:
    - Resolve the incident → *this instance was noise*; the next burst raises its own.
    - Ignore the signal → *this pattern is not worth alerting on*; an ignored row is never recovered, so it parks the family until a human un-ignores it.

    Both tested.

    **Records.** ADR 0030 amendment appended (its §1 rule — kind + affected entity — assumes every Observation is about a *thing*, and ADR 0068 §4 gives a Freshservice burst no entity to be about). Recorded in the ISE Canon as a comment. Migration 0135 adds `finding.episode_key`, nullable, **no backfill**: the two live rows keep their keys and history and become the last row of their old-style family — backfilling a synthetic episode would rewrite history to look like something ISE never observed.

    Two consequences named rather than left silent: correlation memory (ISE-648) pairs by source_key so a merge judgement does not carry across episodes — the honest reading, since it is the same class of claim as the resolution note this fixes; and Recall is unaffected, because an Observation's priors match on kind.

    `bounded_key` moved from the Freshservice connector to `native_keys` — core mints episode keys now, and reaching into one connector for a key rule is the wrong way round.

    Every new test was checked to fail with `episodic` flipped off, so none of them pass vacuously.

    Note on what to expect on staging: the existing finding row `2ee15885` keeps its constant key and stays recovered. The next burst after deploy mints the first real episode.
assignee: steve
label:
- bug
priority: high
task_status: done
tech: null
---
**IN-1277.** Raised as a ticket burst, investigated (tickets 439421-439434 — routine, unrelated helpdesk items, no common root cause), closed as unrelated. A *different* burst then reactivated the same incident. Reported 2026-08-14; the incident is `reactivated` now.

**Cause — the signal's identity is the detector, not the burst.** `burst_observation` (`freshservice_detect.py:245`) mints a constant:

```python
source_key="obs/tickets/burst",
```

so the correlation key is `{system_id}:obs/tickets/burst` for every burst that has ever happened or ever will. Verified on staging: **one** finding row (`2ee15885`), `status=recurring`, `first_seen_at` 2026-08-04, `last_seen_at` 2026-08-14 09:55, `resolved_at` NULL. One row, ten days, every burst.

The code states the trade-off deliberately (`freshservice_detect.py:243`):

> *"STABLE across the burst's life — no count, no timestamp. A key that moved with the count would recover and re-open every tick."*

That reasoning is right for **one** burst's lifecycle — it stops the incident flapping as the count ticks 5→6→5, and it is what makes recovery fall out for free under ADR 0030's no-cross-pass-state rule (the window slides, the count drops, the key leaves the batch, `reconcile_findings` recovers it). The flaw is that stability across *one burst's life* was implemented as stability across *all time*. Nothing distinguishes "the same burst, still going" from "a different burst, a week later".

**Why it is worse than a nuisance: it corrupts the record.** IN-1277 now carries a resolution note describing an investigation of tickets 439421-439434 while the incident's live contents are a different burst (439694-439703). The operator's own note predicted the newer burst would *"surface as its own issue if it escalates"* — it did not; it reactivated this one. So one investigation's conclusions are permanently attached to a different event, and Recall will serve that note as the prior for a future burst it never examined.

Note `resolved_at` is NULL after ten days: bursts recur often enough that the window is rarely clear, so even the free-recovery path has not fired.

**Scope — a design decision, not a patch**
- Give a burst an identity that is stable *within* an episode and distinct *between* episodes. Two shapes worth weighing: an episode id minted when the count first crosses the threshold and retired when the window clears; or a coarse window bucket. Both reintroduce some cross-pass state, which is exactly what ADR 0030 chose to avoid — so this needs deciding and recording, not patching. If the decision changes the detector's contract, it needs an ADR amendment.
- Whatever is chosen must preserve the property the constant key was protecting: the incident must not flap while a single burst's count moves.
- Check the sibling detector. `freshservice_detect.py` also emits a same-issue **cluster** signal; confirm whether it has the same singleton-key shape before closing, or this returns under another name.
- Consider whether an operator's closure should be able to say *"this pattern is not worth alerting on"* as distinct from *"this instance was noise"*. Closing IN-1277 expressed the second and was silently treated as neither.

Related: ISE-704 (the resolution note is stored and never displayed — which is why the mismatch above is invisible on screen), ISE-692 (an incident presenting stale state as current).
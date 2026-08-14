---
id: 01KZZVC5P9R9KRSWJRHD548QNM
created: 2026-08-14T09:59:11.305035Z
updated: 2026-08-14T12:52:37.652226Z
type: task
title: A ticket burst has no identity, so every future burst reopens the same incident forever
project: 01KX671DATY39VW6GWK3M2T3DN
number: 706
sprint: sevhjex
assignee: steve
label:
- bug
priority: high
task_status: todo
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
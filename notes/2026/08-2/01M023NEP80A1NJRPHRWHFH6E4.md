---
id: 01M023NEP80A1NJRPHRWHFH6E4
created: 2026-08-15T07:02:32.904849Z
updated: 2026-08-15T08:04:54.460658Z
type: task
title: A playbook shows its score but never the bar — say how far it is from running itself
project: 01KX671DATY39VW6GWK3M2T3DN
number: 723
sprint: sevhjex
comments:
- id: 01M0277M5X5398E7HE3FQ1J74M
  author: Steve Vine
  at: 2026-08-15T08:04:54.077843Z
  text: |-
    Done — PR #672, merged to main.

    `playbook_standing.describe()` computes the counters and both bars once, server-side, and all three surfaces render the same sentences: the Playbooks list (badge), the per-playbook desk section (counters + both bars), and the incident's Playbooks section (headline + the demotion warning, which is the one an operator leaning on a prior mid-incident most needs).

    **Distance, never the rule.** "1 more successful run to reach proven", "5 more failures would retract desk status automatically". The reader never holds `>= 2 and >= 0.66` against constants kept in two other modules.

    **Both directions.** The demotion bar renders as an alert rather than another line — a playbook drifting toward auto-retraction is the more urgent fact, and it was silent right up until it fired. An autonomous playbook is measured against the autonomy floor instead, which bites much earlier, because that is the edge it is actually near.

    **Out of reach vs far off.** An advisory playbook gets no bar at all, with a sentence saying why (its feedback ranks it in Recall and nothing else reads it). A remediating playbook gets no autonomy countdown, because the first autonomous release is limited to playbooks that change nothing.

    **One thing worth knowing about.** The distance is a *search*, not a closed form. Solving `(s+k)/(t+k) >= r` is right over the reals and wrong here: the floors are floats, and `0.9*1/(1-0.9)` evaluates to `9.000000000000002` — so the formula demands **ten** further runs where the gate, comparing `9/10 >= 0.9` with both sides the same double, accepts **nine**. An operator told "10 more" who reaches the bar at 9 has been lied to by a rounding error. It now steps up from an under-estimate against the gate's own predicate, so the distance and the decision cannot disagree.

    That was found by the exhaustive test (`assert clears(k) and not clears(k-1)` over every small record), not by reading the code — worth keeping the test.

    Verified: 15 unit tests on the arithmetic, 2 new API tests (one asserts the incident surface and the list return the *identical* standing block), ruff/mypy clean, full frontend suite 924 tests.
assignee: steve
label:
- improvement
priority: medium
task_status: review
tech: null
---
The Playbooks page already shows standing (`PlaybooksPage.tsx:132-161`) — `"3/4 worked (75%)"` for a remediation playbook, `"guided 6 · confirmed 4 (67%)"` for an advisory one, `"not yet applied"` at zero. What it never shows is **the bar those numbers are measured against**, or how far off it is.

So an operator can read the score and still not know whether the playbook is one run away from being trusted or twenty, or that it is quietly about to be demoted.

**Wanted:** the counts *and* the thresholds, stated as distance. *"Needs 1 more successful manual run before it can run automatically."*

**The thresholds already exist and are all invisible:**

| Bar | Value | Where |
|---|---|---|
| proven / `rubber-stamp` | `efficacy_total >= 2` and ratio `>= 0.66` | `playbooks.py:33-34` |
| desk auto-demotion | `>= 4` outcomes and ratio `< 0.5` retracts desk status | `playbook_envelope.py:33-34` |
| autonomy | stricter still — set by ISE-714 | not yet built |

**Scope**
- Show every counter the playbook has, named for what it means: successful runs, correctly dismissed (ISE-722's new counter), failed. Not one blended ratio — the whole point of ISE-722 is that these are different claims.
- State the next threshold as **distance**, not as a rule the reader has to apply: "1 more successful run to reach proven", "2 more failures would retract desk status". A reader should never have to hold `>= 2 and >= 0.66` in their head to work out where they stand.
- Show the demotion bar too, not just the promotion one. A playbook drifting toward auto-retraction is the more urgent fact and is currently silent until it happens.
- Where a playbook is *not eligible* for a rung, say why rather than showing a bar it can never reach — an advisory playbook is scored on a different counter entirely.
- Surface it wherever the playbook's standing already appears: the Playbooks list, the per-playbook desk section, and the incident's Playbooks section.

Depends on ISE-722 for the dismissal counter; the numbers it displays are meaningless for a no-op playbook until that lands. Related: ISE-714 sets the autonomy bar this must render.
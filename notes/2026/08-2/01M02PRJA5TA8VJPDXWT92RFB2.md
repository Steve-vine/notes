---
id: 01M02PRJA5TA8VJPDXWT92RFB2
created: 2026-08-15T12:36:17.861363Z
updated: 2026-08-15T16:00:37.210149Z
type: task
title: A playbook's promotion and demotion bars are platform constants — they belong in its envelope
project: 01KX671DATY39VW6GWK3M2T3DN
number: 735
sprint: sevhjex
comments:
- id: 01M032EEP9353QAZ5GXJ420XPN
  author: Steve Vine
  at: 2026-08-15T16:00:29.384957Z
  text: |-
    Done — PR #685, merged to main 2026-08-15. Built to your design, including the asymmetry rule.

    **`thresholds` on the envelope, all six, all optional**, resolved **per field** rather than per object — an author who sets only a demotion bar keeps the platform's promotion bar, which is the natural reading of a partial override and the only one that lets a set be written a piece at a time. Absent means today's constants, so the three existing playbooks are untouched.

    **`thresholds_for` is the single seam**, which is what made the four call sites one line each as you predicted. It is also read by **both halves of ISE-723's standing display** — worth stating explicitly, because otherwise the engineer reads a distance to a bar the gate is not enforcing. You were right that no display work was needed beyond that.

    One judgement I added: the resolver is **defensive** — a malformed envelope yields the platform defaults rather than raising. Publish is where an envelope is judged; a gate asking "may this run unattended" must never fail on the shape of a stored blob, and failing to the *stricter* bar is the safe direction.

    **The asymmetry, enforced at publish:**
    - Tightening unbounded.
    - Desk loosening free.
    - Autonomy floored at **4 outcomes / 75%** — below the platform default rather than at it, since refusing every loosening would make the feature pointless. That is the point past which loosening stops being a judgement about one playbook's risk and starts being a way round the gate.

    Your demotion-below-promotion check is in, and worth distinguishing from the floor: it is **not a safety limit**. It catches a configuration that cannot mean what it says — a playbook demoted the moment it is promoted, flapping between rungs for ever. A validator can see that; an author cannot.

    **`plain_summary` names a non-default bar and only a non-default one.** Naming the platform default on every playbook is noise that trains people to skip the line the one time it matters.

    **One thing the editor does that is not in the scope but should be:** it sends only the fields the author actually **moved**. Writing all six back would silently pin that playbook to today's constants — so a later change to a platform default would never reach it, and every playbook edited after this would acquire a threshold block nobody chose. Tested.
assignee: steve
label:
- improvement
priority: medium
task_status: review
tech: null
---
Raised 2026-08-15 while smoke testing ISE-723, which made the bars visible for the first time — and visible immediately raised "who chose 8?".

**Six constants, none configurable:**

| Bar | Value | Where |
|---|---|---|
| proven / `rubber-stamp` | 2 outcomes at 0.66 | `playbooks.py:33-34` |
| desk auto-demotion | 4 outcomes below 0.5 | `playbook_envelope.py:88-89` |
| autonomy | 8 outcomes at 0.9 | `playbook_envelope.py:97-98` |

**They are reasoned but not calibrated.** The autonomy pair has the most argument behind it (its comment reasons it is "strictly above `compute_tier`'s rubber-stamp line... a run of incidents rather than a coincidence"), but no estate has enough playbook history to have derived any of them from data. Treat them as conservative guesses applied uniformly.

**The weakness (Steve, 2026-08-15).** The bar is a property of the playbook's *risk*, and it is currently a property of the platform. "A Karpenter node was recycled, nothing to do" and "restart the production database" are asked for identical evidence before they are trusted. A simple playbook for a rare signal may deserve to be trusted after one or two runs; a complex one should need many more to be promoted — **and fewer failures to be demoted**.

**Design: the thresholds go in the envelope.**

Not a new column, and not a settings screen. The envelope is already the per-playbook, author-written, server-enforced limit object, and putting them there resolves the one serious hazard: an author setting their own promotion bar is an author granting themselves trust, which is exactly what ADR 0056's second-engineer rule exists to prevent. But the envelope is **already the thing a second engineer reviews at publish**, and an envelope edit already retracts the desk rung. So "I think two runs is enough for this one" becomes a proposal somebody signs off, not a self-grant. No new governance is needed.

**The rule that falls out of the asymmetry: tightening is always safe, loosening needs a floor.**

- A *stricter* demotion bar ("two failures and it is out") is strictly safer than the default — allow it freely, unbounded.
- A *looser* promotion bar is fine for the desk rung, where a human triggers each run.
- For **autonomy** it needs a platform floor no envelope may go under. That is the rung where nobody is watching, and a bar of 1 means one lucky run buys unattended operation indefinitely.

**Scope**
- `thresholds` on the envelope: promotion (min outcomes + ratio), demotion (min outcomes + ratio floor), optionally an autonomy pair. All optional — absent means today's constants, so the three existing playbooks are unaffected and nothing already published changes behaviour.
- Validate at publish with the rest of the envelope: sane ranges, promotion bar not below the platform autonomy floor, demotion floor below the promotion ratio (a playbook that is demoted the moment it is promoted is a configuration nobody wants and the validator should refuse).
- `proven_standing`'s callers — `compute_tier`, `maybe_demote_desk`, `autonomy_blockers`, `maybe_demote_autonomy` — read the playbook's own bar rather than the module constant. One seam each; they already share `proven_standing` after ISE-722.
- The envelope editor (`PlaybookDeskSection`) grows the fields, with the platform default shown as the placeholder so an author sees what they are overriding.
- **No display work needed**: ISE-723's `playbook_standing` computes distance from whatever the bar is, so per-playbook bars render correctly the moment they exist.
- `plain_summary` should mention a non-default bar — an envelope summary that omits "trusted after 2 runs" is hiding the most consequential thing an author changed.

Depends on nothing; ISE-723 makes it visible and ISE-722 gave it the single `proven_standing` seam to read from.
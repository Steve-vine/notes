---
id: 01M02PRJA5TA8VJPDXWT92RFB2
created: 2026-08-15T12:36:17.861363Z
updated: 2026-08-15T12:36:17.861363Z
type: task
title: A playbook's promotion and demotion bars are platform constants — they belong in its envelope
assignee: steve
task_status: backlog
priority: medium
label: improvement
project: 01KX671DATY39VW6GWK3M2T3DN
number: 735
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
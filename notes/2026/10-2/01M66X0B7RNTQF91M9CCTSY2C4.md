---
id: 01M66X0B7RNTQF91M9CCTSY2C4
created: 2026-10-30T17:16:32.888184Z
updated: 2026-10-30T17:16:32.888184Z
type: memo
title: Compass testing capability — what is automated after sprint 99 (Browser Testing)
project: 01KXGC5PTGYHV30VM3E78G76S1
---
Written 2026-10-30, after sprint 99 "Browser Testing" (ADR 0135). It updates the testing-layers review of 2026-10-29.

**In short:** sprint 99 automated the two layers that were weak or missing: **end-to-end testing** and **real smoke testing**. Both run after every staging deploy. Exploratory testing and a first pass at UAT are now done by Claude in a browser, but aren't automated. Performance, accessibility, security and operational gaps are unchanged.

## By testing layer

| Testing | Automated now? | What's in place now |
|---|---|---|
| **Unit testing** | ✅ Yes, unchanged | Runs on every PR. Nothing merges until it passes. |
| **Static analysis** | ✅ Yes, unchanged | Type checks, linting, security code scan, secret scan and vulnerable-library scan on every PR. The browser tests' own code is checked the same way. |
| **Code review** | ◐ Partly, unchanged | Automated checks only. No second person reads the code. |
| **Integration, inside Compass** | ✅ Yes, unchanged | Tests against a real database on every PR. |
| **Integration with outside systems** | ◐ Partly, unchanged | Still tested against stand-ins, not the real Microsoft 365, AD or clouds. The browser tests deliberately stay away from live connections. |
| **System testing** | ◐ Partly, better | New: after each sprint reaches staging, Claude checks every task's "Done when" on the deployed site and comments Passed, Failed or Couldn't check. Done by Claude, not automated. It isn't independent of the builder either. |
| **End-to-end testing** | ✅ **Yes, new** | Six journeys through the real screens after every staging deploy (below). |
| **Regression testing** | ✅ Yes, wider | Every PR still runs the full suite. New: the browser suite re-runs after every deploy, so a screen that breaks only once deployed is caught. It turns the deploy red but doesn't block a merge. |
| **Smoke testing** | ✅ **Yes, much deeper** | Before, it only checked the app was up. Now, after every deploy, each of the 7 test accounts signs in and opens every screen and tab in its menu. Each role is checked to see only what it should. Proven to go red when a screen is broken (2026-10-30). |
| **Sanity testing** | ✅ Yes, unchanged | Every fix goes through the full PR suite, and now the browser check after deploy too. |
| **Exploratory testing** | ◐ Done by Claude, not automated | Claude drives a browser on staging as any test account and reads the test mailbox. What it finds can become a permanent scripted test. |
| **UAT** | ✗ Stays with Steve | Claude's pre-UAT pass means what reaches Steve should already work. Sign-off is Steve's; Claude never moves a task to Done. |
| **Performance / load testing** | ✗ No | Nothing measures speed under load. The browser suite exposed the API's memory growth (COM-1457, fixed 2026-10-30), but only by accident. |
| **Security testing** | ◐ Partly, unchanged | Code scanning only. No attack testing against the running app, no pen test. |
| **Accessibility testing** | ✗ No | No screen-reader, keyboard or automated accessibility checks. |
| **Browser compatibility** | ◐ Partly, new | Automated in Chrome's engine only. Safari, Firefox and Edge aren't checked. |
| **Operational acceptance** | ◐ Partly, unchanged | Every staging deploy rehearses a real deployment. Restoring from backup has never been rehearsed. |

## The six automated journeys

All run in E2E Test Company:

1. Assess a control and raise a gap against it.
2. Add a risk, score it, treat it and link the gap.
3. Record an incident and take it through to closed, with its review.
4. Send the test vendor a questionnaire, follow the emailed link as the supplier, answer it in the vendor portal, and see the answers frozen in Compass.
5. One administrator raises an access request (a leaver for the test person Compass Test). They can't approve it, and the second administrator rejects it.
6. Draft a policy, add and reorder its sections, then delete it. It's never published.

## Limits

- **Nothing reaches a real system.** No access request is ever approved, validated or expedited, and no Playbook content is published. While the suite runs, all email goes to the test mailbox (the mail catcher switch, COM-1467).
- **No Polaris AI.** Anything that needs it is "Couldn't check" in the pre-UAT pass, for Steve to look at.
- **Not a gate for code changes.** A failure turns the staging deploy red and is fixed forward. Making the browser tests a PR gate is a separate decision.

## Biggest remaining gaps

1. A backup restore drill.
2. An external penetration test.
3. Accessibility checks.

Related: ADR 0135, COM-1446..1452, COM-1458, COM-1467, COM-1457.
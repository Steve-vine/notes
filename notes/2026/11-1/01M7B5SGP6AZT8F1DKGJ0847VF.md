---
id: 01M7B5SGP6AZT8F1DKGJ0847VF
created: 2026-11-13T19:22:45.830225Z
updated: 2026-11-14T10:26:49.712723Z
type: task
title: 'A new check under review shows its control as the control page does: ref, title, What this means, What good looks like, Evidence to collect'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1803
sprint: spsp226
blocked_by:
- 01M7AKAHNNRFAAG07ZH7278E0K
comments:
- id: 01M7BN7WKWEE9YB11P5PQD676F
  author: Steve Vine
  at: 2026-11-13T23:52:45.43242Z
  text: |-
    Done — PR #1800 (auto-merge on). Frontend only, with no API change.
    - On Checks ▸ Review, a new check, a change to a live check and a can't-be-automated answer each open with their control at the top of the card: the ref and title (linking to the control), then What this means, What good looks like and Evidence to collect. The check or answer follows underneath. Other kinds of card are unchanged.
    - It's the control page's own guidance block, now shared, so wording and layout match. It starts open and can be hidden. Once hidden it stays hidden as you step through the list, until Show guidance.
    - A section with no guidance is left out. This now applies on the control page too: a control missing one section shows the two it has instead of the whole text as plain markdown. Guidance with no section labels still shows whole.
    - On those cards the ref and title moved from the card's title bar into the block, so they aren't shown twice.
    Tests added. eslint, tsc and prettier are clean, and the checks tests pass.
- id: 01M7BVA1DPGQJFJ08ZEAVJTN6E
  author: Steve Vine
  at: 2026-11-14T01:38:47.350305Z
  text: |-
    Pre-UAT: Passed, except two parts I couldn't show on staging (build 694d62c1, E2E Test Company, E2E Admin A).

    Steps and what I saw:
    - On Checks ▸ Review ▸ Changes I opened the waiting change (CHK-3 on ACC.13). The card opens with ACC.13 and its title (a link to the control), then What this means, What good looks like and Evidence to collect, with "Polaris proposes CHK-3" underneath. The ref and title are not repeated in the card's title bar.
    - On Review ▸ New checks I opened CHK-1 on ACC.13. It has the same block at the top, and the check follows underneath.
    - I set the two cards beside ACC.13's own page. The wording, the "What this means" lead and the two boxes ("What good looks like" and "Evidence to collect") match.
    - Hide guidance folds the block down to the ref and title, with Show guidance to bring it back. When I switched from Changes to New checks the next card opened with the guidance showing again. Each list is one item long, so I couldn't step through several cards. Fine if "stays hidden" is meant to last only within one list.
    - Browser smoke is green on this build (32/32).

    Couldn't check:
    - A can't-be-automated answer waiting in Review. There is none on staging: Review has only Changes, New checks and Audit flags. Steve: when Polaris next proposes a manual-only answer, open it on Review and check that the control block is at the top.
    - A control with a missing guidance section. Every control in the library has all three sections, and I didn't add or edit a Playbook control to make one. Steve: if a real control is missing a section, check that its page and its review card show only the sections it has.

    Screenshots: ~/compass-uat/spsp226/COM-1803/
assignee: steve
label:
- feature
priority: medium
task_status: done
---
Steve, 2026-11-13, reviewing Moneypenny's FreshService and SentinelOne proposals.

## What people see

When a new check is opened on Checks ▸ Review (from the list, COM-1795), the top of the card shows the control it evidences exactly as the control's own page shows it:
- the ref and title, linking to the control
- **What this means**
- **What good looks like**
- **Evidence to collect**

This uses the same guidance block as the control page, so the wording and layout match. Long guidance can be collapsed and starts open. The check itself (name, what it shows, reads, sample) follows underneath. The same applies to a change to a live check and to a can't-be-automated answer.

## Done when

- A new check, a change and a manual-only item each show their control's ref, title and three guidance sections, matching the control page.
- A control with no guidance in a section leaves that section out rather than showing it empty.
- There's a test, and the Browser smoke passes.

**Independent** (frontend; uses the control's existing guidance). After COM-1795.
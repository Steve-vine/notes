---
id: 01M72VZ6BHGM17QTNM9X5AVQ34
created: 2026-11-10T13:57:10.64172Z
updated: 2026-11-25T14:18:17.812012Z
type: task
title: UK GDPR crosswalk completeness review — every library control that serves a requirement is linked to it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1675
comments:
- id: 01M89BWK4TZ5Y8CGG69XDE56MX
  author: Steve Vine
  at: 2026-11-25T12:46:31.066112Z
  text: |-
    PR #2166 (stacked on COM-1680 #2165).

    All 66 assessable duties reviewed against the ICO's expectations. 43 gain links, 23 needed nothing. 231 links added (194 → 425), 128 controls new to UK GDPR, all partial, each graded with a note. The 43 fully / 23 partly split is unchanged.

    What was missing: the privacy controls added in COM-1670 were never linked — data protection role (Art. 37–39, 5(2), 24), purposes (5(1)(b), 8A), privacy by design (25, 5(1)(c)), the notice (12–14), explicit consent (9, 7, 10), processor help with rights (28(3)) — plus data protection training; breach reporting routes and communications (33, 34); processor agreements and monitoring (28).

    A judgement for you: Art. 32(1)(b) now links about 60 controls at strength 2–3 — essentially the whole security programme, which is what the ICO reads Art. 32 as asking for. If that reads as a pile on screen, it's the one to trim.

    Stale notes now (not changed) — the gap they describe is filled by a newly linked control: Art. 8A ("no control records the compatibility judgement"), Art. 9 ("no control records the separate condition"), Art. 37 ("no control designates a DPO"), Art. 25(1) ("security by design, not privacy by design"), 25(2) and 5(1)(c), 28(3) (rights-request help; acting only on instructions is still a gap), Art. 38 (independence, partly).

    Now look jointly complete (not declared): Art. 8A, Art. 25(1), Art. 37 (close).
assignee: steve
label:
- improvement
priority: medium
task_status: done
---
Follows the SOC 2 finding (COM-1669, `audit/soc2-mapping.md`): COM-428 built every crosswalk requirement-first, choosing the smallest set of controls that satisfies each requirement, and the tests check coverage, not completeness. So relevant library controls can be missing from a requirement.

The articles are broad (Art. 32 security of processing especially), so review each against what the ICO expects and link every library control that serves it, graded the same way as today. Edit `data/mappings/uk-gdpr.csv` only; the deploy-time importer applies it. Data only. **Independent.**

**Done when:** every requirement has been reviewed, the additions are graded with notes, and the crosswalk tests are green.
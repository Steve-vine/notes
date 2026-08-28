---
id: 01M14J0XYB668T6MEFBYKHRNR6
created: 2026-08-28T16:07:39.723618Z
updated: 2026-08-28T17:56:05.001278Z
type: task
title: Every framework reads 100% covered — and the figure still means something afterwards
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 484
sprint: s31sysr
comments:
- id: 01M14R75D69BJKQ12E1C4HHFVH
  author: Steve Vine
  at: 2026-08-28T17:55:55.430824Z
  text: |-
    Done — PR #480, merged as ac5652c.

    **1,113 of 1,113 assessable requirements across all ten frameworks, nothing ruled out of scope.** Was 1,059.

    | Framework | Before | After |
    |---|---|---|
    | Cyber Essentials (Willow) | 0% | 100% |
    | ISO/IEC 42001 | 89% | 100% |
    | HIPAA | 90% | 100% |
    | ISO 27001:2022 | 95% | 100% |
    | SOC 2, CE Danzell | 98% | 100% |
    | NIST CSF 2.0 | 99% | 100% |
    | PCI DSS, CIS v8, CIS v8.1 | 100% | 100% |

    **The guardrail went in first, as the task asked.** A test now rejects `coverage_complete` on a set that is entirely `intersects_with` — an overlap names no portion, so no number of them sums to a whole, whereas `subset_of` rows each doing part of the job legitimately do. All 108 pre-existing declarations already respected it, so it locks in behaviour rather than inventing it. A second test asserts every assessable requirement is fully covered, so a future crosswalk edit that loses a framework's cover fails in CI rather than on a dashboard.

    **Willow was not the risk it looked like.** It was 31 of the 54 gaps and sat at 0% — the last surviving piece of the pre-COM-428 keyword match. COM-428 left it alone because re-grading it from Danzell's mapping "would put a claim nobody made into a historic assessment". On inspection **30 of its 31 requirements are word-for-word identical to Danzell's**, so for those the graded answer is the same claim, not a new one. `UAC5` is the real exception — Willow's "where available" is broader than Danzell's "on all cloud services" — so it is graded on its own wording. Posture derives live through the crosswalk and nothing is snapshotted, so this does change what a historic Willow assessment reports. That is the consequence of the no-exclusions instruction, taken deliberately.

    **Twelve sets declared complete**, each with a note. Three I would not sign off as they stood, so they were strengthened rather than flagged over a gap: `A.8.26` gained the vendor requirement for the *acquiring* half of the clause, `A.8.30` the review that monitors outsourced development, and SOC 2 `CC5.3` the procedures and role-specific training that policy alone does not carry.

    **Four new controls**, where flags could not help:
    - `AIG.17` — the AI management system is audited, reviewed and improved on the existing cycle. Closes 42001's `4.4`, `9.2`, `9.3` and `10.1`, which all failed for one reason: audit and management review were scoped to information security. A scope extension, not the AI-flavoured duplicate COM-431 avoided.
    - `RIM.8` — opportunities assessed alongside risks, closing CSF `GV.RM-07`.
    - `ACC.15` — a regulated business function separated in access, not in policy.
    - `VEM.15` — the governing documents of a scheme run by a related party.

    The last two are the HIPAA clearing-house and group-health-plan requirements normally ruled out of scope. Writing them is the stated price of the rule, and the Core library now carries controls most companies will never perform.

    **Verified against a populated database** migrated from main and seeded first: every framework reaches 100% except one requirement where I had planted a curator's contrary decision, which survived untouched. The seed declares; it never overrules a person (ADR 0028). On a real deployment that is expected behaviour, not a shortfall — so if a requirement shows short on staging, check whether someone has recorded a decision on it.

    No migration: the crosswalk is seed data, and the importer sets the flag only where nothing has ever recorded a decision.
assignee: steve
company:
- moneypenny
label:
- feature
priority: high
task_status: review
---
**The only successful outcome is 100% cover on every framework, with nothing ruled
out of scope.** Not "nearly", not "except the sector-specific ones", and not achieved
by marking a requirement not applicable. Every assessable requirement in all ten
frameworks reads fully covered, on the merits.

## Where it stands

| Framework | Cover | To close |
|---|---|---|
| PCI DSS 4.0.1 | 100% | — |
| CIS v8.1 (and superseded v8) | 100% | — |
| NIST CSF 2.0 | 99% | 1 |
| Cyber Essentials (Danzell v3.3) | 98% | 1 |
| SOC 2 TSC | 98% | 1 |
| ISO 27001:2022 | 95% | 6 |
| HIPAA | 90% | 7 |
| ISO/IEC 42001 | 89% | 7 |
| **Cyber Essentials (Willow, superseded)** | **0%** | **31** |

**1,059 of 1,113 assessable requirements — 54 to close.** Fifty of those have mappings
that do not add up to a whole; four have no mapping at all.

## The guardrail — read this before starting

100% is trivially reachable by declaring every partial set complete, and doing that
would destroy the only thing the figure is for. COM-428 rebuilt this crosswalk
precisely because the old one reported coverage it did not have.

So the rule: **a requirement may not be declared complete on a set that is entirely
`intersects_with`.** An overlap is not a portion — a pile of overlaps never sums to a
whole, whereas `subset_of` rows each doing part of the job legitimately do. This
already holds across all 108 existing declarations, so **add it as a test first**, and
let it constrain the work rather than be checked at the end.

Every new declaration carries a note saying why the set closes the requirement. If a
set cannot be closed honestly, that is the discovery of a missing control — write the
control, do not flag the set.

## The work, in four parts

**1. Cyber Essentials Willow — 31, and it needs a decision first.** Willow is the last
surviving piece of the pre-COM-428 keyword match: 31 rows, one control each, every one
`intersects_with`, no strengths, no notes worth the name. It reads 0% because an
overlap never discharges anything. COM-428 left it alone deliberately — the reasoning
was that re-grading Willow from Danzell's mapping would put a claim nobody made into a
historic assessment. That reasoning has to be either honoured or overturned, and this
task cannot start on Willow until it is. **Decide first**, then either re-grade it
properly or retire the superseded version from the coverage view — but note that
retiring it is a framework-level exclusion, which is close enough to the thing this
task forbids that it needs to be a conscious choice rather than a shortcut.

**2. The curation pass — 12.** ISO 27001 (6), HIPAA (4), SOC 2 `CC5.3`, Cyber
Essentials Danzell `MP2`. Each already has two to four `subset_of` controls at decent
strength and looks like it closes; nobody has said so. This is the cheapest and
highest-value part, it touches four frameworks, and it is a screen job rather than a
code one. Expect one or two of the twelve to turn out not to close — that is the
point of doing it by hand.

**3. ISO 42001's management-system clauses — 7.** `4.4`, `9.2`, `9.3` and `10.1` all
fail for one reason: internal audit, management review and continual improvement are
scoped to information security, not to the AI management system. **One new `AIG`
control** — the AIMS is audited, reviewed and improved on the existing cycle — closes
all four honestly, and it is a scope extension rather than the AI-flavoured duplicate
COM-431 was careful to avoid. `4.1`, `4.2` and `7.1` need their own answer: they are
context, interested parties and resources, each currently an ISMS control that only
intersects plus an `AIG` control that only does part.

**4. Four requirements with nothing mapped.**
- **`GV.RM-07`** (NIST CSF) — strategic opportunities, or positive risk. A genuine
  library gap: nothing in Compass treats risk as anything but downside. Needs a
  control, and it belongs with the risk module rather than bolted on.
- **HIPAA `164.308(a)(4)(ii)(A)`, `164.314(b)(1)`, `164.314(b)(2)`** — isolating
  clearing house functions, and the two group health plan requirements. These are the
  ones that would normally be ruled out of scope, and this task forbids that. Worth
  knowing the cost before writing them: the Core library gains controls describing
  health-plan and clearing house operations that most companies will never perform.
  That is the price of the no-exclusions rule, and it is a deliberate price, not an
  oversight.

## Done when

- Every framework reports 100% cover, on a fresh database and on staging.
- No requirement was marked not applicable to get there.
- No declaration rests on an all-`intersects_with` set, enforced by a test.
- Every new declaration carries a note saying why it closes.
- The seeded crosswalk is regenerated so a fresh install lands in the same place.